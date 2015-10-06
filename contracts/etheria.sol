import "mortal";

contract Etheria is mortal {
	
	/***
	 *     _____             _                  _     _       _ _   
	 *    /  __ \           | |                | |   (_)     (_) |  
	 *    | /  \/ ___  _ __ | |_ _ __ __ _  ___| |_   _ _ __  _| |_ 
	 *    | |    / _ \| '_ \| __| '__/ _` |/ __| __| | | '_ \| | __|
	 *    | \__/\ (_) | | | | |_| | | (_| | (__| |_  | | | | | | |_ 
	 *     \____/\___/|_| |_|\__|_|  \__,_|\___|\__| |_|_| |_|_|\__|
	 *                                                              
	 *                                                              
	 */
	
    uint8 mapsize = 17;
    Tile[17][17] tiles;
    bool allrowsinitialized;
    bool[17] rowsinitialized;
    uint80 initialPrice = 250000000000000000;
    uint liquidBalance = 0;
    uint illiquidBalance = 0;
    uint8 SEA_LEVEL = 125;
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	bytes20[] offers;
    	int8[] blocks; // index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz (< 0 = not yet placed)
    	               // index 4 = r, index 5 = g, index 6 = b
    	uint lastfarm;
    }
    
    /***
     *    ___  ___              _       _ _   
     *    |  \/  |             (_)     (_) |  
     *    | .  . | __ _ _ __    _ _ __  _| |_ 
     *    | |\/| |/ _` | '_ \  | | '_ \| | __|
     *    | |  | | (_| | |_) | | | | | | | |_ 
     *    \_|  |_/\__,_| .__/  |_|_| |_|_|\__|
     *                 | |                    
     *                 |_|                    
     */
    
    function initializeTiles(uint8 row, uint8[17] _elevations)
    {
    	if(allrowsinitialized == true)
    		return;
    	
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    	    tiles[x][row].elevation = _elevations[x];
    	
    	rowsinitialized[row] = true;
    	
    	for(uint r = 0; r < mapsize; r++)
    	{
    		if(rowsinitialized[r] == false) // at least one row is not yet initialized. Return.
    			return;
    	}	
    	allrowsinitialized = true;
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
    
    /***
     *    ______                                                        _   _   _ _           
     *    | ___ \                                                      | | | | (_) |          
     *    | |_/ /_   _ _   _   _   _ _ __   _____      ___ __   ___  __| | | |_ _| | ___  ___ 
     *    | ___ \ | | | | | | | | | | '_ \ / _ \ \ /\ / / '_ \ / _ \/ _` | | __| | |/ _ \/ __|
     *    | |_/ / |_| | |_| | | |_| | | | | (_) \ V  V /| | | |  __/ (_| | | |_| | |  __/\__ \
     *    \____/ \__,_|\__, |  \__,_|_| |_|\___/ \_/\_/ |_| |_|\___|\__,_|  \__|_|_|\___||___/
     *                  __/ |                                                                 
     *                 |___/                                                                  
     */
   
    function buyTile(uint8 x, uint8 y) 
    {
    	if(msg.value == 0) // must provide cash money to buy tiles
    		return;
    	if(tiles[x][y].elevation >= SEA_LEVEL && tiles[x][y].owner == 0 && msg.value == initialPrice)
    		  tiles[x][y].owner = msg.sender;
    	else
    		msg.sender.send(msg.value); // return money
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
    
    /***
     *    ______                     _   _ _                        _ _ _     _     _            _        
     *    |  ___|                   | | (_) |                      | (_) |   | |   | |          | |       
     *    | |_ __ _ _ __ _ __ ___   | |_ _| | ___  ___      ___  __| |_| |_  | |__ | | ___   ___| | _____ 
     *    |  _/ _` | '__| '_ ` _ \  | __| | |/ _ \/ __|    / _ \/ _` | | __| | '_ \| |/ _ \ / __| |/ / __|
     *    | || (_| | |  | | | | | | | |_| | |  __/\__ \_  |  __/ (_| | | |_  | |_) | | (_) | (__|   <\__ \
     *    \_| \__,_|_|  |_| |_| |_|  \__|_|_|\___||___( )  \___|\__,_|_|\__| |_.__/|_|\___/ \___|_|\_\___/
     *                                                |/                                                  
     *                                                                                                    
     */
    
    function farmTile(uint8 x, uint8 y)
    {
        if(tiles[x][y].owner != msg.sender)
            return;
        if((block.number - tiles[x][y].lastfarm) < 4320) // a day's worth of blocks hasn't passed yet. can only farm once a day. (Assumes block times of 20 seconds.)
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
    	tiles[x][y].lastfarm = block.number;
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
    
    // TODO:
    // FRONTEND
    // display blocks on frontend
    // block edit validation (coordinate limits, connections, etc)
    
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
    
    /***
     *     _____  __  __              
     *    |  _  |/ _|/ _|             
     *    | | | | |_| |_ ___ _ __ ___ 
     *    | | | |  _|  _/ _ \ '__/ __|
     *    \ \_/ / | | ||  __/ |  \__ \
     *     \___/|_| |_| \___|_|  |___/
     *                                
     *                                
     */
    
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
    			illiquidBalance+=offer;
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

    	uint8 i = index*2;
    	address offerer = address(tiles[x][y].offers[i]);
    	uint80 amount = uint80(tiles[x][y].offers[i+1]);
    	i = i + 2;
		while(i < tiles[x][y].offers.length)
		{
			tiles[x][y].offers[i-2] = tiles[x][y].offers[i];   // readjust array 
			tiles[x][y].offers[i-1] = tiles[x][y].offers[i+1]; // readjust array
			i+=2;
		}	
		tiles[x][y].offers.length-=2; // shorten offer array by 2
		offerer.send(amount);
		illiquidBalance-=amount;
		return;
    }
    
    function acceptOffer(uint8 x, uint8 y, uint8 index) // accepts the offer at index (1-10)
    {
    	uint8 i = 0;
    	address newowner = address(tiles[x][y].offers[index*2]);
    	uint80 amount = uint80(tiles[x][y].offers[index*2+1]);
    	tiles[x][y].offers.length = 0;
    	address oldowner = tiles[x][y].owner;
    	tiles[x][y].owner = newowner;
    	oldowner.send(amount);
    	illiquidBalance-=amount;
    	return;
    }
    
    function getOffers(uint8 x, uint8 y) returns (bytes20[])
    {
    	return tiles[x][y].offers;
    }
    
    /***
     *     _____             _                  _     _           _                           
     *    /  __ \           | |                | |   | |         | |                          
     *    | /  \/ ___  _ __ | |_ _ __ __ _  ___| |_  | |__   __ _| | __ _ _ __   ___ ___  ___ 
     *    | |    / _ \| '_ \| __| '__/ _` |/ __| __| | '_ \ / _` | |/ _` | '_ \ / __/ _ \/ __|
     *    | \__/\ (_) | | | | |_| | | (_| | (__| |_  | |_) | (_| | | (_| | | | | (_|  __/\__ \
     *     \____/\___/|_| |_|\__|_|  \__,_|\___|\__| |_.__/ \__,_|_|\__,_|_| |_|\___\___||___/
     *                                                                                        
     */
    
    function getLiquidBalance() constant returns(uint)
    {
    	return liquidBalance;
    }
    
    function getIlliquidBalance() constant returns(uint)
    {
    	return illiquidBalance;
    }
    
    function retrieveLiquidBalance() onlyowner
    {
    	owner.send(liquidBalance);
    }
}