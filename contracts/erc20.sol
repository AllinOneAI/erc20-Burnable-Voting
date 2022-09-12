// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol";

contract iUseArchBtwERC20Token is IERC20 {
    
    struct Ballot{
        address voter;  
        bool vote;
    }

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    address[] public owners;
    mapping(address => ballot[]) public poll;

    bool private votingStatus;
    address private candidate = address(0);

    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;   

 
    constructor () {
        
        name = "I Use Arch Btw";
        symbol = "IUAB";
        decimals = 18;
        totalSupply = 1000^decimals;
        balanceOf[msg.sender] = totalSupply;
        owners.push(msg.sender);
        
    }

/*/////
owning functionality
*//////
    
    function decision() internal{
        int256 half = owners.length / 2;
        int256 counted = countVotes();
        if (counted > half){
            owners.push(candidate);
            candidate = address(0);
        }
    }

    function countVotes() internal returns (int256){
        int256 result = 0;
        for (uint256 i = 0; i < poll[candidate].length; i++) {
           if (poll[candidate][i] = true){result++;}
           else {result--;}
        }
        return result;
    }

    function vote(bool _vote) external onlyOwner candidateIsNotZero { //creates ballot and checks if there's enough votes
      //  Ballot memory ownerBallot = Ballot(msg.sender, vote);
        poll[candidate].push(Ballot(msg.sender, _vote));
        decision();
    }


    function wantToOwn() external notOwner candidateIsZero {
        candidate = msg.sender;
    }



/*/////
custom modifiers
*//////  
    
    modifier notOwner() {
        address compare;
        for (uint256 i = 0; i < owners.length; i++){
            if (msg.sender == owners[i]) { compare = owners[i]; break; }
            }
        require(msg.sender != compare, "You are an owner already!");
        _;
    }


    modifier candidateIsNotZero(){
        require(candidate != address(0), 'Voting is over');
        _;
    }

    modifier candidateIsZero(){
        require(candidate == address(0), "Voting is on");
        _;
    }

    modifier onlyOwner(){
        address compare;
        for (i = 0; i < owners.length; i++){
            if (msg.sender == owners[i]) { compare = owners[i]; break; }
            }
        require(msg.sender == compare, "Only owners can vote");
        _;
    }

/*/////
miscellaneous functions 
*/////

/*/////
core functions
*/////

    function transfer(address recipient, uint amount) external returns (bool) {
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function mint(uint amount) external onlyOwner{
        balanceOf[msg.sender] += amount;
        totalSupply += amount;
        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint amount) external {
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
