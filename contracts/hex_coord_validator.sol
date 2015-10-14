contract HexCoordValidator{
	
    //function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
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
}