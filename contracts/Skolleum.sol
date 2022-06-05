pragma solidity ^0.4.24;

import "./MeterManagement.sol";

contract Skolleum is MeterManagement {
    string public name = "Skolleum: 1 token = 1kWh";
    string public symbol = "Skolleum";
    uint8 public decimals = 6; 
    
    constructor() public {
        totalSupply_ = 0; 
    }
}