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
	 function EtheriaBlocks() {
	    	owner = msg.sender;
	    }
	
	    Block[20] blocks;
	    bool allblocksinitialized;
	    bool[20] blocksinitialized;
	    
	    struct Block
	    {
	    	uint8 which;
	    	string description;	
	    	int8[3][8] occ; // [x,y,z] 8 times
	    	uint8 numsb; 
	    	int8[3][16] sb; // [x,y,z] 16 times
	    }
	    
	   
	    
	    function initializeBlockDefinition(uint8 which, string desc, int8[24] occupies, int8[] surroundedby)
	    {
	    	if(allblocksinitialized)
	    		return;
	    	else
	    	{
	    		blocks[which].which = which;
	        	blocks[which].description = desc;
	        	for(uint8 o = 0; o < 8; o++)
	        	{	
	        		for(uint8 i = 0; i < 3; i++)
	        		{
	        			blocks[which].occ[o][i] = occupies[o*3+i]; // counts from 0-23
	        		
	        		}
	        	}
	        	for(uint8 oo = 0; oo < (surroundedby.length/3); oo++)
	        	{	
	        		for(uint8 ii = 0; ii < 3; ii++)
	        		{
	        			blocks[which].sb[oo][ii] = surroundedby[oo*3+ii]; // counts from 0-? (up to 16*3)
	        		}
	        	}
	        	
	        	blocksinitialized[which] = true;
	        	for(uint b = 0; b < 20; b++)
	        	{
	        		if(blocksinitialized[b] == false) // at least one row is not yet initialized. Return.
	        			return;
	        	}	
	        	allblocksinitialized = true;
	    	}	
	    }
	    
	    function getDescription(uint8 which) constant returns (string)
	    {
	    	return blocks[which].description;
	    }
	    
	    function getOccupies(uint8 which) constant returns (int8[3][8])
	    {
	    	return blocks[which].occupies;
	    }
	    
	    function getSurroundedBy(uint8 which) constant returns (int8[3][16])
	    {
	    	return blocks[which].surroundedby;
	    }
    
    /**********
    Standard kill() function to recover funds 
    **********/
   
    function kill()
    { 
    	if (msg.sender == creator)
    		suicide(creator);  // kills this contract and sends remaining funds back to creator
    }
}