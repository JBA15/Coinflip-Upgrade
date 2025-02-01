// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

error SeedTooShort();

/// @title Coinflip 10 in a Row
/// @author Tianchan Dong, modified by Jean-Baptiste Astruc
/// @notice Contract used as part of the course Solidity and Smart Contract development
contract Coinflip is Ownable{
    
    string public seed;

    constructor() Ownable(msg.sender) {
        // Setting the seed to "It is a good practice to rotate seeds often in gambling".
        seed = "It is a good practice to rotate seeds often in gambling";
    }

    /// @notice Checks user input against contract generated guesses
    /// @param Guesses is a fixed array of 10 elements which holds the user's guesses. The guesses are either 1 or 0 for heads or tails
    /// @return true if user correctly guesses each flip correctly or false otherwise
    function userInput(uint8[10] calldata Guesses) external view returns(bool){
        // Getting the contract generated flips by calling the helper function getFlips()
        uint8[10] memory generatedFlips = getFlips();

        // Comparing each element of the user's guesses with the generated flips and returning true ONLY if all guesses match
        for (uint i = 0; i < 10; i++) {
            if (Guesses[i] != generatedFlips[i]) {
                return false;
            }
        }
        return true;
    }

    /// @notice allows the owner of the contract to change the seed to a new one
    /// @param NewSeed is a string which represents the new seed
    function seedRotation(string memory NewSeed) public onlyOwner {
        // Casting the string into a bytes array so we may perform operations on it
        bytes memory seedBytes = bytes(NewSeed);

        // Getting the length of the array
        uint seedlength = seedBytes.length;

        // Checking if the seed is less than 10 characters
        if (seedlength < 10){
            revert SeedTooShort();
        }

        // Setting the seed variable as the NewSeed
        seed = NewSeed;
    }

// -------------------- helper functions -------------------- //
    /// @notice This function generates 10 random flips by hashing characters of the seed
    /// @return a fixed 10 element array of type uint8 with only 1 or 0 as its elements
    function getFlips() public view returns(uint8[10] memory) {
        // Casting the seed into a bytes array and getting its length
        bytes memory stringInBytes = bytes(seed);
        uint seedlength = stringInBytes.length;

        // Initializing an empty fixed array with 10 uint8 elements
        uint8[10] memory flips;

        // Setting the interval for grabbing characters
        uint interval = seedlength / 10;

        // Defining a for loop that iterates 10 times to generate each flip
        for (uint i = 0; i < 10; i++){
            // Generating a pseudo-random number by hashing together the character and the block timestamp
            uint randomNum = uint(keccak256(abi.encode(stringInBytes[i*interval], block.timestamp)));
            
            // If the result is an even unsigned integer, record it as 1 in the results array, otherwise record it as zero
            if (randomNum % 2 == 0) {
                flips[i] = 1;
            } else {
                flips[i] = 0;
            }
        }

        // Returning the resulting fixed array
        return flips;
    }
}