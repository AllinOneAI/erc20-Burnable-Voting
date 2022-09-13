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

    mapping(address => Ballot[]) public poll;                           //history of all polls mapped to every candidate, that has ever been; 
    mapping(address => bool) public owners;                             // mapping of all owners
    uint256 public ownersCount;                                         // counter of current owners. needed for votes counting                         

 
    address public candidate = address(0);                              //current candidate to vote for; if = zero addr, there's no voting now

    string public name;
    string public symbol;
    uint8 public decimals;
    uint public totalSupply;   
    uint256 public afterTime;  

 
    constructor () {
       
        afterTime = block.timestamp + 3 minutes;   
        name = "I Use Arch Btw";
        symbol = "IUAB";
        decimals = 18;
        totalSupply = 1000^decimals;
        balanceOf[msg.sender] = totalSupply;
        owners[msg.sender] = true;
        ownersCount = 1;                                                //contract deployer is it's firs owner, so incrementing ownerCount
        
    }

/*/////
owning functionality
*//////
    

    function vote(bool _vote) external onlyOwner candidateIsNotZero {   //creates ballot and calls decision function
        poll[candidate].push(Ballot(msg.sender, _vote));
        decision();
    }
    

    function countVotes() internal view returns (int256 pos, int256 neg) {   //counting all votes for current candidate
        pos = 0;
        neg = 0;
        for (uint256 i = 0; i < poll[candidate].length; i++) {
           if (poll[candidate][i].vote == true){pos++;}
           else {neg++;}
        }
        return (pos, neg);
    }


    function decision() internal {                                          //decision function, that's called every time, someone voting for current candidate
        int256 pos;
        int256 neg;
        int256 half = int256(ownersCount) / 2;
        (pos, neg) = countVotes();
        int256 result = pos - neg;
        if (result > half) {
            addOwner();
        }
    }


    function addOwner() internal {                                          //adding candidate in case there's enough positive votes
        owners[candidate] = true;
        ownersCount++;
        candidate = address(0);
    }


    function wantToOwn() external notOwner candidateIsZero {
        candidate = msg.sender;
    }



/*/////
custom modifiers
*//////  
   
     modifier canBurn() {
        require(block.timestamp > afterTime, "It's not time yet");           // this modifier checks if it's enough time passed since deployment of the contract, so you can burn your tokens 
        _;
     }

    modifier notOwner() {                                                   //checking if msg.sender is not an owner already
        require(owners[msg.sender] == false, "You are already an owner");
        _;
    }


    modifier candidateIsNotZero(){                                          //requirement for candidate's address to not to be zero
        require(candidate != address(0), "Voting is over");
        _;
    }

    modifier candidateIsZero(){                                              //requirement for candidate's address to be zero
        require(candidate == address(0), "Voting is on");
        _;
    }

    modifier onlyOwner(){
        require(owners[msg.sender] == true, "Only owners can vote");
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

    function burn(uint amount) external canBurn{
        balanceOf[msg.sender] -= amount;
        totalSupply -= amount;
        emit Transfer(msg.sender, address(0), amount);
    }
}
