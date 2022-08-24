// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Lottery{
    
    // declaring the state variables
    address payable[] public players; //dynamic array of type address payable
    address public owner; 
    
    // declaring the constructor
    constructor(){
        // initializing the owner to the address that deploys the contract
        owner = msg.sender; 
    }
    
    // declaring the receive() function that is necessary to receive ETH
    receive () payable external{
        // each player sends exactly 0.1 ETH 
        require(msg.value == 0.1 ether);
        // appending the player to the players array
        players.push(payable(msg.sender));
    }
    
    // returning the contract's balance in wei
    function getBalance() public view returns(uint256){
        // only the owner is allowed to call the balance
        require(msg.sender == owner, "only owner allow to call this");
        return address(this).balance;
    }
    
    // helper function that returns a big random integer
    function random() internal view returns(uint256){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }
    
    // selecting the winner
    function pickWinner() public{
        // only the owner can pick a winner if there are at least 3 players in the lottery
        require(msg.sender == owner, "only owner has access");
        require (players.length >= 3);
        
        uint r = random();
        address payable winner;
        
        // computing a random index of the array
        uint index = r % players.length;
    
        winner = players[index]; // this is the winner
        
        // transferring the entire contract's balance to the winner
        winner.transfer(getBalance());
        
        // resetting the lottery for the next round
        players = new address payable[](0);
    }

     fallback () external payable {} 
 
}