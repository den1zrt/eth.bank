// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "./Token.sol";

contract Vault is Initializable, ERC4626Upgradeable, UUPSUpgradeable {
    string public title;
    BorrowToken borrowToken;
    uint256 managingAssets;
    address public owner;
    uint256 minDeposit_;
    uint16 apy;

    modifier SufficientAmount(uint amount, uint min) {
        require(amount > min, "Value must be greater");
        _;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function initialize (string memory _title, string memory _shareName, string memory _shareSymbol, address _borrowToken) public initializer {
        __ERC4626_init(IERC20(_borrowToken));
        __ERC20_init(_shareName, _shareSymbol);
        title = _title;
        minDeposit_ = 10;
        managingAssets = 0;
        borrowToken = BorrowToken(_borrowToken);
        owner = msg.sender;
        apy = 10;
    }

    
    function depositVault(uint256 amount) public SufficientAmount(amount, 10) {
        uint shares = previewDeposit(amount);
        borrowToken.transferTokens(msg.sender, address(this), amount);
        _mint(msg.sender, shares);
        managingAssets += amount;
    }

    function withdrawVault(uint256 amount) public SufficientAmount(amount, 0) {
        uint shares = previewDeposit(amount);
        borrowToken.transferFrom(address(this), msg.sender, amount);
        _burn(msg.sender, shares);
        managingAssets -= amount;
    }

    function minDeposit() public view returns (uint256) {
        return minDeposit_;
    }

    function totalAssets() public view override returns (uint256) {
        return managingAssets;
    }

    function sendToMarket(address _market, uint256 amount) external {
        require(amount < borrowToken.balanceOf(address(this)), "Insufficient balance in vault");
        
        borrowToken.transferTokens(address(this), _market, amount);
        managingAssets -= amount;
    }

    function addReward(uint amount) external {
        managingAssets += amount;
    }

    function getVault() public view returns (string memory _title, uint256 _availableAssets, uint256 _totalSupply, address _owner, uint256 _minDeposit, uint256 _sharePrice) {
        uint256 sharePrice = totalSupply() != 0 ? managingAssets / totalSupply() : 0;
        return(title, managingAssets, totalSupply(), owner, minDeposit_, sharePrice);

    }

    function _authorizeUpgrade(address) internal override OnlyOwner {}
}