pragma solidity 0.8.19;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";
// import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
// import {ISushiswapV2Router02} from "@sushiswap/core/contracts/uniswapv2/interfaces/ISushiswapV2Router02.sol";
// import {IUniswapV2Router02} from "@uniswap/v3-pri"
import {ISwapRouter} from "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

contract FlashLoan is FlashLoanSimpleReceiverBase {
    address payable owner;
    ISwapRouter uniswapRouter;

    // ISushiswapV2Router02 sushiswapRouter;

    constructor(
        address _addressProvider,
        address _uniswapRouter,
        address _sushiswapRouter
    ) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
        uniswapRouter = ISwapRouter(_uniswapRouter);
        // sushiswapRouter = ISushiswapV2Router02(_sushiswapRouter);
    }

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Example arbitrage logic
        uint256 amountToTrade = amount;

        // Approve Uniswap and Sushiswap to spend our tokens
        IERC20(asset).approve(address(uniswapRouter), amountToTrade);
        // IERC20(asset).approve(address(sushiswapRouter), amountToTrade);

        // Step 1: Buy on Uniswap
        address;
        // path[0] = asset; // Token we borrowed
        // path[1] = uniswapRouter.WETH(); // Token we want to trade to

        // uint[] memory amountsOut = uniswapRouter.swapExactTokensForETH(
        //     amountToTrade,
        //     1, // Accept any amount of ETH
        //     path,
        //     address(this),
        //     block.timestamp
        // );

        // uint256 ethReceived = amountsOut[1];

        // // Step 2: Sell on Sushiswap
        // path[0] = sushiswapRouter.WETH();
        // path[1] = asset;

        // amountsOut = sushiswapRouter.swapExactETHForTokens{value: ethReceived}(
        //     1, // Accept any amount of tokens
        //     path,
        //     address(this),
        //     block.timestamp
        // );

        // uint256 tokensReceived = amountsOut[1];

        // Ensure we have enough tokens to repay the flash loan
        uint256 amountOwed = amount + premium;
        // require(tokensReceived > amountOwed, "Arbitrage failed, no profit");

        // Approve the Pool contract allowance to *pull* the owed amount
        IERC20(asset).approve(address(POOL), amountOwed);

        // Transfer profit to the owner
        // IERC20(asset).transfer(owner, tokensReceived - amountOwed);

        return true;
    }

    function requestFlashLoan(
        address _token,
        uint256 _amount
    ) public onlyOwner {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(
            receiverAddress,
            asset,
            amount,
            params,
            referralCode
        );
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 token = IERC20(_tokenAddress);
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}
}
