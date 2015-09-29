contract Etheria {

    address creator;
    uint8 mapsize = 33;
    //uint8[33][33] elevations;
   // address[33][33] owners;
    Tile[33][33] tiles;
    bool ownersinitialized = false;
    bool elevationsinitialized = false;
    bool[33] ownerrowsinitialized;
    bool[33] elevationrowsinitialized;
    
    // TODO: 
    // 3. Mouseover
    // 4. Block locations & colors
    
    struct Tile {
    	uint8 elevation;
    	address owner;
    	int144 saleprice; // 0 = not for sale. 0-4700000000000000000000 wei (approx) (0-4700 ether)
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
    
    function getSalePrices() constant returns(int144[33][33])
    {
        int144[33][33] memory prices;
        for(uint8 y = 0; y < mapsize; y++)
        {
        	for(uint8 x = 0; x < mapsize; x++)
        	{
        		prices[x][y] = tiles[x][y].saleprice; 
        	}	
        }	
    	return prices;
    }

    /**********
     Standard kill() function to recover funds 
     **********/
    
    function kill()
    { 
        if (msg.sender == creator)
        {
            suicide(creator);  // kills this contract and sends remaining funds back to creator
        }
    }
}