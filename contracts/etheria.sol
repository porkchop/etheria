import "mortal";
contract Etheria {
	
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
    	Block[] blocks;
    }
    
    struct Block 
    {
    	int8 which;
    	int8 x;
    	int8 y;
    	int8 z; // Note: We'll add 127 (*NOT 128*) on client. If z=-1 after that, block has not yet been placed.
    	
    	int8 r;	// NOTE: 
    	int8 g; // We'll add 128 to each of these values on the client side to get 0-255 values
    	int8 b; // That way, we can return an array of int8s to describe all blocks in a tile all at once
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
    	Block newblock;
    	newblock.which = 1;
    	newblock.x = 2;
    	newblock.y = 3;
    	newblock.z = 0;
    	newblock.r = 100;
    	newblock.g = 101;
    	newblock.b = 102;
    	current.blocks.length+=1;
    	current.blocks[current.blocks.length-1] = newblock;
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
    	int8[] blockarray;
    	uint i = 0;
    	while(i < currenttile.blocks.length * 7)
    	{
    	    blockarray.length += 7;
    		blockarray[i] = currenttile.blocks[i].which;
    		blockarray[i+1] = currenttile.blocks[i].x;
    		blockarray[i+2] = currenttile.blocks[i].y;
    		blockarray[i+3] = currenttile.blocks[i].z;
    		blockarray[i+4] = currenttile.blocks[i].r;
    		blockarray[i+5] = currenttile.blocks[i].g;
    		blockarray[i+6] = currenttile.blocks[i].b;
    		i = i + 1;
    	}	
    	return blockarray;
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