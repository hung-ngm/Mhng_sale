const MhngToken = artifacts.require("./MhngToken.sol");
const MhngTokenSale = artifacts.require("./MhngTokenSale.sol");

module.exports = function (deployer) {
  deployer.deploy(MhngToken, 1000000).then(() => {
    // Token Price is 0.001 ether
    var tokenPrice = 1000000000000000;
    return deployer.deploy(MhngTokenSale, MhngToken.address, tokenPrice);
  });
  
};

