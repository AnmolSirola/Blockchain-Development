// SPDX-License-Identifier: UNLICENSE

pragma solidity 0.8.7;

contract Even {
    string public str;
    
    event register(address manager, string char);

    function setter(string memory _str) public {
        
        str= _str;
        emit register(msg.sender,str);    
    }            
}
