var MhngToken = artifacts.require("./MhngToken.sol")

contract("MhngToken", (accounts) => {

  it("sets the total number upon deployment", () => {
    return MhngToken.deployed().then((instance) => {
      tokenInstance = instance;
      return tokenInstance.totalSupply();
    }).then((totalSupply) => {
      assert.equal(totalSupply.toNumber(), 1000000, 'sets the total supply to 1,000,000');
    })
  })
})