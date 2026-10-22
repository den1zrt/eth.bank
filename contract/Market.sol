// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "./Token.sol";

interface IVault {
    function sendToMarket (address _market, uint256 _amount) external;
    function addReward(uint amount) external;
}

contract Market is Initializable, ERC4626Upgradeable, UUPSUpgradeable {
    string public title;
    uint256 public lltv;
    address vault;
    address owner;
    uint256 public borrowSharePrice;
    uint256 public collateralPrice;
    uint256 public interestRate;
    uint256 public currentBorrowIndex;
    uint256 public blocksPerYear;
    uint256 public lastAccrueBlock;
    uint public lfee;
    uint public pfee;
    BorrowToken borrowToken;
    CollateralToken collateralToken;
    BorrowShare borrowShare;


    event Deposited(address _acc, uint256 _amount);
    event Withdrawal(address _acc, uint256 _amount);
    event Borrowed(address _acc, uint256 _amount);
    event Repaid(address _acc, uint256 _amount);

    modifier OnlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    function initialize(
        string memory _title,
        uint _lltv,
        string memory _shareName,
        string memory _shareSymbol,
        uint _collateralPrice,
        uint _interestRate,
        address _vault,
        address _borrowToken,
        address _collateralToken,
        address _borrowShare
    ) public initializer {
        __ERC4626_init(IERC20(_collateralToken));
        __ERC20_init(_shareName, _shareSymbol);

        owner = msg.sender;
        title = _title;
        lltv = _lltv * 1e16;
        vault = _vault;
        collateralPrice = _collateralPrice * 1e18;
        currentBorrowIndex = 1e18;
        borrowSharePrice = 1e18;
        lastAccrueBlock = block.number;
        blocksPerYear = 2_102_400;
        interestRate = _interestRate;
        borrowToken = BorrowToken(_borrowToken);
        collateralToken = CollateralToken(_collateralToken);
        borrowShare = BorrowShare(_borrowShare);
    }

    mapping(address => uint256) userBorrowIndex;

    function accruedInterest(address _acc) public view returns (uint256){
        return (borrowShare.balanceOf(_acc) * (currentBorrowIndex - userBorrowIndex[_acc]) / 1e18);
    }
    function accrue() public {
        if (block.number > lastAccrueBlock){
            currentBorrowIndex += currentBorrowIndex * interestRate * (block.number - lastAccrueBlock) / (blocksPerYear * 1e10); // interestRate n * 1e8
        }
        lastAccrueBlock = block.number;
    }

    function getLTV(address _acc) public view returns (uint256){
        if (balanceOf(_acc) == 0) {
            return 0;
        }
        return (((borrowShare.balanceOf(_acc) * borrowSharePrice * 1e18) / (balanceOf(_acc) * collateralPrice)) );
    }

    function supply(uint256 amount) public {
        accrue();
        uint256 shares = previewDeposit(amount);
        collateralToken.transferTokens(msg.sender, address(this), amount);
        _mint(msg.sender, shares);
    }

    function withdraw(uint256 amount) public {
        accrue();
        uint256 shares = previewWithdraw(amount);
        require(shares <= maxWithdraw(msg.sender), "Insufficient balance");
        collateralToken.transferTokens(address(this), msg.sender, amount);
        _burn(msg.sender, shares);
    }
    
    function borrow(uint256 amount) public {
        accrue();
        uint shares = (amount * 1e18) / borrowSharePrice;
        borrowShare.mint(msg.sender, shares);
        require(getLTV(msg.sender) < lltv, "LTV >= LLTV");
        IVault(vault).sendToMarket(address(this), amount);
        borrowToken.transferTokens(address(this), msg.sender, amount);
        userBorrowIndex[msg.sender] = currentBorrowIndex;
    }

    function repay(uint256 amount) public {
        accrue();
        uint debt = (borrowShare.balanceOf(msg.sender) * borrowSharePrice);
        require(amount > 0, "Insufficient Amount");
        require(amount <= debt, "Too much");

        borrowToken.transferTokens(msg.sender, vault, (accruedInterest(msg.sender) * pfee) / 100);
        borrowToken.transferTokens(msg.sender, vault, (accruedInterest(msg.sender) * pfee) / 100);
        IVault(vault).addReward(accruedInterest(msg.sender));

        userBorrowIndex[msg.sender] = currentBorrowIndex;
        uint shares = (amount * 1e18) / currentBorrowIndex;
        borrowShare.burn(msg.sender, shares);
        if (borrowShare.balanceOf(msg.sender) == 0) {
            userBorrowIndex[msg.sender] = 0;
        }
    }


    function getMarket() public view returns (
        string memory _title,
        uint _lltv,
        uint256 _borrowSharePrice,
        uint256 _collateralPrice,
        uint256 _interestRate,
        uint256 _supplied,
        uint256 _assets,
        uint256 _currentBorrowIndex
    ) {
        uint256 supplied = totalSupply();
        uint256 assets = totalAssets();
    return (
        title,
        lltv,
        borrowSharePrice,
        collateralPrice,
        interestRate,
        supplied,
        assets,
        currentBorrowIndex
        );
    }

    function getUser() public view returns (
        uint256 _borrowTokens,
        uint256 _borrowShares,
        uint256 _collateralTokens,
        uint256 _collateralShares,
        uint256 _userBorrowIndex,
        uint256 _totalDebt,
        uint256 _ltv
    ) {
        uint256 debt = convertToAssets(borrowShare.balanceOf(msg.sender) * borrowSharePrice + accruedInterest(msg.sender));
        return (
        borrowToken.balanceOf(msg.sender),
        borrowShare.balanceOf(msg.sender),
        collateralToken.balanceOf(msg.sender),
        balanceOf(msg.sender),
        userBorrowIndex[msg.sender],
        debt,
        getLTV(msg.sender)
        );
    }

    function _authorizeUpgrade(address) internal override OnlyOwner {}
}