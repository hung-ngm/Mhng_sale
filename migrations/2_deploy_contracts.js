const MhngToken = artifacts.require("./MhngToken.sol");

module.exports = function (deployer) {
  deployer.deploy(MhngToken);
};