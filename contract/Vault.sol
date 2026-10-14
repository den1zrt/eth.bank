// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./Token.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC4626Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Vault is Initializable, ERC4626Upgradeable, UUPSUpgradeable{
    string public title;
    uint public managingAssets;
    address public owner;
    BorrowToken public borrowToken;

    modifier onlyOwner(){
        require(msg.sender == owner, "Not allowed");
        _;
    }

    function initialize (string memory _title, string memory _shareName, string memory _shareSymbol, address _borrowToken) initializer external {
        __ERC4626_init(IERC20(_borrowToken));
        __ERC20_init(_shareName, _shareSymbol);
        title = _title;
        borrowToken = BorrowToken(_borrowToken);
        owner = msg.sender;
    }

    function totalAssets() public override view returns (uint){
        return managingAssets;
    }

    function depositTokens(uint _amount) external {
        require(_amount >= 10, "too small");
        borrowToken.transferTokens(msg.sender, address(this), _amount);
        uint256 shares = previewDeposit(_amount);
        _mint(msg.sender, shares);
        managingAssets += _amount;
    }

    function getInfo() public view returns(string memory, string memory, uint256){
        return (title, name(), managingAssets);

    }
    function withdrawTokens(uint256 _amount) external {
        uint256 assets = previewDeposit(_amount);
        borrowToken.transferFrom(address(this), msg.sender, _amount);
        _burn(msg.sender, assets);
        managingAssets -= _amount;
    }
    function addReward(uint256 _amount) external {
        managingAssets += _amount;
    }
    function _authorizeUpgrade(address) internal override onlyOwner {}
}