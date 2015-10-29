contract BlockDefStorage
{
	
    Block[18] blocks;
    struct Block
    {
    	int8[24] occupies; // [x0,y0,z0,x1,y1,z1...,x7,y7,z7] 
    	int8[48] attachesto; // [x0,y0,z0,x1,y1,z1...,x15,y15,z15] // first one that is 0,0,0 is the end
    }
    
    address creator;
    function BlockDefStorage()
    {
    	creator = msg.sender;
    }
    
    function getOccupies(uint8 which) public constant returns (int8[24])
    {
    	return blocks[which].occupies;
    }
    
    function getAttachesto(uint8 which) public constant returns (int8[48])
    {
    	return blocks[which].attachesto;
    }

    function initOccupies(uint8 which, int8[24] occupies) public 
    {
    	if(locked) // lockout
    		return;
    	for(uint8 index = 0; index < 24; index++)
    	{
    		blocks[which].occupies[index] = occupies[index];
    	}	
    }
    
    function initAttachesto(uint8 which, int8[48] attachesto) public
    {
    	if(locked) // lockout
    		return;
    	for(uint8 index = 0; index <  48; index++)
    	{
    		blocks[which].attachesto[index] = attachesto[index];
    	}	
    }
    
    /**********
    Standard lock-kill methods 
    **********/
    bool locked;
    function setLocked()
    {
 	   locked = true;
    }
    function getLocked() public constant returns (bool)
    {
 	   return locked;
    }
    function kill()
    { 
        if (!locked && msg.sender == creator)
            suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}

// ETHERIA 1.1


//blockdefstorage.initOccupies.sendTransaction(0, [0,0,0,0,0,1,0,0,2,0,0,3,0,0,4,0,0,5,0,0,6,0,0,7],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(1, [0,0,0,1,0,0,2,0,0,3,0,0,4,0,0,5,0,0,6,0,0,7,0,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(2, [0,0,0,1,0,0,1,1,0,2,1,0,3,2,0,4,2,0,4,3,0,5,3,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(3, [0,0,0,-1,0,0,-2,1,0,-3,1,0,-3,2,0,-4,2,0,-5,3,0,-6,3,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(4, [0,0,0,1,0,0,0,0,1,1,0,1,0,0,2,1,0,2,0,0,3,1,0,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(5, [0,0,0,0,1,0,0,0,1,0,1,1,0,0,2,0,1,2,0,0,3,0,1,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(6, [0,0,0,-1,1,0,0,0,1,-1,1,1,0,0,2,-1,1,2,0,0,3,-1,1,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(7, [0,0,0,1,0,0,2,0,0,3,0,0,0,0,1,1,0,1,2,0,1,3,0,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(8, [0,0,0,1,0,0,1,1,0,2,1,0,0,0,1,1,0,1,1,1,1,2,1,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(9, [0,0,0,-1,0,0,-2,1,0,-3,1,0,0,0,1,-1,0,1,-2,1,1,-3,1,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(10, [0,0,0,0,1,0,0,2,0,0,3,0,0,4,0,0,5,0,0,6,0,0,7,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(11, [0,0,0,-1,1,0,0,2,0,-1,3,0,0,4,0,-1,5,0,0,6,0,-1,7,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(12, [0,0,0,0,1,0,0,2,0,0,3,0,0,0,1,0,1,1,0,2,1,0,3,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(13, [0,0,0,-1,1,0,0,2,0,-1,3,0,0,0,1,-1,1,1,0,2,1,-1,3,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(14, [0,0,0,1,0,0,1,0,1,2,0,1,2,0,2,3,0,2,3,0,3,4,0,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(15, [0,0,0,-1,0,0,-1,0,1,-2,0,1,-2,0,2,-3,0,2,-3,0,3,-4,0,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(16, [0,0,0,0,-1,0,0,-1,1,0,-2,1,0,-2,2,0,-3,2,0,-3,3,0,-4,3],{from:eth.coinbase, gas:500000});
//blockdefstorage.initOccupies.sendTransaction(17, [0,0,0,0,1,0,0,1,1,0,2,1,0,2,2,0,3,2,0,3,3,0,4,3],{from:eth.coinbase, gas:500000});
//
//blockdefstorage.initAttachesto.sendTransaction(0, [0,0,-1,0,0,8,0,0,0,0,0,0,0,0,0,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(1, [0,0,-1,1,0,-1,2,0,-1,3,0,-1,4,0,-1,5],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(2, [0,0,-1,1,0,-1,1,1,-1,2,1,-1,3,2,-1,4],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(3, [0,0,-1,-1,0,-1,-2,1,-1,-3,1,-1,-3,2,-1,-4],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(4, [0,0,-1,1,0,-1,0,0,4,1,0,4,0,0,0,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(5, [0,0,-1,0,1,-1,0,0,4,0,1,4,0,0,0,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(6, [0,0,-1,-1,1,-1,0,0,4,-1,1,4,0,0,0,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(7, [0,0,-1,1,0,-1,2,0,-1,3,0,-1,0,0,2,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(8, [0,0,-1,1,0,-1,1,1,-1,2,1,-1,0,0,2,1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(9, [0,0,-1,-1,0,-1,-2,1,-1,-3,1,-1,0,0,2,-1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(10, [0,0,-1,0,1,-1,0,2,-1,0,3,-1,0,4,-1,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(11, [0,0,-1,-1,1,-1,0,2,-1,-1,3,-1,0,4,-1,-1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(12, [0,0,-1,0,1,-1,0,2,-1,0,3,-1,0,0,2,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(13, [0,0,-1,-1,1,-1,0,2,-1,-1,3,-1,0,0,2,-1],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(14, [0,0,-1,1,0,-1,2,0,0,3,0,1,4,0,2,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(15, [0,0,-1,-1,0,-1,-2,0,0,-3,0,1,-4,0,2,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(16, [0,0,-1,0,-1,-1,0,-2,0,0,-3,1,0,-4,2,0],{from:eth.coinbase, gas:500000});
//blockdefstorage.initAttachesto.sendTransaction(17, [0,0,-1,0,1,-1,0,2,0,0,3,1,0,4,2,0],{from:eth.coinbase, gas:500000});
