// SPDX-License-Identifier: MIT

pragma solidity>=0.8.0;

interface IMidpoint {
    function callMidpoint(uint64 midpointId, bytes calldata _data) external returns(uint256 requestId);
}

contract GoogleMapsRequest {
    // This event is for demonstration purposes only; it can be removed without effect.
    event RequestMade(uint256 requestId, string destinations, string origin, string dep_or_arrival, string language);
    
    address constant startpointAddress = 0xa89c2f3A20cED98cd39AFd0Ab5B207C46Fb2Cdf3;
    
    // Midpoint ID
    uint64 constant midpointID = 335;

    constructor () {
      
    }

    /*
     * This function makes a call to a midpoint with on-chain variables specified as function inputs. 
     * 
     * Note that this is a public function and will allow any address or contract to call midpoint 276.
     * The contract whitelist permits this entire contract to call your midpoint; calls to 'callMidpoint'
     * must be additionally restricted to intended callers.
     * Any call to 'callMidpoint' from a whitelisted contract will make a call to the midpoint;
     * there may be multiple places in this contract that call the midpoint or multiple midpoints called by the same contract.
     */ 

    function callMidpoint(string memory destinations, string memory origin, string memory dep_or_arrival, string memory language) public {
        
        // Argument String
        bytes memory args = abi.encodePacked(destinations, bytes1(0x00), origin, bytes1(0x00), dep_or_arrival, bytes1(0x00), language, bytes1(0x00));
        
        // Call Your Midpoint
        uint256 requestId = IMidpoint(startpointAddress).callMidpoint(midpointID, args);

        // For Demonstration Purposes Only
        emit RequestMade(requestId, destinations, origin, dep_or_arrival, language);
    }
}
