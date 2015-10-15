import "mortal";

//contract PongvalRetriever {
// 	int8 pongval_tx_retrieval_attempted = 0;
//	function getPongvalTransactional() public returns (int8){	// tells Ping how to interact with Pong.
//		pongval_tx_retrieval_attempted = -1;
//		return pongval_tx_retrieval_attempted;
//	}
//}

contract EtheriaInterface is mortal {
	function initElevations(uint8 row, uint8[17] _elevations)
	{}
	function initBlockDef(uint8 which, int8[3][8] occupies, int8[3][] surroundedby)
    {}
}

contract EtheriaInitializer is EtheriaInterface {
	
    EtheriaInterface ei;
    
    function EtheriaInitializer(EtheriaInterface _e) {
    	ei = _e;
    }
    
    function initElevationsRemote(uint8 row, uint8[17] _elevations)
    {
    	ei.initTiles(row, _elevations);
    }
    
    function initBlockDefRemote(uint8 which, int8[3][8] occupies, int8[3][] surroundedby)
    {
    	ei.initBlockDef(which, occupies, surroundedby);
    }
}