contract EtheriaHelper
{
	// elevation storage
	// blockdef storage
	// utility methods
	
	Block[32] blockdefs;
    uint8[1089] elevations; // while this is a [a,b,c,d,a1,b1,c1,d1...] array, it should be thought of as
    // [[a,b,c,d], [a1,b1,c1,d1]...] where each subarray is a column.
    // since you'd access the subarray-style 2D array like this: col, row
    // that means that in the 1D array, the first grouping is the first col. The second grouping is the second col, etc
    // As such, element 1 is equivalent to 0,1 -- element 2 = 0,2 -- element 33 = 1,0 -- element 34 = 1,1
    // this is a bit counter intuitive. You might think it would be arranged first row, second row, etc... but you'd be wrong.
    
    struct Block
    {
    	int8[24] occupies; // [x0,y0,z0,x1,y1,z1...,x7,y7,z7] 
    	int8[48] attachesto; // [x0,y0,z0,x1,y1,z1...,x15,y15,z15] // first one that is 0,0,0 is the end
    }
    
    address creator;
    function EtheriaHelper()
    {
    	creator = msg.sender;
    }
    
    /***
     *     _____ _      _____ _   _  ___ _____ _____ _____ _   _  _____ 
     *    |  ___| |    |  ___| | | |/ _ \_   _|_   _|  _  | \ | |/  ___|
     *    | |__ | |    | |__ | | | / /_\ \| |   | | | | | |  \| |\ `--. 
     *    |  __|| |    |  __|| | | |  _  || |   | | | | | | . ` | `--. \
     *    | |___| |____| |___\ \_/ / | | || |  _| |_\ \_/ / |\  |/\__/ /
     *    \____/\_____/\____/ \___/\_| |_/\_/  \___/ \___/\_| \_/\____/ 
     *                                                                  
     *                                                                  
     */
    
    function getElevations() constant returns (uint8[1089])
    {
    	return elevations;
    }
    
    function getElevation(uint8 col, uint8 row) constant returns (uint8)
    {
    	//uint index = col * 33 + row;
    	return elevations[uint(col) * 33 + uint(row)];
    }
    
    function initElevations(uint8 col, uint8[33] _elevations) public 
    {
    	if(locked) // lockout
    		return;
    	uint skip = (uint(col) * 33); // e.g. if row 2, start with element 66
    	uint counter = 0;
    	while(counter < 33)
    	{
    		elevations[counter+skip] = _elevations[counter];
    		counter++;
    	}	
    }

    /***
     *    ______ _     _____ _____  _   _______ ___________ _____ 
     *    | ___ \ |   |  _  /  __ \| | / /  _  \  ___|  ___/  ___|
     *    | |_/ / |   | | | | /  \/| |/ /| | | | |__ | |_  \ `--. 
     *    | ___ \ |   | | | | |    |    \| | | |  __||  _|  `--. \
     *    | |_/ / |___\ \_/ / \__/\| |\  \ |/ /| |___| |   /\__/ /
     *    \____/\_____/\___/ \____/\_| \_/___/ \____/\_|   \____/ 
     *                                                            
     *                                                            
     */
    
    function getOccupies(uint8 which) public constant returns (int8[24])
    {
    	return blockdefs[which].occupies;
    }
    
    function getAttachesto(uint8 which) public constant returns (int8[48])
    {
    	return blockdefs[which].attachesto;
    }

    function initOccupies(uint8 which, int8[3][8] occupies) public 
    {
    	if(locked) // lockout
    		return;
    	uint counter = 0;
    	for(uint8 index = 0; index < 8; index++)
    	{
    		for(uint8 subindex = 0; subindex < 3; subindex++)
        	{
    			blockdefs[which].occupies[counter] = occupies[index][subindex];
    			counter++;
        	}
    	}	
    }
    
    function initAttachesto(uint8 which, int8[3][16] attachesto) public
    {
    	if(locked) // lockout
    		return;
    	uint counter = 0;
    	for(uint8 index = 0; index <  16; index++)
    	{
    		for(uint8 subindex = 0; subindex < 3; subindex++)
        	{
    			blockdefs[which].attachesto[counter] = attachesto[index][subindex];
    			counter++;
        	}
    	}	
    }
    
    /***
     *     _   _ _____ _____ _     _____ _______   __
     *    | | | |_   _|_   _| |   |_   _|_   _\ \ / /
     *    | | | | | |   | | | |     | |   | |  \ V / 
     *    | | | | | |   | | | |     | |   | |   \ /  
     *    | |_| | | |  _| |_| |_____| |_  | |   | |  
     *     \___/  \_/  \___/\_____/\___/  \_/   \_/  
     *                                               
     *                                               
     */
    
    function getRandomLandTile() public constant returns (uint8[2]) //TODO make public
    {
    	uint8[2] memory randomcolrow; // starts as [0,0]
    	uint8 counter = 0;
    	bytes32 lastblockhash = block.blockhash(block.number - 1);
    	while(mer.getElevation(randomcolrow[0], randomcolrow[1]) < 125 && counter < 32)
    	{
    		randomcolrow[counter] = getUint8FromByte32(lastblockhash,counter) % 32;										// this only gets 0-32, but it's ok because the top row and right column are just water anyway.
    		randomcolrow[counter+1] = getUint8FromByte32(lastblockhash,counter+1) % 32;	// this only gets 0-32, but it's ok because the top row and right column are just water anyway.
    		counter+=2;
    	}
    	// land tiles make up roughly half the map. The chance of getting water tiles 16 times in row is 1 / 2^16 = 1 in 65,636. If that ever happens, just return the center tile
    	if(counter == 32)
    	{
    		randomcolrow[0] = (mapsize - 1) / 2;
    		randomcolrow[1] = (mapsize - 1) / 2;
    		return randomcolrow;
    	}	
    }
    
    // this logic COULD be reduced a little, but the gain is minimal and readability suffers
    function blockHexCoordsValid(int8 x, int8 y) public constant returns (bool)
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
    	
    	if(absy <= 33) // middle rectangle
    	{
    		if(y % 2 != 0 ) // odd
    		{
    			if(-50 <= x && x <= 49)
    				return true;
    		}
    		else // even
    		{
    			if(absx <= 49)
    				return true;
    		}	
    	}	
    	else
    	{	
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
    
    // This function is handy for getting random numbers from 0-255 without getting a new hash every time. 
    // With one bytes32, there are 32 of these available, depending on the index
    function getUint8FromByte32(bytes32 _b32, uint8 byteindex) public constant returns(uint8) {
    	uint numdigits = 64;
    	uint base = 16;
    	uint digitsperbyte = 2;
    	uint buint = uint(_b32);
    	//uint upperpowervar = 16 ** (numdigits - (byteindex*2)); 		// @i=0 upperpowervar=16**64 (SEE EXCEPTION BELOW), @i=1 upperpowervar=16**62, @i upperpowervar=16**60
    	uint lowerpowervar = base ** (numdigits - digitsperbyte - (byteindex*digitsperbyte));		// @i=0 upperpowervar=16**62, @i=1 upperpowervar=16**60, @i upperpowervar=16**58
    	uint postheadchop;
    	if(byteindex == 0)
    		postheadchop = buint; 										//for byteindex 0, buint is just the input number. 16^64 is out of uint range, so this exception has to be made.
    	else
    		postheadchop = buint % (base ** (numdigits - (byteindex*digitsperbyte))); // @i=0 _b32=a1b2c3d4... postheadchop=a1b2c3d4, @i=1 postheadchop=b2c3d4, @i=2 postheadchop=c3d4
    	return uint8((postheadchop - (postheadchop % lowerpowervar)) / lowerpowervar);
    }
    
    
    
    
    /**********
    Standard lock-kill methods 
    **********/
    bool locked;
    function setLocked() public
    {
 	   locked = true;
    }
    function getLocked() public constant returns (bool)
    {
 	   return locked;
    }
    function kill()
    { 
        if (!locked && msg.sender == creator)
            suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}

// Solidity version: 0.1.6-d41f8b7c/.-Emscripten/clang/int linked to libethereum-

// 6060604052610408806100126000396000f3606060405236156100565760e060020a60003504630878bc51811461005857806310c1952f146100ce5780631256c698146100e05780631bcf57581461013e5780632d49ffcd146101d1578063d7f3b73b146101e9575b005b610247600435610600604051908101604052806030905b600081526020019060019003908161006f5750600190508260208110156100025760408051610600810191829052600392909202600201805460000b8352919260309190839060208601808411610196579050505050505090506101cc565b6100566000805460ff19166001179055565b60408051610100810190915261005690600480359161032490602460086000835b8282101561026157604080516060818101909252908381028601906003908390839080828437820191505050505081526020019060010190610101565b610281600435610300604051908101604052806018905b600081526020019060019003908161015557506001905082602081101561000257604080516103008101918290529260039290920290910190601890826000855b825461010083900a900460000b815260206001928301818104948501949093039092029101808411610196579050505050505090505b919050565b60005460ff1660408051918252519081900360200190f35b60408051610200810190915261005690600480359161062490602460106000835b8282101561029b5760408051606081810190925290838102860190600390839083908082843782019150505050508152602001906001019061020a565b60405180826106008083818460006004609ff15093505050f35b5092945050505050600080548190819060ff16156102b8575b5050505050565b604051808261030080838184600060046057f15093505050f35b5092945050505050600080548190819060ff161561035e5761027a565b60009250600091505b60088260ff16101561027a575060005b60038160ff16101561035257838260088110156100025760200201518160038110156100025790906020020151600160005086602081101561000257600302018460188110156100025760208082049092019190066101000a81548160ff021916908360f860020a90810204021790555082806001019350506001016102d1565b600191909101906102c1565b60009250600091505b60108260ff16101561027a575060005b60038160ff1610156103fc5783826010811015610002576020020151816003811015610002579090602002015160016000508660208110156100025760030260020190508460308110156100025760208082049092019190066101000a81548160ff021916908360f860020a9081020402179055508280600101935050600101610377565b6001919091019061036756

// [{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getAttachesto","outputs":[{"name":"","type":"int8[48]"}],"type":"function"},{"constant":false,"inputs":[],"name":"setLocked","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"occupies","type":"int8[3][8]"}],"name":"initOccupies","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupies","outputs":[{"name":"","type":"int8[24]"}],"type":"function"},{"constant":true,"inputs":[],"name":"getLocked","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"attachesto","type":"int8[3][16]"}],"name":"initAttachesto","outputs":[],"type":"function"}]

// var blockdefstorageContract = web3.eth.contract([{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getAttachesto","outputs":[{"name":"","type":"int8[48]"}],"type":"function"},{"constant":false,"inputs":[],"name":"setLocked","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"occupies","type":"int8[3][8]"}],"name":"initOccupies","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"which","type":"uint8"}],"name":"getOccupies","outputs":[{"name":"","type":"int8[24]"}],"type":"function"},{"constant":true,"inputs":[],"name":"getLocked","outputs":[{"name":"","type":"bool"}],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"attachesto","type":"int8[3][16]"}],"name":"initAttachesto","outputs":[],"type":"function"}]);
// var blockdefstorage = blockdefstorageContract.new(
//		   {
//		     from: web3.eth.accounts[0], 
//		     data: '6060604052610408806100126000396000f3606060405236156100565760e060020a60003504630878bc51811461005857806310c1952f146100ce5780631256c698146100e05780631bcf57581461013e5780632d49ffcd146101d1578063d7f3b73b146101e9575b005b610247600435610600604051908101604052806030905b600081526020019060019003908161006f5750600190508260208110156100025760408051610600810191829052600392909202600201805460000b8352919260309190839060208601808411610196579050505050505090506101cc565b6100566000805460ff19166001179055565b60408051610100810190915261005690600480359161032490602460086000835b8282101561026157604080516060818101909252908381028601906003908390839080828437820191505050505081526020019060010190610101565b610281600435610300604051908101604052806018905b600081526020019060019003908161015557506001905082602081101561000257604080516103008101918290529260039290920290910190601890826000855b825461010083900a900460000b815260206001928301818104948501949093039092029101808411610196579050505050505090505b919050565b60005460ff1660408051918252519081900360200190f35b60408051610200810190915261005690600480359161062490602460106000835b8282101561029b5760408051606081810190925290838102860190600390839083908082843782019150505050508152602001906001019061020a565b60405180826106008083818460006004609ff15093505050f35b5092945050505050600080548190819060ff16156102b8575b5050505050565b604051808261030080838184600060046057f15093505050f35b5092945050505050600080548190819060ff161561035e5761027a565b60009250600091505b60088260ff16101561027a575060005b60038160ff16101561035257838260088110156100025760200201518160038110156100025790906020020151600160005086602081101561000257600302018460188110156100025760208082049092019190066101000a81548160ff021916908360f860020a90810204021790555082806001019350506001016102d1565b600191909101906102c1565b60009250600091505b60108260ff16101561027a575060005b60038160ff1610156103fc5783826010811015610002576020020151816003811015610002579090602002015160016000508660208110156100025760030260020190508460308110156100025760208082049092019190066101000a81548160ff021916908360f860020a9081020402179055508280600101935050600101610377565b6001919091019061036756', 
//		     gas: 3000000
//		   }, function(e, contract){
//		    if (typeof contract.address != 'undefined') {
//		         console.log(e, contract);
//		         console.log('Contract mined! address: ' + contract.address + ' transactionHash: ' + contract.transactionHash);
//		    }
//		 })

// Contract mined! address: 0x782bdf7015b71b64f6750796dd087fde32fd6fdc transactionHash: 0x018ca5a3b948df4013b8c5552d281e4895d5ffefc1d244b2769ed12aea720f4e
