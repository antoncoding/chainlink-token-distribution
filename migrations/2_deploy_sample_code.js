const PoseidonToken = artifacts.require("PoseidonToken");

module.exports = function(deployer) {
  deployer.deploy(PoseidonToken, 1000000000000000);
};