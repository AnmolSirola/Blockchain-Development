// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.7;

contract pay{

    function payEther() public payable {    
    }
    
    function check_balance() public view returns(uint){
        return address(this).balance;
    }
}
