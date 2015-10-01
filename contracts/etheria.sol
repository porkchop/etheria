import "mortal";

contract Etheria is mortal {
	
    address creator;
    uint8 mapsize = 33;
    Tile[33][33] tiles;
    bool ownersinitialized = false;
    bool elevationsinitialized = false;
    bool[33] ownerrowsinitialized;
    bool[33] elevationrowsinitialized;
    
    // TODO: 
    // 3. Mouseover
    // 4. Block locations & colors
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	uint price; // 0 = not for sale. 0-4700000000000000000000 wei (approx) (0-4700 ether)
    	int8[] blocks; // index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz
    	               // index 4 = r, index 5 = g, index 6 = b
    }
    
    function Etheria() 
    {
        creator = msg.sender;
        for(uint8 x = 0; x < mapsize; x++)
        {
        	ownerrowsinitialized[x] = false;
        	elevationrowsinitialized[x] = false;
        }	
    }
    
    function initializeOwners(uint8[] rows)
    {
    	if(ownersinitialized == true) // can only initialize map ownership once
    		return;
    	
    	uint8 row = 0;
        for(uint8 a = 0; a < rows.length; a++)
    	{	
    		if(rows[a] > (mapsize-1))
    			return; // error. None of the provided row indexes should be > mapsize-1
    	}
    	for(uint8 y = 0; y < rows.length; y++)
    	{	
    		row = rows[y];
    		for(uint8 x = 0; x < mapsize; x++)
    		{
    			tiles[x][row].owner = creator;
    			tiles[x][row].price = 250000000000000000; //.25 eth
    		}
    		ownerrowsinitialized[row] = true;
    	}
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(ownerrowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	ownersinitialized = true;
    }
    
    function setElevations(uint8 row, uint8[33] _elevations)
    {
    	if(elevationsinitialized == true)
    		return;
    	
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    		tiles[x][row].elevation = _elevations[x]; 
    	elevationrowsinitialized[row] = true;
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(elevationrowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	elevationsinitialized = true;
    }
    
    function addBlock(uint8 x, uint8 y, int8[7] block)
    {
    	Tile current = tiles[x][y];
    	current.blocks.length+=7;
    	current.blocks[current.blocks.length - 7] = block[0];
    	current.blocks[current.blocks.length - 6] = block[1];
    	current.blocks[current.blocks.length - 5] = block[2];
    	current.blocks[current.blocks.length - 4] = block[3];
    	current.blocks[current.blocks.length - 3] = block[4];
    	current.blocks[current.blocks.length - 2] = block[5];
    	current.blocks[current.blocks.length - 1] = block[6];
    	return;
    }
    
    function setOwner(uint8 x, uint8 y, address newowner)
    {
    	if(tiles[x][y].owner == msg.sender)
    		tiles[x][y].owner == newowner;
    }
    
    function getElevations() constant returns (uint8[33][33])
    {
        uint8[33][33] memory elevations;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		elevations[x][y] = tiles[x][y].elevation; 
        	}	
        }	
    	return elevations;
    }
    
    function getOwners() constant returns(address[33][33])
    {
        address[33][33] memory owners;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		owners[x][y] = tiles[x][y].owner; 
        	}	
        }	
    	return owners;
    }
    
    function getBlocksForTile(uint8 x, uint8 y) constant returns (int8[])
    {
    	Tile memory currenttile = tiles[x][y];
    // 	int8[] blockarray;
    // 	uint i = 0;
    // 	while(i < currenttile.blocks.length * 7)
    // 	{
    // 	    blockarray.length += 7;
    // 		blockarray[i] = currenttile.blocks[i].which;
    // 		blockarray[i+1] = currenttile.blocks[i].x;
    // 		blockarray[i+2] = currenttile.blocks[i].y;
    // 		blockarray[i+3] = currenttile.blocks[i].z;
    // 		blockarray[i+4] = currenttile.blocks[i].r;
    // 		blockarray[i+5] = currenttile.blocks[i].g;
    // 		blockarray[i+6] = currenttile.blocks[i].b;
    // 		i = i + 7;
    // 	}	
    	return currenttile.blocks;
    }
    
    function getPrices() constant returns(uint[33][33])
    {
        uint[33][33] memory prices;
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