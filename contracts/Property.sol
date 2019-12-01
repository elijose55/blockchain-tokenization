pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract Property is ERC20 {
	address[16] public adopters;

	address[] internal stakeholders;

	string public name = "PropertyToken";
	string public symbol = "RST";
	uint8 public decimals = 3;
	uint public INITIAL_SUPPLY = 1000;

	uint public tokenSupply;
	uint public propertyValue;
	address payable public ownerAddress;
	

	constructor(address _owner, uint _value, uint _supply) public {

	  _mint(_owner, _supply);
	  require(_value > 0, "property value has to be greater than 0");
	  require(_supply > 0, "token supply has to be greater than 0");

	  propertyValue = _value;
	  tokenSupply = _supply;
	  ownerAddress = _owner;


	}

	// Adopting a pet
	function adopt(uint petId) public returns (uint) {
		require(petId >= 0 && petId <= 15);
		adopters[petId] = msg.sender;
		return petId;
	}

	// Retrieving the adopters
	function getAdopters() public view returns (address[16] memory) {
		return adopters;
	}

}