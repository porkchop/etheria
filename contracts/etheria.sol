contract Etheria //is EtheriaHelper 
{
	
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
    	int8[3][] occupado;
    }
    
	
    function Etheria() {
    	creator = msg.sender;
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
    
    function initElevations(uint8 row, uint8[17] _elevations)
    {
// TODO
//    	if(msg.sender != initializer)
//    		return;
    	for(uint8 col = 0; col < mapsize; col++)
    		tiles[col][row].elevation = _elevations[col];
    }
    
    function getElevations() constant returns (uint8[17][17])
    {
        uint8[17][17] memory elevations;
        for(uint8 row = 0; row < mapsize; row++)
        {
        	for(uint8 col = 0; col < mapsize; col++)
        	{
        		elevations[col][row] = tiles[col][row].elevation; 
        	}	
        }	
    	return elevations;
    }
    
    function getOwners() constant returns(address[17][17])
    {
        address[17][17] memory owners;
        for(uint8 row = 0; row < mapsize; row++)
        {
        	for(uint8 col = 0; col < mapsize; col++)
        	{
        	    owners[col][row] = tiles[col][row].owner; 
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
    // see EtheriaHelper for non-refucktored version of this algorithm.
    function getUint8FromByte32(bytes32 _b32, uint8 byteindex) private constant returns(uint8) 
    {
    	if(byteindex == 0)
    		return uint8((uint(_b32) - (uint(_b32) % (16 ** (64 - 2 - (byteindex*2))))) / (16 ** (64 - 2 - (byteindex*2)))); 	
    	else
    		return uint8(((uint(_b32) % (16 ** (64 - (byteindex*2)))) - ((uint(_b32) % (16 ** (64 - (byteindex*2)))) % (16 ** (64 - 2 - (byteindex*2))))) / (16 ** (64 - 2 - (byteindex*2)))); 	
    }
    
    function farmTile(uint8 col, uint8 row)
    {
        if(tiles[col][row].owner != msg.sender)
            return;
        if((block.number - tiles[col][row].lastfarm) < 4320) // a day's worth of blocks hasn't passed yet. can only farm once a day. (Assumes block times of 20 seconds.)
        	return;
        bytes32 lastblockhash = block.blockhash(block.number - 1);
    	for(uint8 i = 0; i < 20; i++)
    	{
            tiles[col][row].blocks.length+=5;
    	    tiles[col][row].blocks[tiles[col][row].blocks.length - 1][0] = int8(getUint8FromByte32(lastblockhash,i) % 32); // which, guaranteed 0-31
    	    tiles[col][row].blocks[tiles[col][row].blocks.length - 1][1] = 0; // x
    	    tiles[col][row].blocks[tiles[col][row].blocks.length - 1][2] = 0; // y
    	    tiles[col][row].blocks[tiles[col][row].blocks.length - 1][3] = -1; // z
    	    tiles[col][row].blocks[tiles[col][row].blocks.length - 1][4] = 0; // color
    	}
    	tiles[col][row].lastfarm = block.number;
    }
    
    function editBlock(uint8 col, uint8 row, uint index, int8[5] block)  
    {
        if(tiles[col][row].owner != msg.sender)
            return;
        if(block[3] < -1) // Can't hide blocks or change configuration of hidden blocks. This limitation is to prevent massive reorganization of occupado. 
        	return;
        block[0] = tiles[col][row].blocks[index][0]; // can't change the which, so set it to whatever it already was
              
    	if(isValidBlockLocation(col,row,block[0],block[1],block[2],block[3]))
        {	// the new placement is valid
        	// get the proposed new 8 hex locations
         	int8[3][8] wouldoccupy = blocks[uint(block[0])].occupies;
         	for(uint8 b = 0; b < 8; b++) // always 8 hexes
         	{
         		wouldoccupy[b][0] = wouldoccupy[b][0]+block[1];
         		wouldoccupy[b][1] = wouldoccupy[b][1]+block[2];
         		if(wouldoccupy[0][1] % 2 != 0 && wouldoccupy[b][1]%2 != 0)
         			wouldoccupy[b][0] = wouldoccupy[b][0]+1; // anchor y and this hex y are both odd, offset by +1
         		wouldoccupy[b][2] = wouldoccupy[b][2]+block[3];
         	}
        	
         	if(tiles[col][row].blocks[index][3] >= 0) // If the previous z was greater than 0 (i.e. not hidden) ...
         	{
         		// get the previous 8 hex locations
         		int8[3][8] didoccupy = blocks[uint(block[0])].occupies;
             	for(uint8 a = 0; a < 8; a++) // always 8 hexes
             	{
             		didoccupy[a][0] = didoccupy[a][0]+tiles[col][row].blocks[index][1];
             		didoccupy[a][1] = didoccupy[a][1]+tiles[col][row].blocks[index][2];
             		if(didoccupy[0][1] % 2 != 0 && didoccupy[a][1]%2 != 0)
             			didoccupy[a][0] = didoccupy[a][0]+1; // anchor y and this hex y are both odd, offset by +1
             		didoccupy[a][2] = didoccupy[a][2]+tiles[col][row].blocks[index][3];
             	}
             	
             	for(uint8 l = 0; l < 8; l++) // loop 8 times,find the previous occupado entries and overwrite them
             	{
             		for(uint o = 0; o < tiles[col][row].occupado.length; o++)
             		{
             			if(didoccupy[l][0] == tiles[col][row].occupado[o][0] && didoccupy[l][1] == tiles[col][row].occupado[o][1] && didoccupy[l][2] == tiles[col][row].occupado[o][2]) // are the arrays equal?
             			{
             				tiles[col][row].occupado[o] = wouldoccupy[l]; // found it. Overwrite it
             			}
             		}
             	}
         	}
         	else // previous block was hidden
         	{
         		for(uint8 ll = 0; ll < 8; ll++) // add the 8 new hexes to occupado
             	{
         			tiles[col][row].occupado.length++;
         			tiles[col][row].occupado[tiles[col][row].occupado.length-1] = wouldoccupy[ll];
             	}
         	}	
         	tiles[col][row].blocks[index] = block;
        }
        // else not a valid block location, return
    	return;
    }
    
    function getBlocks(uint8 col, uint8 row) constant returns (int8[5][])
    {
    	return tiles[col][row].blocks;
    }
    
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
    
    Block[20] blocks;
    struct Block
    {
    	uint8 which;
    	int8[3][8] occupies; // [x,y,z] 8 times
    	int8[3][] surroundedby; // [x,y,z]
    }
    
    function initBlockDef(uint8 which, int8[3][8] occupies, int8[3][] surroundedby)
    {
// TODO
//    	if(msg.sender != initializer)
//    		return;
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
    
//    function getOccupies(int8 which, int8 x, int8 y, int8 z) private constant returns (int8[3][8])
//    {
//    	int8[3][8] wouldoccupy = blocks[uint(which)].occupies;
//    	for(uint8 b = 0; b < 8; b++) // always 8 hexes
//    	{
//    		wouldoccupy[b][0] = wouldoccupy[b][0]+x;
//    		wouldoccupy[b][1] = wouldoccupy[b][1]+y;
//    		if(y % 2 != 0 && wouldoccupy[b][1]%2 != 0)
//    			wouldoccupy[b][0] = wouldoccupy[b][0]+1; // anchor y and this hex y are both odd, offset by +1
//    		wouldoccupy[b][2] = wouldoccupy[b][2]+z;
//    	}
//    	return wouldoccupy;
//    }
//    
//    function getSurroundings(int8 which, int8 x, int8 y, int8 z) private constant returns (int8[3][])
//    {
//    	int8[3][] surroundings = blocks[uint(which)].surroundedby;
//    	for(uint8 b = 0; b < surroundings.length; b++)
//    	{
//    		surroundings[b][0] = surroundings[b][0]+x;
//    		surroundings[b][1] = surroundings[b][1]+y;
//    		if(y % 2 != 0 && surroundings[b][1]%2 != 0)
//    			surroundings[b][0] = surroundings[b][0]+1; // anchor y and this hex y are both odd, offset by +1
//    		surroundings[b][2] = surroundings[b][2]+z;
//    	}
//    	return surroundings;
//    }
    
    function isValidBlockLocation(uint8 col, uint8 row, int8 which, int8 x, int8 y, int8 z) private constant returns (bool)
    {
    	// first, get the 8 hexes it would occupy
    	int8[3][8] wouldoccupy = blocks[uint(which)].occupies;
    	for(uint8 b = 0; b < 8; b++) // always 8 hexes
    	{
    		wouldoccupy[b][0] = wouldoccupy[b][0]+x;
    		wouldoccupy[b][1] = wouldoccupy[b][1]+y;
    		if(y % 2 != 0 && wouldoccupy[b][1]%2 != 0)
    			wouldoccupy[b][0] = wouldoccupy[b][0]+1; // anchor y and this hex y are both odd, offset by +1
    		wouldoccupy[b][2] = wouldoccupy[b][2]+z;
    		if(!blockHexCoordsValid(wouldoccupy[b][0], wouldoccupy[b][1])) // this is the out-of-bounds check
    			return false;
    	}
    	
    	int8[3][] surroundings = blocks[uint(which)].surroundedby;
    	for(b = 0; b < surroundings.length; b++)
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
    		for(uint o = 0; o < tiles[col][row].occupado.length; o++)
    		{
    			if(l < 8 && wouldoccupy[l][0] == tiles[col][row].occupado[o][0] && wouldoccupy[l][1] == tiles[col][row].occupado[o][1] && wouldoccupy[l][2] == tiles[col][row].occupado[o][2]) // are the arrays equal?
					return false; // this hex conflicts. The proposed block does not avoid overlap. Return false immediately.
    			if(touches == false && wouldoccupy[l][2] == 0) // if on the ground, touches is always true
    				touches = true;
    			if(touches == false && l < surroundings.length && surroundings[l][0] == tiles[col][row].occupado[o][0] && surroundings[l][1] == tiles[col][row].occupado[o][1] && surroundings[l][2] == tiles[col][row].occupado[o][2]) // are the arrays equal?
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
    
    function blockHexCoordsValid(int8 x, int8 y) private constant returns (bool)
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
    		uint8 absx;
			uint8 absy;
			if(x < 0)
				absx = uint8(x*-1);
			else
				absx = uint8(x);
			if(y < 0)
				absy = uint8(y*-1);
			else
				absy = uint8(y);
    		if((y >= 0 && x >= 0) || (y < 0 && x > 0)) // first or 4th quadrants
    		{
    			if(y % 2 != 0 ) // odd
    			{
    				if (((absx*2) + (absy*3)) <= 198)
    					return true;
    			}	
    			else	// even
    			{
    				if ((((absx+1)*2) + ((absy-1)*3)) <= 198)
    					return true;
    			}
    		}
    		else
    		{	
    			if(y % 2 == 0 ) // even
    			{
    				if (((absx*2) + (absy*3)) <= 198)
    					return true;
    			}	
    			else	// odd
    			{
    				if ((((absx+1)*2) + ((absy-1)*3)) <= 198)
    					return true;
    			}
    		}
    	}
    	return false;
    }
    
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
    
    function makeOffer(uint8 col, uint8 row)
    {
    	if(msg.value < 10000000000000000 || msg.value > 1208925819614629174706175) // .01 ether up to (2^80 - 1) wei is the valid range
    	{
    		if(!(msg.value == 0))
    			msg.sender.send(msg.value); 		// return their money
    		return;
    	}
    	else if(tiles[col][row].elevation >= 125 && tiles[col][row].owner == address(0)) // if unowned and above sea level, accept offer of 1 ETH immediately
    	{
    		if(msg.value != 1000000000000000000) // 1 ETH is the starting value. If not enough or too much...
    		{
    			msg.sender.send(msg.value); 	 // return their money
        		return;
    		}	
    		else
    		{
    			creator.send(msg.value);     		 // this was a valid offer, send money to contract owner
    			tiles[col][row].owner = msg.sender;  // set tile owner to the buyer
    			return;		
    		}	
    	}	
    	else
    	{
    		if(tiles[col][row].offerers.length < 10) // this tile can only hold 10 offers at a time
    		{
    			for(uint8 i = 0; i < tiles[col][row].offerers.length; i++)
    			{
    				if(tiles[col][row].offerers[i] == msg.sender) // user has already made an offer. Update it and return;
    				{
    					msg.sender.send(tiles[col][row].offers[i]); // return their previous money
    					tiles[col][row].offers[i] = msg.value; // set the new offer
    					return;
    				}
    			}	
    			// the user has not yet made an offer
    			tiles[col][row].offerers.length++; // make room for 1 more
    			tiles[col][row].offers.length++; // make room for 1 more
    			tiles[col][row].offerers[tiles[col][row].offerers.length - 1] = msg.sender; // record who is making the offer
    			tiles[col][row].offers[tiles[col][row].offers.length - 1] = msg.value; // record the offer
    		}	
    	}
    }
    
    function retractOffer(uint8 col, uint8 row) // retracts the first offer in the array by this user.
    {
        for(uint8 i = 0; i < tiles[col][row].offerers.length; i++)
    	{
    		if(tiles[col][row].offerers[i] == msg.sender) // this user has an offer on file. Remove it.
    			removeOffer(col,row,i);
    	}	
    }
    
    function rejectOffer(uint8 col, uint8 row, uint8 i) // index 0-10
    {
    	if(tiles[col][row].owner != msg.sender) // only the owner can reject offers
    		return;
    	removeOffer(col,row,i);
		return;
    }
    
    function removeOffer(uint8 col, uint8 row, uint8 i) private // index 0-10, can't be odd
    {
    	// return the money
        tiles[col][row].offerers[i].send(tiles[col][row].offers[i]);
    			
    	// delete user and offer and reshape the array
    	delete tiles[col][row].offerers[i];   // zero out user
    	delete tiles[col][row].offers[i];   // zero out offer
    	for(uint8 j = i+1; j < tiles[col][row].offerers.length; j++) // close the arrays after the gap
    	{
    	    tiles[col][row].offerers[j-1] = tiles[col][row].offerers[j];
    	    tiles[col][row].offers[j-1] = tiles[col][row].offers[j];
    	}
    	tiles[col][row].offerers.length--;
    	tiles[col][row].offers.length--;
    	return;
    }
    
    function acceptOffer(uint8 col, uint8 row, uint8 i) // accepts the offer at index (1-10)
    {
    	tiles[col][row].owner.send(tiles[col][row].offers[i]); // send offer money to oldowner
    	tiles[col][row].owner = tiles[col][row].offerers[i]; // new owner is the offerer
    	delete tiles[col][row].offerers; // delete all offerers
    	delete tiles[col][row].offers; // delete all offers
    	return;
    }
    
    function getOfferers(uint8 col, uint8 row) constant returns (address[])
    {
    	return tiles[col][row].offerers;
    }
    
    function getOffers(uint8 col, uint8 row) constant returns (uint[])
    {
    	return tiles[col][row].offers;
    }
    
}