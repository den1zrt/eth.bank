// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Token.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

interface IVault {
    function addReward(uint256 amount) external;
}

contract Market is ERC4626Upgradeable, UUPSUpgradeable{

    string title;
    address owner;
    address vault;
    address treasure;
    uint256 lastAccrueBlock;
    uint256 blocksPerYear;
    uint lltv;
    uint interestRate;
    uint borrowTokenPrice;
    uint collateralTokenPrice;
    uint currentBorrowIndex;
    uint lfee;                              // lender fee
    uint pfee;                              // protocol fee

    BorrowToken borrowToken;
    BorrowShare borrowShare;
    CollateralToken collateralToken;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    function initialize(

            string memory _title, 
            string memory _shareName,
            string memory _shareSymbol,
            address _collateralToken,
            address _borrowToken,
            address _borrowShare,
            address _vault,
            address _treasure,
            uint _lltv,
            uint _interestRate
        ) initializer public {
        __ERC4626_init(IERC20(_collateralToken));
        __ERC20_init(_shareName, _shareSymbol);
        
        owner = msg.sender;
        collateralToken = CollateralToken(_collateralToken);
        borrowToken = BorrowToken(_borrowToken);
        borrowShare = BorrowShare(_borrowShare);
        
        title = _title;
        lastAccrueBlock = block.number;
        blocksPerYear = 2102400;
        lltv = _lltv;
        borrowTokenPrice = 1e18;
        collateralTokenPrice = 1e18;
        currentBorrowIndex = 1e18;
        interestRate = _interestRate * 1e18;
        vault = _vault;
        treasure = _treasure;
    }

    mapping(address => uint) userInterestRate; // ставка на момент займа

    function supply(uint _amount) public {

        accrue();
        collateralToken.transferTokens(msg.sender, address(this), _amount);
        uint sharesToMint = previewDeposit(_amount);
        _mint(msg.sender, sharesToMint);
    }

    function withdraw(uint256 _amount) public {
    require(_amount > 0, "amount has to be greater than zero");
        uint sharesToBurn = previewWithdraw(_amount);
        _burn(msg.sender, sharesToBurn);
        collateralToken.transfer(msg.sender, _amount);
        
    }
    function accrue() public {

        currentBorrowIndex += currentBorrowIndex * interestRate * (block.number - lastAccrueBlock) / blocksPerYear / 1e18;
        lastAccrueBlock = block.number;
    }

    function accruedInterest(address _account) public view returns (uint){
        
        uint borrowShares = borrowShare.balanceOf(_account);
        uint userBorrowIndexAtEntry = userInterestRate[_account];
        return (borrowShares * (currentBorrowIndex - userBorrowIndexAtEntry) / 1e18);
    }

    function borrow(uint _amount) public {
        accrue();
        uint256 borrowSharesToMint = (_amount * 1e18) / currentBorrowIndex;
        userInterestRate[msg.sender] = interestRate;
        borrowShare.mint(msg.sender, borrowSharesToMint);
    }
    function getLTV(address _addr) public view returns (uint){

        uint collateralAmount = convertToAssets(balanceOf(_addr));
        uint borrowAmount = borrowShare.balanceOf(_addr) * userInterestRate[_addr];
        return (borrowAmount * borrowTokenPrice) / (collateralAmount * collateralTokenPrice);
    }

    function repay(uint _amount) public {
        accrue();
        require(_amount > 0, "amount has to be greater than zero");
        uint debt = _amount - accruedInterest(msg.sender);
        require(_amount <= debt);
        borrowToken.transferTokens(msg.sender, vault, (accruedInterest(msg.sender) * lfee) / 100);
        borrowToken.transferTokens(msg.sender, vault, (accruedInterest(msg.sender) * pfee) / 100);
        borrowToken.transferTokens(msg.sender, vault, accruedInterest(msg.sender) / debt);
        IVault(vault).addReward((accruedInterest(msg.sender) * lfee) / 100);
        uint256 sharesToBurn = (_amount * 1e18) / currentBorrowIndex;
        borrowShare.burn(msg.sender, sharesToBurn);

        uint256 remainingDebt = (borrowShare.balanceOf(msg.sender) * userInterestRate[msg.sender] + accruedInterest(msg.sender) - _amount);

        if (remainingDebt == 0) {
            userInterestRate[msg.sender] = 0;
        }
        else {
            userInterestRate[msg.sender] = currentBorrowIndex;
        }
        require(getLTV(msg.sender) < lltv, "LLTV exceed");
    }

    function getMarket() external view returns (
            string memory _title,
            uint256 _lltv,
            uint256 _interestRate,
            uint256 _currentBorrowIndex,
            uint256 _collateralTokenPrice,
            uint256 _borrowTokenPrice,
            address _borrowToken,
            address _asset,
            address _borrowShare
        ) {
            return (
                title,
                lltv,
                interestRate,
                currentBorrowIndex,
                collateralTokenPrice,
                borrowTokenPrice,
                address(borrowToken),
                asset(),
                address(borrowShare)
            );
        }

    function getUserInfo(
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
        )
    {
        return (
            borrowShare.balanceOf(user),
            balanceOf(user),
            userInterestRate[user],
            (borrowShare.balanceOf(user) * userInterestRate[user]) + accruedInterest(user),
            getLTV(user)
        );
    }

    function _authorizeUpgrade(address) internal override onlyOwner{}
}
