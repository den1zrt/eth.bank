// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BorrowToken is ERC20{
    uint8 private _decimals;
    address private dude;
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint8 decimals_) ERC20 (_name, _symbol){
        _decimals = decimals_;
        dude = msg.sender;
        _mint(dude, _initialSupply * (10 ** decimals_));
    }
    function transferTokens(address _from, address _to, uint256 _amount) public {
        _transfer(_from, _to, _amount * (10 ** _decimals));
    }
    function decimals() public view override returns (uint8) {
        return _decimals;
    }
    function mint(address _to, uint256 _amount) public {
        _mint(_to,_amount * (10 ** _decimals));
    }
    function burn(address _to, uint256 _amount) public {
        _burn(_to, _amount * (10 ** _decimals));
    }
}

contract CollateralToken is ERC20 {
    uint8 private _decimals;
    address private dude;
    constructor (string memory _name, string memory _symbol, uint256 _initialSupply, uint8 decimals_) ERC20 (_name, _symbol) {
        _decimals = decimals_;
        dude = msg.sender;
        _mint(dude, _initialSupply * (10 ** decimals_));
    }

    function transferTokens(address _from, address _to, uint _amount) public {
        _transfer(_from, _to, _amount);
    }
    function decimals() public view override returns (uint8){
        return _decimals;
    }
    function mint(address _to, uint256 _amount) public {
        _mint(_to,_amount * (10 ** _decimals));
    }
    function burn(address _to, uint256 _amount) public {
        _burn(_to, _amount * (10 ** _decimals));
    }
}

contract BorrowShare is ERC20 {
    uint8 private _decimals;
    address private dude;
    constructor (string memory _name, string memory _symbol, uint256 _initialSupply, uint8 decimals_) ERC20 (_name, _symbol) {
        _decimals = decimals_;
        dude = msg.sender;
        _mint(dude, _initialSupply * (10 ** decimals_));
    }

    function transferTokens(address _from, address _to, uint _amount) public {
        _transfer(_from, _to, _amount);
    }
    function decimals() public view override returns (uint8){
        return _decimals;
    }
    function mint(address _to, uint256 _amount) public {
        _mint(_to,_amount * (10 ** _decimals));
    }
    function burn(address _to, uint256 _amount) public {
        _burn(_to, _amount * (10 ** _decimals));
    }
}
