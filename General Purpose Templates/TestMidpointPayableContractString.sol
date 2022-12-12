/*
 * SPDX-License-Identifier: MIT
 * Midpoint Sample Payable Contract v3.0.0
 *
 * This contract is intended to serve as a guide for interfacing with a paid midpoint and should
 * not be used as is in a production environment.
 * For more information on setting up a midpoint and using this contract see docs.midpointapi.com
 */

pragma solidity>=0.8.0;

interface IMidpoint {
    function callMidpoint(uint64 midpointId, bytes calldata _data) external returns(uint64 requestId);
}

contract TestMidpoint541PaymentContract {
    // A verified startpoint for an unspecified blockchain (select a blockchain above)
    address startpointAddress;
    
    // A verified midpoint callback address for an unspecified blockchain (select a blockchain above)
    address constant whitelistedCallbackAddress = 0xC0FFEE4a3A2D488B138d090b8112875B90b5e6D9;
    
    // The globally unique identifier for your midpoint
    uint64 midpointID;

    address contractOwner;

    uint256 cost;

    // Startpoints
    // Goerli: 0x795c5292b9630d473d568079b73850F29344403c
    // Optimism Goerli: 0x6427Df72f7b7A8b1B105D9f9eF570835dDa02837
    // Arbitrum Goerli: 0x41c15FcBDfC836713d9E8f5e62baCe8892cC91Ed
    // Mumbai: 0x72cf074B059E88C92A24fDF310736535E10d33eE
    constructor(uint64 _midpointID, address _startpointAddress, uint256 _cost) {
      contractOwner = msg.sender;
      startpointAddress = _startpointAddress;
      midpointID = _midpointID;
      cost = _cost;
    }

    function getBalance() public view returns(uint256) {
       return address(this).balance;
    }

    function withdrawMoney() public {
       // Make sure only the owner can withdraw money
       require(msg.sender == contractOwner, "You are not allowed to withdraw money");
       address payable to = payable(msg.sender);
       to.transfer(getBalance());
    }

    /*
     * This function makes a call to your midpoint with On-Chain Variables specified as function inputs. 
     * 
     * Note that this is a public function and will allow any address or contract to call your midpoint.
     * Configure your midpoint to permit calls from this contract when testing. Before using your midpoint
     * in a production environment, ensure that calls to 'callMidpoint' are protected.
     * Any call to 'callMidpoint' from a whitelisted contract will make a call to your midpoint;
     * there may be multiple places in this contract that call the midpoint or multiple midpoints called by the same contract.
     */

    function testMidpointRequest(string memory input) payable public {
       // Make sure the user pays to call this midpoint
       require(msg.value >= cost);
       
       // This packs together all of the On-Chain Variables for your midpoint into a single bytestring
        bytes memory args = abi.encodePacked(input, bytes1(0x00));
        
       // This makes the call to your midpoint
       IMidpoint(startpointAddress).callMidpoint(midpointID, args);
    }
}