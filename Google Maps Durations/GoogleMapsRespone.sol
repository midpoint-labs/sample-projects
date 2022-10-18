// SPDX-License-Identifier: MIT

pragma solidity>=0.8.0;

contract GoogleMapsResponse {
    // This event is for demonstration purposes only; it can be removed without effect.
    event ResponseReceived(uint256 requestId, uint32 code, string origin_gmap, string[] destinations_gmap, uint256[] durations);
    
    address constant whitelistedCallbackAddress = 0x59CBE77D678B6F6C718e46b84d82048d72fA7859;
    

    constructor () {
      
    }
    
    /*
    * This is a custom callback function defined by the contract creator.
    */
    function myCallback(uint256 requestId, uint32 code, string calldata origin_gmap, string[] calldata destinations_gmap, uint256[] calldata durations) public {       
        // Only permit a verified callback address to call your callback function.
        require(tx.origin == whitelistedCallbackAddress, "Invalid callback address");
        
        // For Demonstration Purposes Only
        emit ResponseReceived(requestId, code, origin_gmap, destinations_gmap, durations);
    }
}