var Property = artifacts.require("Property");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Property, accounts[0], 1000000, 10);
  deployer.deploy(Property, accounts[1], 2000000, 50);
};