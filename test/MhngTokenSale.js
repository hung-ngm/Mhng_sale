var MhngTokenSale = artifacts.require("./MhngTokenSale.sol");
var MhngToken = artifacts.require("./MhngToken.sol");

contract('MhngTokenSale', (accounts) => {
  var tokenSaleInstance;
  var tokenInstance;
  var admin = accounts[0];
  var tokensAvailable = 750000;
  var tokenPrice = 1000000000000000; // in wei
  var buyer = accounts[1]
  var numberOfTokens;

  it('initializes the contract with correct values', () => {
    return MhngTokenSale.deployed().then((instance) => {
      tokenSaleInstance = instance;
      return tokenSaleInstance.address
    }).then((address) => {
      assert.notEqual(address, 0x0, 'has contract address')
      return tokenSaleInstance.tokenContract();
    }).then((address) => {
      assert.notEqual(address, 0x0, 'has token contract address')
      return tokenSaleInstance.tokenPrice()
    }).then((price) => {
      assert.equal(price, tokenPrice, 'token price is correct')
    })
  })

  it('facilitates token buying', () => {
    return MhngToken.deployed().then((instance) => {
      tokenInstance = instance;
      return MhngTokenSale.deployed()
    }).then((instance) => {
      tokenSaleInstance = instance;
      // Provision 75% of all tokens to tokens sale
      return tokenInstance.transfer(tokenSaleInstance.address, tokensAvailable, { from: admin })
    }).then((receipt) => {
      numberOfTokens = 10;
      return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: numberOfTokens * tokenPrice })
    }).then((receipt) => {
      assert.equal(receipt.logs.length, 1, 'triggers one event');
      assert.equal(receipt.logs[0].event, 'Sell', 'should be the "Sell" event');
      assert.equal(receipt.logs[0].args._buyer, buyer, 'logs the account of the purchased tokens');
      assert.equal(receipt.logs[0].args._amount, numberOfTokens, 'logs the number of tokens purchased');
      return tokenSaleInstance.tokensSold()
    }).then((amount) => {
      assert.equal(amount.toNumber(), numberOfTokens, 'increments the number of tokens sold');
      return tokenInstance.balanceOf(buyer)
    }).then((balance) => {
      assert.equal(balance.toNumber(), numberOfTokens);
      return tokenInstance.balanceOf(tokenInstance.address)
    }).then((balance) => {
      assert.equal(balance.toNumber(), tokensAvailable - numberOfTokens);
      return tokenSaleInstance.buyTokens(numberOfTokens, { from: buyer, value: 1 })
    }).then(assert.fail).catch((error) => {
      assert(error.message, 'msg.value must equal the number of tokens in wei')
      return tokenSaleInstance.buyTokens(800000, { from: buyer, value: numberOfTokens * tokenPrice })
    }).then(assert.fail).catch((error) => {
      assert(error.message, 'cannot purchase more than available')
    })
  })
})