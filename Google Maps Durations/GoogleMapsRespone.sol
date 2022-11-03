// SPDX-License-Identifier: MIT

pragma solidity>=0.8.0;

contract GoogleMapsResponse {
    // This event is for demonstration purposes only; it can be removed without effect.
    event ResponseReceived(uint256 requestId, uint32 code, string origin_gmap, string[] destinations_gmap, uint256[] durations);
    
    address constant whitelistedCallbackAddress = 0xC0FFEE4a3A2D488B138d090b8112875B90b5e6D9;
    

    constructor () {
      
    }
    
    /*
    * This is a custom callback function defined by the contract creator.
    */
    function myCallback(uint256 _requestId, uint64 _midpointId, uint32 code, string calldata origin_gmap, string[] calldata destinations_gmap, uint256[] calldata durations) public {       
        // Only allow the verified callback address to submit information for your midpoint.
        require(tx.origin == whitelistedCallbackAddress, "Invalid callback address");
        require(midpointID == _midpointId, "Invalid Midpoint ID");
        
        // For Demonstration Purposes Only
        emit ResponseReceived(requestId, code, origin_gmap, destinations_gmap, durations);
    }
}
