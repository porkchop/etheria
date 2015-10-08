import "mortal";

contract Etheria is mortal{
	
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
    uint liquidBalance = 0;
    uint illiquidBalance = 0;
    uint8 SEA_LEVEL = 125;
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	address[] offerers;
    	uint[] offers;
    	int8[] blocks; // index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz (< 0 = not yet placed)
    	               // index 4 = r, index 5 = g, index 6 = b
    	uint lastfarm;
    }
    
    function Etheria() {
    	owner = msg.sender;
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
    	if(tiles[x][y].elevation >= SEA_LEVEL && tiles[x][y].owner == 0 && msg.value == 1000000000000000000) // 1 eth
    	{
    		tiles[x][y].owner = msg.sender;
    		liquidBalance+=msg.value;
    	}
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
    
    function getUint8FromByte32(bytes32 _b32, uint8 byteindex) public constant returns(uint8) {
    	uint numdigits = 64;
    	uint buint = uint(_b32);
    	uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64 (SEE EXCEPTION BELOW), @i=1 upperpowervar=16**62, @i upperpowervar=16**60
    	uint lowerpowervar = 16 ** (numdigits - 2 - (byteindex*2));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
    	uint postheadchop;
    	if(byteindex == 0)
    		postheadchop = buint; 								//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
    	else
    		postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1 (to uint), @i=1 b=b2, @i=2 b=c3
    	return uint8(b);
    }
    
    function farmTile(uint8 x, uint8 y)
    {
        if(tiles[x][y].owner != msg.sender)
            return;
        if((block.number - tiles[x][y].lastfarm) < 4320) // a day's worth of blocks hasn't passed yet. can only farm once a day. (Assumes block times of 20 seconds.)
        	return;
        bytes32 lastblockhash = block.blockhash(block.number - 1);
        uint8 digit0to255;
    	// index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz, index 4 = r, index 5 = g, index 6 = b
    	uint8 i = 0;
    	while(i < 10)
    	{
    	    digit0to255 = getUint8FromByte32(lastblockhash,i);
            tiles[x][y].blocks.length+=7;
        	if(digit0to255 < 6) // 6 possibilities (of 256) , 0,1,2,3,4,5
        	{
        	    // ACTION BLOCK!
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 7] = 14;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 6] = 3;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 5] = 3;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 4] = -1;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 3] = -128;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 2] = 0;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1] = -128;
        	}
        	else // normal block
        	{
        	    if(digit0to255 % 16 > 13) // for 0xa7, get 7. Is it 0-13? If not, force it to zero. 
        	        digit0to255 = 0;
        	    else
        	        digit0to255 = digit0to255 % 16;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 7] = int8(digit0to255); // guaranteed 0-13
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 6] = -3;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 5] = -3;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 4] = -1;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 3] = 0;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 2] = -128;
        	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1] = -128;
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
    	uint metaindex = indexOfBlockToEdit*7;
        //current.blocks[metaindex] = error; // irrelevant. We can't change which type of block it is
    	tiles[x][y].blocks[metaindex + 1] = block[1];
    	tiles[x][y].blocks[metaindex + 2] = block[2];
    	tiles[x][y].blocks[metaindex + 3] = block[3];
    	tiles[x][y].blocks[metaindex + 4] = block[4];
    	tiles[x][y].blocks[metaindex + 5] = block[5];
    	tiles[x][y].blocks[metaindex + 6] = block[6];
    	return;
    }
    
    function getBlocks(uint8 x, uint8 y) constant returns (int8[])
    {
    	return tiles[x][y].blocks;
    }
    
    // TODO:
    // DONE block texturing
    // angle camera
    // block edit validation coordinate constraints
    // block edit validation must touch, no overlap
    // block lookup caching 
    // block trading
    // register name for owner
    // reclamation
    // price modifier
   
    
    // FULL GAME TODO:
    // Fitness vote
    // Cast threat
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
    
    function makeOffer(uint8 x, uint8 y)
    {
    	if(msg.value == 0)
    		return;
    	else if(msg.value < 10000000000000000 || msg.value > 1208925819614629174706175) // .01 ether up to (2^80 - 1) wei is the valid range
    	{
    		msg.sender.send(msg.value); 		// return their money
    		return;
    	}
    	else
    	{
    		if(tiles[x][y].offerers.length > 10) // this tile can only hold 10 offers at a time
    			return;
    		else
    		{
    			for(uint8 i = 0; i < tiles[x][y].offerers.length; i++)
    			{
    				if(tiles[x][y].offerers[i] == msg.sender) // user has already made an offer. Update it and return;
    				{
    					msg.sender.send(tiles[x][y].offers[i]); // return their previous money
    					illiquidBalance-=tiles[x][y].offers[i];
    					tiles[x][y].offers[i] = msg.value; // set the new offer
    					illiquidBalance+=msg.value;
    					return;
    				}
    			}	
    			// the user has not yet made an offer
    			tiles[x][y].offerers.length++; // make room for 1 more
    			tiles[x][y].offers.length++; // make room for 1 more
    			tiles[x][y].offerers[tiles[x][y].offerers.length - 1] = msg.sender; // record who is making the offer
    			tiles[x][y].offers[tiles[x][y].offers.length - 1] = msg.value; // record the offer
    			illiquidBalance+=msg.value;
    		}	
    	}
    }
    
    function retractOffer(uint8 x, uint8 y) // retracts the first offer in the array by this user.
    {
        for(uint8 i = 0; i < tiles[x][y].offerers.length; i++)
    	{
    		if(tiles[x][y].offerers[i] == msg.sender) // this user has an offer on file. Remove it.
    			removeOffer(x,y,i);
    	}	
    }
    
    function rejectOffer(uint8 x, uint8 y, uint8 i) // index 0-10
    {
    	if(tiles[x][y].owner != msg.sender) // only the owner can reject offers
    		return;
    	removeOffer(x,y,i);
		return;
    }
    
    function removeOffer(uint8 x, uint8 y, uint8 i) private // index 0-10, can't be odd
    {
    	// return the money
        tiles[x][y].offerers[i].send(tiles[x][y].offers[i]);
        illiquidBalance-=tiles[x][y].offers[i];
    			
    	// delete user and offer and reshape the array
    	delete tiles[x][y].offerers[i];   // zero out user
    	delete tiles[x][y].offers[i];   // zero out offer
    	for(uint8 j = i+1; j < tiles[x][y].offerers.length; j++) // close the arrays after the gap
    	{
    	    tiles[x][y].offerers[j-1] = tiles[x][y].offerers[j];
    	    tiles[x][y].offers[j-1] = tiles[x][y].offers[j];
    	}
    	tiles[x][y].offerers.length--;
    	tiles[x][y].offers.length--;
    	return;
    }
    
    function acceptOffer(uint8 x, uint8 y, uint8 i) // accepts the offer at index (1-10)
    {
    	tiles[x][y].owner.send(tiles[x][y].offers[i]); // send offer money to oldowner
    	illiquidBalance-=tiles[x][y].offers[i];
    	tiles[x][y].owner = tiles[x][y].offerers[i]; // new owner is the offerer
    	delete tiles[x][y].offerers; // delete all offerers
    	delete tiles[x][y].offers; // delete all offers
    	return;
    }
    
    function getOfferers(uint8 x, uint8 y) constant returns (address[])
    {
    	return tiles[x][y].offerers;
    }
    
    function getOffers(uint8 x, uint8 y) constant returns (uint[])
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
    	if(msg.sender == owner)
    		owner.send(liquidBalance);
    }
}