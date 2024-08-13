const { ethers } = require("ethers");
const { Dex } = require("./dex");

class Uniswap extends Dex {
  constructor() {
    super("Uniswap");
    this.pairAddress = "0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc";
    this.pairAbi = [
      "function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast)",
    ];
    this.contract = new ethers.Contract(
      this.pairAddress,
      this.pairAbi,
      this.provider
    );
  }

  async getPrice() {
    console.log(this.contract.getReserves());
  }

  // async getPrice(tokenAAddress) {
  //   // const TOKEN_A = new Token(this.chainId, tokenAAddress, 18);
  //   // const TOKEN_B = new Token(this.chainId, tokenBAddress, 18);

  //   const TOKEN_A = await Fetcher.fetchTokenData(
  //     this.chainId,
  //     tokenAAddress,
  //     this.provider
  //   );
  //   const WETH = await Fetcher.fetchTokenData(
  //     this.chainId,
  //     "0x4200000000000000000000000000000000000006",
  //     this.provider
  //   );

  //   const pair = await Fetcher.fetchPairData(TOKEN_A, WETH, this.provider);
  //   console.log(pair);
  // }
}

module.exports = Uniswap;
