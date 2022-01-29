// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 < 0.9.0;

import "./Owned.sol";
import "./Logger.sol";
import "./IFaucet.sol";

contract Faucet is Owned, Logger, IFaucet{ 
    // this is a especial function receive()
    // it's called when you make a tx that doesn't specify
    // a function name to call

    // External function are part of the contract interface
    // which means they can be called via contracts and other txs
    uint public numOfFunders;

    mapping(address => bool) private funders;
    mapping(uint => address) private lutFunders;

   

    modifier limitWithdraw(uint withdrawAmount) {
        require(withdrawAmount <= 100000000000000000,
         "Cannot withdraw more than 0.1eth"
         );
        _;
    }

    

    // private -> can be accesible only within the smart contract
    // internal -> can be accesible within smart contract and also derived smart contract


    receive() external payable {}

    function emitLog() public override pure returns(bytes32) {
        return "Hello World";
    }

    function addFunds() external override payable {

            address funder = msg.sender;
            
            if(!funders[funder]) {
                uint index = numOfFunders++;
                funders[funder] = true;

                lutFunders[index] = funder;
            }
        }

        function withdraw(uint withdrawAmount) override external limitWithdraw(withdrawAmount) {

            payable(msg.sender).transfer(withdrawAmount);
            
        }

        function getAllFunders() external view returns(address[] memory) {
            address[] memory _funders = new address[](numOfFunders);

            for (uint i =0; i < numOfFunders; i++)  {
                _funders[i] = lutFunders[i];
            }
            return _funders;
        }

        function getFunderAtIndex(uint8 index) external view returns(address) {
            return lutFunders[index];
        }
    }

    // function justTesting() external pure returns(uint) {
    //     return 2 + 2;

    // }

    // pure, view - readOnly call, no gas fee
    // view - it indicates that the function will not alter the storage state i any way
    // pure - even more strict, indicates that i wont even read the storage state

    // Transactions (can generate state changes) and require gas fee

    // to talk to the node on the network you can make JSON-RPC http calls


