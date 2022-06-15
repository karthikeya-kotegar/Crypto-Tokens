// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

// ERC is Ethereum Request for Comment
//ERC-20 is the protocol used for token.
// ERC-20 is fungible token and can be transfered.
// protocol has 6 function and 2 events.
interface ERC20Interface {
    //mandatory functions
    function totalSupply() external view returns(uint);
    function balanceOf(address tokenOwner) external view returns(uint balance);
    function transfer(address to, uint tokens) external returns(bool success);

    function allowance(address tokenOwner, address spender) external view returns(uint remaining);
    function approve(address spender, uint tokens) external returns(bool success);
    function transferFrom(address from, address to, uint tokens) external returns(bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
} 

// derive the interface
contract Cryptos is ERC20Interface {
    string public name = "crypto";
    string public symbol = "CRPT";
    uint public decimals = 0; //after decimal place. can be 0 to 18
    // since totalSupply is already declared in interface. we must override it.
    uint public override totalSupply;
    address public founder;
    mapping(address => uint) public balances;
    // owner can allow user to transfer amount/tokens
    // ex: 0x111... (owner) allows 0x222.. (user) to withdraw 100 tokens.
    mapping(address => mapping(address => uint)) public allowed;

    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    //balanceOf func interface
    function balanceOf(address tokenOwner) public view override returns(uint balance) {
        return balances[tokenOwner];
    }

    // transfer func interface
    function transfer(address to, uint tokens) public override returns(bool success) {
        // check the balance before transfer
        require(balances[msg.sender] >= tokens, "Insufficiant Balance!");

        // after transfer the balance will increase
        balances[to] += tokens; //recipient
        balances[msg.sender] -= tokens; //sender

        // emit transfer event
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

     // approve the amount/tokens that can be withdraw from spender.
    function approve(address spender, uint tokens) public override returns(bool success) {
        // owner must have the sufficient tokens
        require(balances[msg.sender] >= tokens);
        // tokens must be greater then 0;
        require(tokens > 0);
        // add tokens allowed to spend.
        allowed[msg.sender][spender] = tokens;
        // emit the approval event
        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    // get amount/tokens allowed spender to withdraw
    function allowance(address tokenOwner, address spender) public override view returns(uint remaining) {
        // returns the tokens allowed to withdraw from owner
        return allowed[tokenOwner][spender];
    }


    // transfer the token to another account or same account.
    // only the allowed spender can transfer the tokens
    function transferFrom(address from, address to, uint tokens) public override returns(bool success) {
        // check if allowed spender has sufficient tokens
        require(allowed[from][msg.sender] >= tokens);
        // check balance of owner
        require(balances[from] >= tokens);
        // reduce the owner balance
        balances[from] -= tokens;
        // reduce the allowed spender balance
        allowed[from][msg.sender] -= tokens;
        // increase the balance of recipient
        balances[to] += tokens;

        //emit Transfer event
        emit Transfer(from, to, tokens);

        return true;
    }


}
