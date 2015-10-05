import "mortal";

contract Etheria is mortal {
	
    uint8 mapsize = 17;
    Tile[17][17] tiles;
    bool allrowsinitialized;
    bool[17] rowsinitialized;
    
    // TODO: 
    // display tile type in tile info div
    // display map from the blockchain, not a generated one
    // display for-sale amount in tile info div
    // display blocks on frontend
    // block edit validation (coordinate limits, connections, etc)
    // tile trading
    // block trading (blocks must be z=-1 before trade)
    // Fitness vote
    // Cast threat
    // withdrawal
    // register name for tile
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	uint80 price; // 0 = not for sale. 0-4700000000000000000000 wei (approx) (0-4700 ether)
    	int8[] blocks; // index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz (< 0 = not yet placed)
    	               // index 4 = r, index 5 = g, index 6 = b
    }
    
    function initializeRow(uint8 row, uint8[17] _elevations)
    {
    	if(allrowsinitialized == true)
    		return;
    	
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    	{
    	    tiles[x][row].owner = owner;
    	    tiles[x][row].price = 250000000000000000; //.25 eth
    	    tiles[x][row].elevation = _elevations[x];
    	}
    	rowsinitialized[row] = true;
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(rowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	allrowsinitialized = true;
    }
    
    function farmTile(uint8 x, uint8 y)
    {
        if(tiles[x][y].owner != msg.sender)
            return;
        uint lastblocknumberused = block.number - 1 ;
    	uint128 lastblockhashused_uint128 = uint128(block.blockhash(lastblocknumberused));
    	uint128 remainder256; 
    	// index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz, index 4 = r, index 5 = g, index 6 = b
    	Tile current;
    	uint16 i = 0;
    	while(i < 10)
    	{
    	    remainder256 = lastblockhashused_uint128 % (256 - i);
        	current = tiles[x][y];
        	current.blocks.length+=7;
        	if(remainder256 == 0)
        	{
        	    // ACTION BLOCK!
        	    current.blocks[current.blocks.length - 7] = 14;
        	    current.blocks[current.blocks.length - 6] = 3;
        	    current.blocks[current.blocks.length - 5] = 3;
        	    current.blocks[current.blocks.length - 4] = -1;
        	    current.blocks[current.blocks.length - 3] = -128;
        	    current.blocks[current.blocks.length - 2] = 0;
        	    current.blocks[current.blocks.length - 1] = -128;
        	}
        	else // normal block
        	{
        	    current.blocks[current.blocks.length - 7] = 0;
        	    current.blocks[current.blocks.length - 6] = -3;
        	    current.blocks[current.blocks.length - 5] = -3;
        	    current.blocks[current.blocks.length - 4] = -1;
        	    current.blocks[current.blocks.length - 3] = 0;
        	    current.blocks[current.blocks.length - 2] = -128;
        	    current.blocks[current.blocks.length - 1] = -128;
        	}
    	    i++;
    	}
    }
    
    // NOTE: In this instance, block[0] is irrelevant. We can't change which type of block it is
    function editBlock(uint8 x, uint8 y, uint indexOfBlockToEdit, int8[7] block)  
    {
        if(tiles[x][y].owner != msg.sender)
            return;
    	Tile current = tiles[x][y];
    	uint metaindex = indexOfBlockToEdit*7;
        //current.blocks[metaindex] = error; // irrelevant. We can't change which type of block it is
    	current.blocks[metaindex + 1] = block[1];
    	current.blocks[metaindex + 2] = block[2];
    	current.blocks[metaindex + 3] = block[3];
    	current.blocks[metaindex + 4] = block[4];
    	current.blocks[metaindex + 5] = block[5];
    	current.blocks[metaindex + 6] = block[6];
    	return;
    }
    
    function setOwner(uint8 x, uint8 y, address newowner)
    {
    	if(tiles[x][y].owner == msg.sender)
    		tiles[x][y].owner == newowner;
    }
    
    function getBlocksForTile(uint8 x, uint8 y) constant returns (int8[])
    {
    	Tile memory currenttile = tiles[x][y];
    	return currenttile.blocks;
    }
    
    function getElevations() constant returns (uint8[17][17])
    {
        uint8[17][17] memory elevations;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		elevations[x][y] = tiles[x][y].elevation; 
        	}	
        }	
    	return elevations;
    }
    
    function getOwners() constant returns(address[17][17])
    {
        address[17][17] memory owners;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        	    owners[x][y] = tiles[x][y].owner; 
        	}	
        }	
    	return owners;
    }
    
    function getPrices() constant returns(uint80[17][17])
    {
        uint80[17][17] memory prices;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		prices[x][y] = tiles[x][y].price; 
        	}	
        }	
    	return prices;
    }
}