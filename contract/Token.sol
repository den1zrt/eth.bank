// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract BorrowToken is ERC20 {

    uint8 decimals_;

    constructor(string memory _name, string memory _sym, uint8 _decimals, address _to) ERC20(_name, _sym) {
        decimals_ = _decimals;
        _mint(_to, 1e36);
    }

    function transferTokens(address from, address to, uint256 value) public {
        _transfer(from, to, value);
    }

    function mint (address to, uint256 value) public {
        _mint(to, value);
    }

    function burn (address to, uint256 value) public {
        _burn(to,value);
    }

    function decimals() public view override returns(uint8){
        return decimals_;
    }
}

contract CollateralToken is ERC20 {

    uint8 decimals_;

    constructor(string memory _name, string memory _sym, uint8 _decimals, address _to) ERC20(_name, _sym) {
        decimals_ = _decimals;
        _mint(_to, 1e36);
    }

    function transferTokens(address from, address to, uint256 value) public{
        _transfer(from, to, value);
    }

    function mint (address to, uint256 value) public {
        _mint(to, value);
    }

    function burn (address to, uint256 value) public {
        _burn(to,value);
    }

    function decimals() public view override returns(uint8){
        return decimals_;
    }
}

contract BorrowShare is ERC20 {

    uint8 decimals_;

    constructor(string memory _name, string memory _sym, uint8 _decimals) ERC20(_name, _sym) {
        decimals_ = _decimals;
    }

    function mint (address to, uint256 value) public {
        _mint(to, value);
    }

    function transferTokens(address from, address to, uint256 value) public {
        _transfer(from, to, value);
    }

    function burn (address to, uint256 value) public {
        _burn(to,value);
    }

    function decimals() public view override returns(uint8){
        return decimals_;
    }
}