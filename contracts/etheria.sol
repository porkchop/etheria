import "mortal";

contract Etheria is mortal {
	
    uint8 mapsize = 17;
    Tile[17][17] tiles;
    bool allrowsinitialized;
    bool[17] rowsinitialized;
    
    // TODO:
    // FRONTEND
    // display blocks on frontend
    // block edit validation (coordinate limits, connections, etc)
    
    // TILE TRADING
    // makeOffer
    // retractOffer
    // rejectOffer
    // acceptOffer
    // getOffers

    // BLOCK TRADING
    // sendBlock
    
    // MISC
    // withdrawal
    // register name for owner
    
    // FULL GAME TODO:
    // Fitness vote
    // Cast threat
    // reclamation
    // chat
    // messaging
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	bytes20[] offers;
    	int8[] blocks; // index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz (< 0 = not yet placed)
    	               // index 4 = r, index 5 = g, index 6 = b
    }
    
    function makeOffer(uint8 x, uint8 y, uint80 offer)
    {
    	if(msg.value == 0)
    		return;
    	else if(msg.value < 10000000000000000) 	// .01 ether is the lowest amount one can bid
    	{
    		msg.sender.send(msg.value); 		// return their piddly amount of money
    		return;
    	}
    	else
    	{
    		if(tiles[x][y].offers.length > 20) // this tile can only hold 10 offers at a time
    			return;
    		else
    		{
    			tiles[x][y].offers.length+=2; // make room for 2 more.
    			tiles[x][y].offers[tiles[x][y].offers.length - 2] = bytes20(msg.sender); // record who is making the offer
    			tiles[x][y].offers[tiles[x][y].offers.length - 1] = bytes20(offer);      // and what their offer is
    		}	
    	}
    }
    
    function retractOffer(uint8 x, uint8 y) // retracts the first offer in the array by this user.
    {
    	uint8 i = 0;
    	bytes20 msg_sender_b20 = bytes20(msg.sender);
    	while(i < tiles[x][y].offers.length)
    	{
    		if(tiles[x][y].offers[i] == msg_sender_b20) // this user has an offer on file. Remove it.
    		{
    			removeOffer(x,y,i);
    			return;
    		}	
    		i+=2;
    	}	
    }
    
    function rejectOffer(uint8 x, uint8 y, uint8 index) // index 1-10
    {
    	if(tiles[x][y].owner != msg.sender) // only the owner can reject offers
    		return;
    	removeOffer(x,y,index);
    }

    function removeOffer(uint8 x, uint8 y, uint8 index) private // index 1-10
    {
		if((index*2) > tiles[x][y].offers.length) // index beyond end of array
			return; 

    	uint8 i = index*2 + 2;
		while(i < tiles[x][y].offers.length)
		{
			tiles[x][y].offers[i-2] = tiles[x][y].offers[i];   // readjust array 
			tiles[x][y].offers[i-1] = tiles[x][y].offers[i+1]; // readjust array
			i+=2;
		}	
		tiles[x][y].offers.length-=2; // shorten offer array by 2
		return;
    }
    
    function acceptOffer(uint8 x, uint8 y, uint8 index) // accepts the offer at index (1-10)
    {
    	uint8 i = 0;
    	address newowner = address(tiles[x][y].offers[index*2]);
    	uint80 price = uint80(tiles[x][y].offers[index*2+1]);
    	tiles[x][y].offers.length = 0;
    	address oldowner = tiles[x][y].owner;
    	tiles[x][y].owner = newowner;
    	oldowner.send(price);
    }
    
    function getOffers(uint8 x, uint8 y) returns (bytes20[])
    {
    	return tiles[x][y].offers;
    }
    
    function initializeTiles(uint8[] rows, uint8[17] _elevations)
    {
    	if(allrowsinitialized == true)
    		return;
    	
    	if(rows.length > 255) // can't process this many rows -- would run out of gas anyway
    		return; 
    	
    	uint8 r = 0;
    	while(r < rows.length) // loop through the rows provided. are they valid?
    	{
    		if(rows[r] < 0 || rows[r] >= mapsize) // this row index is out of range
    			return;
    		r++;
    	}	

    	r=0;
    	while(r < rows.length) // loop through the rows provided again. 
    	{
    		for(uint8 x = 0; x < mapsize; x++) // for each row, loop through the xvalues and initialize the tiles
        	{
    			tiles[x][r].owner = owner;
        	    tiles[x][r].elevation = _elevations[x];
        	}
    		rowsinitialized[rows[r]] = true; // now set the flag that we've initialized this row
    		r++;
    	}	
    	
    	for(uint i = 0; i < mapsize; r++) // now check the rowsinitialized array. If all true, the map should be set in stone.
    	{
    		if(rowsinitialized[i] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	allrowsinitialized = true; // the map is now fully initialized and I can't change it again
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
}