// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CLSToken {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Burn(address indexed from, uint256 value);
    event Mint(address indexed to, uint256 value);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    address public owner;

    bool public paused = false;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    constructor() {
        name = "CLASS Token";
        symbol = "CLS";
        decimals = 18;
        totalSupply = 50000000 * 10**uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;

        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function transfer(address to, uint256 value) external whenNotPaused returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= balanceOf[msg.sender], "ERC20: insufficient balance");

        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) external whenNotPaused returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external whenNotPaused returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(value <= balanceOf[from], "ERC20: insufficient balance");
        require(value <= allowance[from][msg.sender], "ERC20: insufficient allowance");

        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        return true;
    }

    function allowanceOf(address owner, address spender) external view returns (uint256) {
        return allowance[owner][spender];
    }

    function burn(uint256 value) external onlyOwner whenNotPaused returns (bool) {
        require(value <= balanceOf[msg.sender], "ERC20: insufficient balance for burning");

        balanceOf[msg.sender] -= value;
        totalSupply -= value;

        emit Burn(msg.sender, value);
        emit Transfer(msg.sender, address(0), value); // Burning transfers tokens to the zero address.

        return true;
    }

    function mint(address to, uint256 value) external onlyOwner whenNotPaused returns (bool) {
        totalSupply += value;
        balanceOf[to] += value;

        emit Mint(to, value);
        emit Transfer(address(0), to, value);

        return true;
    }

    function pause() external onlyOwner {
        paused = true;
    }

    function unpause() external onlyOwner {
        paused = false;
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "New owner cannot be the zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
