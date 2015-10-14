import 'mortal';

contract HexCoordValidator is mortal ()
{
	function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
	{}
}

contract HexCoordValidatorValidator is HexCoordValidator{
	
	HexCoordValidator hcv;
	
	function HexCoordValidatorValidator() 
	{
		hcv = HexCoordValidator(0x18b84dfffa22fc3bf502cc46ac64d13306df4d41);
	}
	
    function blockHexCoordsValidRemote(int8 x, int8 y) constant returns (bool)
    {
    	bool result = hcv.blockHexCoordsValid(x, y);
    	return result;
    }
}