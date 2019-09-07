const PoseidonToken = artifacts.require("PoseidonToken");
const TestConsumerBase = artifacts.require("ATestnetConsumer");

module.exports = function(deployer) {
  deployer.deploy(PoseidonToken, 1000000000000000).then(()=>
    {
      return deployer.deploy(TestConsumerBase, PoseidonToken.address);
    }
  );
};
