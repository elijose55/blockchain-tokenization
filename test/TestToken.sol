pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Property.sol";

contract TestToken {
 // The address of the adoption contract to be tested
 Property property = Property(DeployedAddresses.Property());

 // The id of the pet that will be used for testing
 uint expectedPetId = 8;

 //The expected owner of adopted pet is this contract
 address expectedAdopter = address(this);
 //console.log(address());


// Testing the adopt() function
function testUserCanAdoptPet() public {
  uint returnedId = property.adopt(expectedPetId);

  Assert.equal(returnedId, expectedPetId, "Adoption of the expected pet should match what is returned.");
}

// Testing retrieval of a single pet's owner
function testGetAdopterAddressByPetId() public {
  address adopter = property.adopters(expectedPetId);

  Assert.equal(adopter, expectedAdopter, "Owner of the expected pet should be this contract");
}

// Testing retrieval of all pet owners
function testGetAdopterAddressByPetIdInArray() public {
  // Store adopters in memory rather than contract's storage
  address[16] memory adopters = property.getAdopters();

  Assert.equal(adopters[expectedPetId], expectedAdopter, "Owner of the expected pet should be this contract");
}


// Testing the adopt() function
function testGetTokenPrice() public {
  uint returnedPrice = property.getTokenPrice();
  //console.log(returnedPrice);

 	//console.log('address(this)');

  Assert.equal(returnedPrice, 100000, "Price not equal.");
}



}

