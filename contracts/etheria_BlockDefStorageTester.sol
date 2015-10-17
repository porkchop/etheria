import 'mortal';

contract BlockDefStorage
{
	function getOccupies(uint8 which) public returns (int8[24]);
	function getAttachesto(uint8 which) public returns (int8[48]);
}

contract BlockDefStorageTester is mortal
{
	BlockDefStorage bds;
	
    function BlockDefStorageTester() {
    	bds = BlockDefStorage(0x782bdf7015b71b64f6750796dd087fde32fd6fdc);
    }
    
    function getOccupiesFromBDS(uint8 which) public constant returns(int8[24])
    {
    	return bds.getOccupies(which);
    }
    
    function getAttachestoFromBDS(uint8 which) public constant returns(int8[48])
    {
    	return bds.getAttachesto(which);
    }
}