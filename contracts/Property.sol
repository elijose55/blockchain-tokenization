pragma solidity ^0.5.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract Property is ERC20 {
	address[16] public adopters;

	address[] internal stakeholders;

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