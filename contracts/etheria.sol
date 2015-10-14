contract HexCoordValidator 
{
	function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
	{}
}

contract Etheria is HexCoordValidator{
	
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
    bool initializerset;
    address initializer;
    address creator;
    
    struct Tile 
    {
    	uint8 elevation;
    	address owner;
    	address[] offerers;
    	uint[] offers;
    	int8[5][] blocks; //0 = which,1 = blockx,2 = blocky,3 = blockz, 4 = color
    	uint lastfarm;
    }
    
    HexCoordValidator hcv;
	
    function Etheria() {
    	creator = msg.sender;
    	hcv = HexCoordValidator(0x18b84dfffa22fc3bf502cc46ac64d13306df4d41);
    }
    
    function setInitializer(address _i)
    {
    	if(initializerset)
    		return;
    	initializer = _i;
    	initializerset = true;
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
    
    function initTiles(uint8 row, uint8[17] _elevations)
    {
    	if(msg.sender != initializer)
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
    	for(uint8 i = 0; i < 10; i++)
    	{
            tiles[x][y].blocks.length+=5;
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1][0] = int8(getUint8FromByte32(lastblockhash,i) % 32); // which, guaranteed 0-31
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1][1] = 0; // x
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1][2] = 0; // y
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1][3] = -1; // z
    	    tiles[x][y].blocks[tiles[x][y].blocks.length - 1][4] = 0; // color
    	}
    	tiles[x][y].lastfarm = block.number;
    }
    
    // NOTE: In this instance, block[0] is irrelevant. We can't change "which" type of block it is
    function editBlock(uint8 x, uint8 y, uint index, int8[5] block)  
    {
        if(tiles[x][y].owner != msg.sender)
            return;
        block[0] = tiles[x][y].blocks[index][0]; // can't change the which
        tiles[x][y].blocks[index] = block;
    	return;
    }
    
    function getBlocks(uint8 x, uint8 y) constant returns (int8[5][])
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
    			creator.send(msg.value);     		 // this was a valid offer, send money to contract owner
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
    }
    
    function initBlockDef(uint8 which, int8[3][8] occupies, int8[3][] surroundedby)
    {
    	if(msg.sender != initializer)
    		return;
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
    	if(msg.sender != initializer)
    		return;
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
    		address hexCoordValidator = 0x18b84dfffa22fc3bf502cc46ac64d13306df4d41;
    		if(!hcv.blockHexCoordsValid(occupiesx+x, occupiesy+y))
    			return true;
    	}
    	return false;
    }
    
    function touchesAndAvoidsOverlap(uint8 coordx, uint8 coordy, int8 which, int8 x, int8 y, int8 z) constant returns (bool)
    {
    	int8[3][8] wouldoccupy = blocks[uint(which)].occupies;
    	for(uint8 b = 0; b < 8; b++) // always 8 hexes
    	{
    		wouldoccupy[b][0] = wouldoccupy[b][0]+x;
    		wouldoccupy[b][1] = wouldoccupy[b][1]+y;
    		if(y % 2 != 0 && wouldoccupy[b][1]%2 != 0)
    			wouldoccupy[b][0] = wouldoccupy[b][0]+1; // anchor y and this hex y are both odd, offset by +1
    		wouldoccupy[b][2] = wouldoccupy[b][2]+z;
    	}
    	
    	int8[3][] surroundings = blocks[uint(which)].surroundedby;
    	for(uint8 bb = 0; bb < surroundings.length; bb++)
    	{
    		surroundings[b][0] = surroundings[b][0]+x;
    		surroundings[b][1] = surroundings[b][1]+y;
    		if(y % 2 != 0 && surroundings[b][1]%2 != 0)
    			surroundings[b][0] = surroundings[b][0]+1; // anchor y and this hex y are both odd, offset by +1
    		surroundings[b][2] = surroundings[b][2]+z;
    	}
    	
    	bool touches;
    	uint numloops = 8;
    	if(surroundings.length > 8)
    		numloops = surroundings.length;
    	
    	for(uint8 l = 0; l < numloops; l++)
    	{
    		for(uint o = 0; o < occupado[coordx][coordy].length; o++)
    		{
    			if(l < 8 && wouldoccupy[l][0] == occupado[coordx][coordy][o][0] && wouldoccupy[l][1] == occupado[coordx][coordy][o][1] && wouldoccupy[l][2] == occupado[coordx][coordy][o][2]) // are the arrays equal?
					return false; // this hex conflicts. The proposed block does not avoid overlap. Return false immediately.
    			if(touches == false && l < surroundings.length && surroundings[l][0] == occupado[coordx][coordy][o][0] && surroundings[l][1] == occupado[coordx][coordy][o][1] && surroundings[l][2] == occupado[coordx][coordy][o][2]) // are the arrays equal?
    				touches = true;
    		}
    		if(l >= 8 && touches == true)
    			return true;
    	}	
    	if(touches == true)
    		return true;
    	else
    		return false;
    }
}