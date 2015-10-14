contract Etheria {
	
	/***
	 *     _____             _                  _     _       _ _   
	 *    /  __ \           | |                | |   (_)     (_) |  
	 *    | /  \/ ___  _ __ | |_ _ __ __ _  ___| |_   _ _ __  _| |_ 
	 *    | |    / _ \| '_ \| __| '__/ _` |/ __| __| | | '_ \| | __|
	 *    | \__/\ (_) | | | | |_| | | (_| | (__| |_  | | | | | | |_ 
	 *     \____/\___/|_| |_|\__|_|  \__,_|\___|\__| |_|_| |_|_|\__|
	 *                                                              
	 */
    uint8 mapsize = 17;
    Tile[17][17] tiles;
    address initializer;
    address owner;
    
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
    	initializer = 0x1312fd55346f4ced45e0da98cd5ab0dc50a5459f; // some to-be-killed initializer contract
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
    	if(row >= mapsize) // this row index is out of bounds.
    		return; 
    	
    	for(uint8 x = 0; x < mapsize; x++)
    		tiles[x][row].elevation = _elevations[x];
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
    	uint postheadchop;
    	if(byteindex == 0)
    		postheadchop = uint(_b32); 								//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
    	else
    		postheadchop = uint(_b32) % (16 ** (64 - (byteindex*2))); 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint evenedout = postheadchop - (postheadchop % (16 ** (64 - 2 - (byteindex*2)))); 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint8 b = uint8(evenedout / (16 ** (64 - 2 - (byteindex*2)))); 					// @i=0 b=a1 (to uint), @i=1 b=b2, @i=2 b=c3
    	return b;
    }
    
    function farmTile(uint8 x, uint8 y)
    {
        if(tiles[x][y].owner != msg.sender)
            return;
        if((block.number - tiles[x][y].lastfarm) < 4320) // a day's worth of blocks hasn't passed yet. can only farm once a day. (Assumes block times of 20 seconds.)
        	return;
        bytes32 lastblockhash = block.blockhash(block.number - 1);
    	// index 0 = which, index 1 = blockx, index 2 = blocky, index 3 = blockz, index 4 = r, index 5 = g, index 6 = b
    	uint8 i = 0;
    	while(i < 10)
    	{
            tiles[x][y].blocks.length+=7;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 7] = int8(getUint8FromByte32(lastblockhash,i) % 32); // guaranteed 0-31
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 6] = -3;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 5] = -3;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 4] = -1;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 3] = 0;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 2] = -128;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1] = -128;
    	    i++;
    	}
    	tiles[x][y].lastfarm = block.number;
    }
    
    // NOTE: In this instance, block[0] is irrelevant. We can't change "which" type of block it is
    function editBlock(uint8 x, uint8 y, uint indexOfBlockToEdit, int8[7] block)  
    {
        if(tiles[x][y].owner != msg.sender)
            return;
    	uint metaindex = indexOfBlockToEdit*7;
        //current.blocks[metaindex] = error; // irrelevant. We can't change "which" type of block it is
    	tiles[x][y].blocks[metaindex + 1] = block[1]; //x 
    	tiles[x][y].blocks[metaindex + 2] = block[2]; //y
    	tiles[x][y].blocks[metaindex + 3] = block[3]; //z
    	tiles[x][y].blocks[metaindex + 4] = block[4]; //r
    	tiles[x][y].blocks[metaindex + 5] = block[5]; //g
    	tiles[x][y].blocks[metaindex + 6] = block[6]; //b
    	return;
    }
    
    function getBlocks(uint8 x, uint8 y) constant returns (int8[])
    {
    	return tiles[x][y].blocks;
    }
    
    // block edit validation
    
    
    
    // TODO:
    // DONE block texturing
    // DONE angle camera
    // DONE block edit validation coordinate constraints in JS
    // DONE block edit validation must touch, no overlap in JS
    // block edit validation coordinate constraints in solidity
    // block edit validation must touch, no overlap in solidity
    // DONE block lookup caching 
    // register name for owner
   
    // FULL GAME TODO:
    // Fitness vote
    // Cast threat
    // chat
    // messaging
    // block trading
    // reclamation
    // price modifier
    
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
    	if(msg.value < 10000000000000000 || msg.value > 1208925819614629174706175) // .01 ether up to (2^80 - 1) wei is the valid range
    	{
    		if(!(msg.value == 0))
    			msg.sender.send(msg.value); 		// return their money
    		return;
    	}
    	else if(tiles[x][y].elevation >= 125 && tiles[x][y].owner == address(0)) // if unowned and above sea level, accept offer of 1 ETH immediately
    	{
    		if(msg.value != 1000000000000000000) // 1 ETH is the starting value. If not enough or too much...
    		{
    			msg.sender.send(msg.value); 	 // return their money
        		return;
    		}	
    		else
    		{
    			owner.send(msg.value);     		 // this was a valid offer, send money to contract owner
    			tiles[x][y].owner = msg.sender;  // set tile owner to the buyer
    			return;		
    		}	
    	}	
    	else
    	{
    		if(tiles[x][y].offerers.length < 10) // this tile can only hold 10 offers at a time
    		{
    			for(uint8 i = 0; i < tiles[x][y].offerers.length; i++)
    			{
    				if(tiles[x][y].offerers[i] == msg.sender) // user has already made an offer. Update it and return;
    				{
    					msg.sender.send(tiles[x][y].offers[i]); // return their previous money
    					tiles[x][y].offers[i] = msg.value; // set the new offer
    					return;
    				}
    			}	
    			// the user has not yet made an offer
    			tiles[x][y].offerers.length++; // make room for 1 more
    			tiles[x][y].offers.length++; // make room for 1 more
    			tiles[x][y].offerers[tiles[x][y].offerers.length - 1] = msg.sender; // record who is making the offer
    			tiles[x][y].offers[tiles[x][y].offers.length - 1] = msg.value; // record the offer
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
    
    Block[20] blocks;
    struct Block
    {
    	uint8 which;
    	int8[3][8] occupies; // [x,y,z] 8 times
    	int8[3][] surroundedby; // [x,y,z]
//    	int8[3][16] surroundedby; // [x,y,z] 16 times (probably less than 16)
//    	int8 surroundedbylength;
    }
    
    function initBlockDef(uint8 which, int8[3][8] occupies, int8[3][] surroundedby)
    {
    		blocks[which].which = which;
        	for(uint8 o = 0; o < 8; o++)
        	{	
        		for(uint8 i = 0; i < 3; i++)
        		{
        			blocks[which].occupies[o][i] = occupies[o][i];
        		}
        	}
        	blocks[which].surroundedby.length = surroundedby.length;
        	for(uint8 oo = 0; oo < surroundedby.length; oo++)
        	{	
        		for(uint8 ii = 0; ii < 3; ii++)
        		{
        			blocks[which].surroundedby[oo][ii] = surroundedby[oo][ii];
        		}
        	}
    }
        
    int8[3][][17][17] occupado; 
    
    function initOccupado(uint col, uint row)
    {
    	int8 x;
    	int8 y;
    	for(y = -66; y <= 66; y++)
		{
			if(y % 2 != 0 ) // odd
				x = -50;
			else
				x = -49;
			
			if(y >= -33 && y <= 33)
			{
				for(x; x <= 49; x++)
				{
					occupado[col][row].length++;// = occupado[col][row].length+1;
					occupado[col][row][occupado[col][row].length-1][0] = x;
					occupado[col][row][occupado[col][row].length-1][1] = y;
					occupado[col][row][occupado[col][row].length-1][2] = -1;
					//occupado[col][row][occupado[col][row].length-1] = [x,y,-1]);
				}
			}	
			else
			{	
				int8 absx;
				int8 absy;
				for(x; x <= 49; x++)
				{
					absx = x;
					if(absx < 0)
						absx = absx*-1;
					absy = y;
					if(absy < 0)
						absy = absy*-1;
					if((y >= 0 && x >= 0) || (y < 0 && x > 0)) // first or 4th quadrants
					{
						if(y % 2 != 0 ) // odd
						{
							if (((absx/3) + (absy/2)) <= 33)
							{
								occupado[col][row].length++;
								occupado[col][row][occupado[col][row].length-1][0] = x;
					            occupado[col][row][occupado[col][row].length-1][1] = y;
					            occupado[col][row][occupado[col][row].length-1][2] = -1;
//								occupado[col][row].push([x,y,-1]);
							}
						}	
						else	// even
						{
							if ((((absx+1)/3) + ((absy-1)/2)) <= 33)
							{
								occupado[col][row].length++;
								occupado[col][row][occupado[col][row].length-1][0] = x;
					            occupado[col][row][occupado[col][row].length-1][1] = y;
					            occupado[col][row][occupado[col][row].length-1][2] = -1;
								//occupado[col][row].push([x,y,-1]);
							}
						}
					}
					else
					{	
						if(y % 2 == 0 ) // even
						{
							if (((absx/3) + (absy/2)) <= 33)
							{
								occupado[col][row].length++;
								occupado[col][row][occupado[col][row].length-1][0] = x;
					            occupado[col][row][occupado[col][row].length-1][1] = y;
					            occupado[col][row][occupado[col][row].length-1][2] = -1;
								//occupado[col][row].push([x,y,-1]);
							}
						}	
						else	// odd
						{
							if ((((absx+1)/3) + ((absy-1)/2)) <= 33)
							{
								occupado[col][row].length++;
								occupado[col][row][occupado[col][row].length-1][0] = x;
					            occupado[col][row][occupado[col][row].length-1][1] = y;
					            occupado[col][row][occupado[col][row].length-1][2] = -1;
								//occupado[col][row].push([x,y,-1]);
							}
						}
					}
				}
			}
		}	
    }
    
    // NEEDS NO INFORMATION FROM MAP... COULD BE PLACED IN ANOTHER CONTRACT
    function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
    {
    	if(-33 <= y && y <= 33)
    	{
    		if(y % 2 != 0 ) // odd
    		{
    			if(-50 <= x && x <= 49)
    				return true;
    		}
    		else // even
    		{
    			if(-49 <= x && x <= 49)
    				return true;
    		}	
    	}	
    	else
    	{	
    		int8 absx;
			int8 absy;
			absx = x;
			if(absx < 0)
				absx = absx*-1;
			absy = y;
			if(absy < 0)
				absy = absy*-1;
    		if((y >= 0 && x >= 0) || (y < 0 && x > 0)) // first or 4th quadrants
    		{
    			if(y % 2 != 0 ) // odd
    			{
    				if (((absx/3) + (absy/2)) <= 33)
    					return true;
    			}	
    			else	// even
    			{
    				if ((((absx+1)/3) + ((absy-1)/2)) <= 33)
    					return true;
    			}
    		}
    		else
    		{	
    			if(y % 2 == 0 ) // even
    			{
    				if (((absx/3) + (absy/2)) <= 33)
    					return true;
    			}	
    			else	// odd
    			{
    				if ((((absx+1)/3) + ((absy-1)/2)) <= 33)
    					return true;
    			}
    		}
    	}
    	return false;
    }
    
    function wouldFallOutside(int8 which, int8 x, int8 y) constant returns (bool)
    {
    	int8 occupiesx = 0;
    	int8 occupiesy = 0;
    	
    	for(uint8 b = 0; b < 8; b++) // always 8 hexes
    	{
    		occupiesx = blocks[uint(which)].occupies[b][0];
    		occupiesy = blocks[uint(which)].occupies[b][1];
    		if(y % 2 != 0 && occupiesy%2 != 0) // if y is odd, offset the x by 1
    		{
    			occupiesx = occupiesx + 1;
    		}
    		if(!blockHexCoordsValid(occupiesx+x, occupiesy+y))
    			return true;
    	}
    	return false;
    }
    
    function wouldOverlap(uint8 coordx, uint8 coordy, int8 which, int8 x, int8 y, int8 z) constant returns (bool)
    {
    	int8 occupiesx = 0;
    	int8 occupiesy = 0;
    	int8 occupiesz = 0;
    	
    	int8[3][8] memory wouldoccupy;
    	for(var b = 0; b < 8; b++) // always 8 hexes
    	{
    		occupiesx = blocks[uint(which)].occupies[b][0];
    		occupiesy = blocks[uint(which)].occupies[b][1];
    		occupiesz = blocks[uint(which)].occupies[b][2];
    		if(y % 2 != 0 && occupiesy%2 != 0) // if y is odd, offset the x by 1
    			occupiesx = occupiesx + 1;
    		wouldoccupy[b][0] = occupiesx+x;
    		wouldoccupy[b][1] = occupiesy+y;
    		wouldoccupy[b][2] = occupiesz+z;
    	}
    	
    	for(var w = 0; w < 8; w++) // do any of these 8 hexes appear in occupado?
    	{
    		for(var o = 0; o < occupado[coordx][coordy].length; o++)
    		{
    			if(wouldoccupy[w][0] == occupado[coordx][coordy][o][0] && wouldoccupy[w][1] == occupado[coordx][coordy][o][1] && wouldoccupy[w][2] == occupado[coordx][coordy][o][2]) // are the arrays equal?
    			{
    				return true;
    			}
    		}
    	}
    	return false;
    }
    
    function touchesAnother(uint8 coordx, uint8 coordy, int8 which, int8 x, int8 y, int8 z) constant returns (bool)
    {
    	//console.log('touches another?');
    	int8 sx = 0;
    	int8 sy = 0;
    	int8 sz = 0;
    	
    	uint surroundedbylength = uint(blocks[uint(which)].surroundedby.length);
    	int8[3][] memory surroundings;
    	for(var b = 0; b < surroundedbylength; b++)
    	{
    		sx = blocks[uint(which)].surroundedby[b][0];
    		sy = blocks[uint(which)].surroundedby[b][1];
    		sz = blocks[uint(which)].surroundedby[b][2];
    		
    		if(y % 2 != 0 && sy%2 != 0) // if y is odd, offset the x by 1
    		{
    			sx = sx + 1;
    		}
    		surroundings[b][0] = sx+x;
    		surroundings[b][1] = sy+y;
    		surroundings[b][2] = sz+z;
    	}
    	
    	for(var s = 0; s < surroundings.length; s++)
    	{
    		for(var o = 0; o < occupado[coordx][coordy].length; o++)
    		{
    			if(surroundings[s][0] == occupado[coordx][coordy][o][0] && surroundings[s][1] == occupado[coordx][coordy][o][1] && surroundings[s][2] == occupado[coordx][coordy][o][2]) // are the arrays equal?
    			{
    				return true;
    			}
    		}	
    	}	
    	return false;
    }
    
}