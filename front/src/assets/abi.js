const abi = [
    "function supply (uint256 amount) public",
    "function withdraw(uint256 _amount) public",
    "function accrue() public",
    "function accruedInterest(address _account) public view returns (uint)",
    "function borrow(uint _amount) public",
    "function getLTV(address _addr) public view returns (uint)",
    "function repay(uint _amount) public",
    
    `function getMarket() external view returns (
            string memory _title,
            uint256 _lltv,
            uint256 _interestRate,
            uint256 _currentBorrowIndex,
            uint256 _collateralTokenPrice,
            uint256 _borrowTokenPrice,
            address _borrowToken,
            address _asset,
            address _borrowShare
        )`,
    
    `function getUserInfo(
        address user
    )
        external
        view
        returns (
            uint256 borrowShares,
            uint256 collateralShares,
            uint256 userBorrowIdx,
            uint256 currentDebt_,
            uint256 currentLtv
        )`,

    `function getMarket() external view returns (
            string memory _title,
            uint256 _lltv,
            uint256 _interestRate,
            uint256 _currentBorrowIndex,
            uint256 _collateralTokenPrice,
            uint256 _borrowTokenPrice,
            address _borrowToken,
            address _asset,
            address _borrowShare
        )`
]

export default abi