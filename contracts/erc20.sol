// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./IERC20.sol";

contract iUseArchBtwERC20Token is IERC20 {
    
    struct ballot{
        address voter;
        address candidate;
        bool vote;
    }

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    address[] public owners;
    mapping(address => ballot[]) public poll;

    bool public votingStatus;
    address public candidate = address(0);

    string public name = "I Use Arch Btw";
    string public symbol = "IUAB";
    uint8 public decimals = 18;
    uint public totalSupply = 1000^decimals;   

 


/*/////
owning functionality
*//////

    function countOwners() returns (uint256){   
        address
    }

    function countVotes() internal returns (uint256 ){

    }

    function vote() public {
        //sets voted for and checks if there's enough votes
    }


    function wantToOwn() external {

    }



/*/////
custom modifiers
*//////  



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

    function mint(uint amount) external {
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
