import "mortal";

contract Etheria is mortal {
	
    address creator;
    uint8 mapsize = 17;
    Tile[17][17] tiles;
    bool ownersinitialized = false;
    bool pricesinitialized = false;
    bool elevationsinitialized = false;
    bool[17] ownerrowsinitialized;
    bool[17] elevationrowsinitialized;
    bool[17] pricerowsinitialized;
    
    // TODO: 
    // 3. Mouseover
    // 4. Block locations & colors
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	uint80 price; // 0 = not for sale. 0-4700000000000000000000 wei (approx) (0-4700 ether)
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
    
    function initializeOwners(uint8 row)
    {
    	if(ownersinitialized == true)
    		return;
    	
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    		tiles[x][row].owner = creator; 
    	ownerrowsinitialized[row] = true;
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(ownerrowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
        ownersinitialized = true;
    }
    
    function initializePrices(uint8 row)
    {
    	if(pricesinitialized == true)
    		return;
    	
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    		tiles[x][row].price = 250000000000000000; //.25 eth
    	pricerowsinitialized[row] = true;
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(pricerowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	pricesinitialized = true;
    }
    
    function initializeElevations(uint8 row, uint8[17] _elevations)
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
    
    function getBlocksForTile(uint8 x, uint8 y) constant returns (int8[])
    {
    	Tile memory currenttile = tiles[x][y];
    	return currenttile.blocks;
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