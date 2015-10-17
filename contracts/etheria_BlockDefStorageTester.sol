import 'mortal'; // TODO

contract BlockDefRetriever is mortal  // TODO
{
	function getOccupies(uint8 which) returns (int8[3][8])
	{}
	function getAttachesto(uint8 which) returns (int8[3][8])
    {}
}

contract BlockDefStorageTester is BlockDefRetriever
{
    BlockDefRetriever bdr;
    
    function BlockDefStorageTester() {
    	bdr = BlockDefRetriever(0xed9c3aead241f6fd8e6b6951e29c3dcb5b3662c1); 
    }
    
    function getOccupiesFromBDRDirect(uint8 which) public constant returns(int8[3][8])
    {
    	return bdr.getOccupies(which);
    }
    
    function getOccupiesFromBDRMemory(uint8 which) public constant returns(int8[3][8])
    {
    	int8[3][8] memory occ = bdr.getOccupies(which);
    	return occ;
    }
    
}

// this is already deployed at address 0xed9c3aead241f6fd8e6b6951e29c3dcb5b3662c1. See below
//contract BlockDefStorage
//{
//	bool[32] occupiesInitialized;
//	bool[32] attachestoInitialized;
//	bool allOccupiesInitialized;
//	bool allAttachestoInitialized;
//	
//    Block[32] blocks;
//    struct Block
//    {
//    	int8[3][8] occupies; // [x,y,z] 8 times
//    	int8[3][] attachesto; // [x,y,z]
//    }
//    
//    function getOccupies(uint8 which) public constant returns (int8[3][8])
//    {
//    	return blocks[which].occupies;
//    }
//    
//    function getAttachesto(uint8 which) public constant returns (int8[3][])
//    {
//    	return blocks[which].attachesto;
//    }
//    
////  function getLocked() public constant returns (bool)
////  {
////  	return (allOccupiesInitialized && allAttachestoInitialized);
////  }
//    
//    function initOccupies(uint8 which, int8[3][8] occupies) public 
//    {
//    	if(allOccupiesInitialized) // lockout
//    		return;
//    	blocks[which].occupies = occupies;
//    	occupiesInitialized[which] = true;
//    	for(uint8 b = 0; b < 32; b++)
//    	{
//    		if(occupiesInitialized[b] == false)
//    			return;
//    	}	
//    	allOccupiesInitialized = true;
//    }
//    
//    function initAttachesto(uint8 which, int8[3][] attachesto) public
//    {
//    	if(allAttachestoInitialized) // lockout
//    		return;
//    	blocks[which].attachesto.length = attachesto.length;
//    	blocks[which].attachesto = attachesto;
//    	attachestoInitialized[which] = true;
//    	for(uint8 b = 0; b < 32; b++)
//    	{
//    		if(attachestoInitialized[b] == false)
//    			return;
//    	}	
//    	allAttachestoInitialized = true;
//    }
//}

// To request block definitions directly from BlockDefStorage contract use this abi and address:
// > var abi = [{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getAttachesto","outputs":[{"name":"","type":"int8[3][]"}],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"occupies","type":"int8[3][8]"}],"name":"initOccupies","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"attachesto","type":"int8[3][]"}],"name":"initAttachesto","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupies","outputs":[{"name":"","type":"int8[3][8]"}],"type":"function"}]
// > var blockdefstorage = web3.eth.contract(abi).at('0xed9c3aead241f6fd8e6b6951e29c3dcb5b3662c1');
// > blockdefstorage.getOccupies(0);
// [[0, 0, 0], [0, 0, 1], [0, 0, 2], [0, 0, 3], [0, 0, 4], [0, 0, 5], [0, 0, 6], [0, 0, 7]] // CORRECT ANSWER

// To request block definitions from the BlockDefStorage contract THROUGH the BlockDefStorageTester (and its BlockDefRetriever)
// > var abi = [{"constant":false,"inputs":[{"name":"which","type":"uint8"}],"name":"getAttachesto","outputs":[{"name":"","type":"int8[3][8]"}],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupies","outputs":[{"name":"","type":"int8[3][8]"}],"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupiesFromBDRMemory","outputs":[{"name":"","type":"int8[3][8]"}],"type":"function"},{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupiesFromBDRDirect","outputs":[{"name":"","type":"int8[3][8]"}],"type":"function"},{"inputs":[],"type":"constructor"}]
// > var blockdefstoragetester = web3.eth.contract(abi).at('0x2dcde420c88350ac46797246c4c96ef0549cc56e');
// > blockdefstoragetester.getOccupiesFromBDRMemory(0);
// [[0, 0, 3424], [0, 0, 3424], [0, 0, 3424], [0, 0, 3424], [0, 0, 3424], [0, 0, 876544], [0, 0, 3424], [0, 0, 3424]] // WRONG
// > {address != 'undefined') {ccupiesFromBDRMemory(0);
//         console.log(e, contract);
//         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
//    }
// > blockdefstoragetester.getOccupiesFromBDRDirect(0);
// [[0, 0, 1888], [0, 0, 1888], [0, 0, 1888], [0, 0, 1888], [0, 0, 1888], [0, 0, 483328], [0, 0, 1888], [0, 0, 1888]] // WRONG
