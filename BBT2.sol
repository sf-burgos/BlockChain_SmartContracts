pragma solidity ^0.4.24;
// ----------------------------------------------------------------------------
// Sample token contract
// Symbol        : BBT2
// Name          : Brayan Burgos Token
// Total supply  : 10000000000000000000
// Decimals      : 18
// Owner Account : 0x96cdaaE707687670085C3835D2086f8670b98CA5
//
// Enjoy.
//
// (c) by Juan Cruz Martinez And Modify by Brayan Steven Burgos Delgado 2020. MIT Licence.
// This modify respect the original author and it's used only academicly. 
// ----------------------------------------------------------------------------
contract SafeMath {

    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }

    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }

    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }

    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
} 
/**
ERC Token Standard #20 Interface
https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
*/
contract ERC20Interface {
    function getRate() public constant returns (uint);
    function balanceOf(address tokenOwner) public constant returns (uint balance);
    function buyToken(address to, uint tokens) public returns (bool success);
    function buyTokenFrom(address from, address to, uint tokens) public returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
contract BBT2Token is ERC20Interface, SafeMath {
    string public symbol;
    string public  name;
    uint8 public decimals;
    uint public _getRate;

    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        symbol = "BBT2";
        name = "Brayan Burgos Token";
        decimals = 18;
        _getRate = 10000000000000000000;
        balances[0x96cdaaE707687670085C3835D2086f8670b98CA5] = _getRate;
        emit Transfer(address(0), 0x96cdaaE707687670085C3835D2086f8670b98CA5, _getRate);
    }
    function getRate() public constant returns (uint) {
        return _getRate  - balances[address(0)];
    }
    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }
    function buyToken(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }
    function buyTokenFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
}
