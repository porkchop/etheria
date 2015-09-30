contract Etheria {

//	Clear objective
//	Rules
//	Interaction
//	Catch-up
//	Inertia -- the game must move towards completion
//	Surprise
//	Strategy -- the ability to get better with time, improved skill
//	Fun
//	Flavor
	
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
    	int144 saleprice; // 0 = not for sale. 0-4700000000000000000000 wei (approx) (0-4700 ether)
    	Block[] blocks;
    }
    
    struct Block 
    {
    	uint8 which;
    	int8 x;
    	int8 y;
    	uint8 z;
    	bytes3 color;
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
    
    function getByteFromByte32(bytes32 _b32, uint8 byteindex) public constant returns(byte) {
    	if(byteindex > 31)
    		return 0x0;
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
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return byte(b);
    }
    
    function getByte3FromByte32(bytes32 _b32, uint8 byteindex) public constant returns(bytes3) {
    	if(byteindex > 29)
    		return 0x0;
    	uint numdigits = 64;
    	uint buint = uint(_b32);
    	uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64 (SEE EXCEPTION BELOW), @i=1 upperpowervar=16**62, @i upperpowervar=16**60
    	uint lowerpowervar = 16 ** (numdigits - 6 - (byteindex*2));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
    	uint postheadchop;
    	if(byteindex == 0)
    		postheadchop = buint; 								//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
    	else
    		postheadchop = buint % upperpowervar; 				// @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	uint remainder = postheadchop % lowerpowervar; 			// @i=0 remainder=b2c3d4, @i=1 remainder=c3d4, @i=2 remainder=d4
    	uint evenedout = postheadchop - remainder; 				// @i=0 evenedout=a1000000, @i=1 remainder=b20000, @i=2 remainder=c300
    	uint b = evenedout / lowerpowervar; 					// @i=0 b=a1, @i=1 b=b2, @i=2 b=c3
    	return bytes3(b);
    }
    
    function addSomeRandomBlocks()
    {
    	uint previousblock = block.number - 1 ; // previous block is the block when the transaction was mined  (current is previousblock + 1)
    	bytes32 previousblockhash = block.blockhash(previousblock);
    	
    	// which, x, y, (z=0), color, tilex, tiley --> 6 variables
    	byte b0 = getByteFromByte32(previousblockhash, 0);
    	byte b1 = getByteFromByte32(previousblockhash, 1);
    	byte b2 = getByteFromByte32(previousblockhash, 2);
    	uint8 which = uint8(b0) % 16; // gets second digit (out of 64)
    	int8 x = int8(b1) % 16; // gets 4th digit (out of 64)
    	int8 y = int8(b2) % 16; // gets 6th digit (out of 64)
    	//uint8 z;
    	bytes3 color = getByte3FromByte32(previousblockhash, 3);
    	
    	byte b3 = getByteFromByte32(previousblockhash, 3);
    	byte b4 = getByteFromByte32(previousblockhash, 4);
    	int8 tilex = int8(b3) % 16;
    	int8 tiley = int8(b4) % 16;
    	Block memory newblock = Block(which, x, y, 0, color);
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