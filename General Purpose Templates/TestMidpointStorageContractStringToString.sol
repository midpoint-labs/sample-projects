/*
 * SPDX-License-Identifier: MIT
 * Midpoint Sample Storage Contract v3.0.0
 *
 * This contract is intended to serve as a guide for interfacing with a midpoint and should not be used
 * as is in a production environment. 
 * For more information on setting up a midpoint and using this contract see docs.midpointapi.com
 */

pragma solidity>=0.8.0;

interface IMidpoint {
    function callMidpoint(uint64 midpointId, bytes calldata _data) external returns(uint64 requestId);
}

contract TestMidpointStorageContract {
    // These events can be removed without impacting the functionality of your midpoint
    event RequestMade(string input);
    event ResponseReceived(uint64 Request_ID, uint64 Midpoint_ID, string output);
    
    // A verified startpoint for your target chain
    address startpointAddress;
    
    // A verified midpoint callback address for your target chain
    address constant whitelistedCallbackAddress = 0xC0FFEE4a3A2D488B138d090b8112875B90b5e6D9;
    
    // The globally unique identifier for your midpoint
    uint64 midpointID;
    
    // Mapping of Request ID to a flag that is checked when the request is satisfied
    // This can be removed without impacting the functionality of your midpoint
    mapping(uint64 => bool) public request_id_satisfied;
    
    // Mappings from Request ID to each of your results
    // This can be removed without impacting the functionality of your midpoint
    mapping(uint64 => string) public request_id_to_output;
    
    // Startpoints
    // Goerli: 0x795c5292b9630d473d568079b73850F29344403c
    // Optimism Goerli: 0x6427Df72f7b7A8b1B105D9f9eF570835dDa02837
    // Arbitrum Goerli: 0x41c15FcBDfC836713d9E8f5e62baCe8892cC91Ed
    // Mumbai: 0x72cf074B059E88C92A24fDF310736535E10d33eE
    constructor(uint64 _midpointID, address _startpointAddress) {
        midpointID = _midpointID;
        startpointAddress = _startpointAddress;
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

    function testMidpointRequest(string memory input) public {
        // This packs together all of the On-Chain Variables for your midpoint into a single bytestring
        bytes memory args = abi.encodePacked(input, bytes1(0x00));
        
        // This makes the call to your midpoint
        uint64 Request_ID = IMidpoint(startpointAddress).callMidpoint(midpointID, args);

        // This logs that the call has been made, and can be removed without impacting your midpoint
        emit RequestMade(input);
        request_id_satisfied[Request_ID] = false;
    }
    
   /*
    * This function is the callback target specified in your midpoint callback definition. 
    * Note that the callback is placed in the same contract as the call to callMidpoint for simplicity when testing.
    * The callback does not need to be defined in the same contract as the request or live on the same chain.
    */

   function callback(uint64 Request_ID, uint64 Midpoint_ID, string memory output) public {
       // Only allow a verified callback address to submit information for your midpoint.
       require(tx.origin == whitelistedCallbackAddress, "Invalid callback address");
       // Only allow requests that came from your midpoint ID
       require(midpointID == Midpoint_ID, "Invalid Midpoint ID");
       
       // This stores each of your response variables. This is where you would place any logic associated with your callback.
       // Your midpoint can transact to a callback with arbitrary execution and gas cost.
       request_id_to_output[Request_ID] = output;
       
       // This logs that a response has been received, and can be removed without impacting your midpoint
       emit ResponseReceived(Request_ID, Midpoint_ID, output);
       request_id_satisfied[Request_ID] = true;
   }
}