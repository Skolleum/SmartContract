pragma solidity ^0.4.24;

import "./BasicToken.sol";
import "./StandardToken.sol";
import "./Ownable.sol";


contract MeterManagement is BasicToken, Ownable, StandardToken {
    
    mapping(address=>address) public meterToOwner; 
    mapping(address=>address[]) public ownerToMeter; 
    
    address[] public meters;

    event Burn(address indexed burner, uint256 value); 
    event Mint(address indexed to, uint256 amount); 

    modifier hasMintPermission() { 
        require(meterToOwner[msg.sender] != 0 ||
        msg.sender == owner);
        _;
    }
    
    modifier onlyMeterOwner(address _meterAddress){
        require(meterToOwner[_meterAddress] == msg.sender);
        _;
    }
    function enroleMeter(address _meterAddress, address _ownerAddress)
        onlyOwner
        public
    {
        meterToOwner[_meterAddress] = _ownerAddress; 
        ownerToMeter[_ownerAddress].push(_meterAddress); 
        meters.push(_meterAddress);
    }
    
    function transferMeterOwnership(address _meterAddress, address _newOwnerAddress)
        onlyMeterOwner(_meterAddress)
        public
    {
        meterToOwner[_meterAddress] = _newOwnerAddress;
        ownerToMeter[_newOwnerAddress].push(_meterAddress);
    }
  

    function burn(uint256 _value) public { 
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal {
        require(_value <= balances[_who]);
       
        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value); 
        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }

     
    function mint(uint256 _amount)
        public
        hasMintPermission
        returns (bool)
    {
        totalSupply_ = totalSupply_.add(_amount); 
        balances[msg.sender] = balances[msg.sender].add(_amount); 
        increaseApproval(meterToOwner[msg.sender], _amount); 
        emit Mint(msg.sender, _amount);
        emit Transfer(address(0), msg.sender, _amount);
        return true;
    }
    
   
    function mintTo(uint256 _amount, address _recipient)
        public
        onlyOwner
        returns (bool)
    {
        totalSupply_ = totalSupply_.add(_amount); 
        balances[_recipient] = balances[_recipient].add(_amount); 
        increaseApproval(meterToOwner[_recipient], _amount); 
        emit Mint(_recipient, _amount);
        emit Transfer(address(0), _recipient, _amount);
        return true;
    }
    
   
    function getAllMeters()
        public
        view
        returns (address[])
    {
        return meters;
    }
    
  
    function getAllMetersForOwner(address _owner)
        public
        view
        returns (address[])
    {
        return ownerToMeter[_owner];
    }
}