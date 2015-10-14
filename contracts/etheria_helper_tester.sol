import 'mortal';

contract EtheriaHelper is mortal ()
{
	function blockHexCoordsValid(int8 x, int8 y) constant returns (bool)
	{}
	function getUint8FromByte32(bytes32 _b32, uint8 byteindex) public constant returns(uint8) 
	{}
}

contract EtheriaHelperTester is EtheriaHelper{
	
	EtheriaHelper eh;
	
	function EtheriaHelperTester() 
	{
		eh = EtheriaHelper(0xf20c9fa34847f6bc42b2f60014268bec65676af7);
	}
	
    function blockHexCoordsValidRemote(int8 x, int8 y) constant returns (bool)
    {
    	return eh.blockHexCoordsValid(x, y);
    }
    
    function getUint8FromByte32Remote(bytes32 _b32, uint8 byteindex) constant returns (uint8)
    {
    	return eh.getUint8FromByte32(_b32,byteindex); // the 0 means first byte
    }
}