const { ethers } = require("ethers");
const { Token, WETH, Fetcher, Route } = require("@uniswap/sdk");

class Dex {
  constructor(name) {
    this.name = name;
    this.provider = new ethers.providers.JsonRpcProvider(
      "https://mainnet.base.org"
    );
    this.chainId = 8453;
  }

  async getPrice(tokenA, tokenB) {
    throw new Error("Method getPrice() must be implemented");
  }
}

module.exports = { Dex };
