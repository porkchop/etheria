contract HexCoordValidator {
	
    function HexCoordValidator() {
    	creator = msg.sender;
    }
    
    //function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
    function (int8 x, int8 y) constant returns (bool)
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
}