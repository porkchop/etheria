/**
Etheria testing
**/

[{"constant":true,"inputs":[],"name":"getElevations","outputs":[{"name":"","type":"uint8[17][17]"}],"type":"function"},{"constant":false,"inputs":[],"name":"getWhatHappened","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":false,"inputs":[],"name":"kill","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"_b32","type":"bytes32"},{"name":"byteindex","type":"uint8"}],"name":"getUint8FromByte32","outputs":[{"name":"","type":"uint8"}],"type":"function"},{"constant":false,"inputs":[{"name":"which","type":"uint8"},{"name":"occupies","type":"int8[3][8]"},{"name":"surroundedby","type":"int8[3][]"}],"name":"initBlockDef","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"_i","type":"address"}],"name":"setInitializer","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"makeOffer","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"getOfferers","outputs":[{"name":"","type":"address[]"}],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"},{"name":"index","type":"uint256"},{"name":"block","type":"int8[5]"}],"name":"editBlock","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"farmTile","outputs":[],"type":"function"},{"constant":true,"inputs":[],"name":"getOwners","outputs":[{"name":"","type":"address[17][17]"}],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"},{"name":"i","type":"uint8"}],"name":"acceptOffer","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"},{"name":"i","type":"uint8"}],"name":"rejectOffer","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"getOffers","outputs":[{"name":"","type":"uint256[]"}],"type":"function"},{"constant":false,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"retractOffer","outputs":[],"type":"function"},{"constant":false,"inputs":[{"name":"row","type":"uint8"},{"name":"_elevations","type":"uint8[17]"}],"name":"initElevations","outputs":[],"type":"function"},{"constant":true,"inputs":[{"name":"col","type":"uint8"},{"name":"row","type":"uint8"}],"name":"getBlocks","outputs":[{"name":"","type":"int8[5][]"}],"type":"function"},{"inputs":[],"type":"constructor"}]
var etheria = web3.eth.contract(abi).at('0x8dc6fcaa59794e7e815bad3c9682fbb7d4b1561e');

// CHECK INITIALIZATION
etheria.getElevations(); // should be zeros
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000 (40 zeros)

//INITIALIZE WHOLE MAP AND TEST THAT IT CAN'T BE CHANGED AFTERWARDS
etheria.initElevations.sendTransaction(0,[116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(1,[116,156,130,102,131,96,128,103,125,145,141,105,118,103,136,119,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(2,[116,130,145,145,146,143,140,137,134,150,166,143,121,138,156,136,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(3,[116,96,145,149,161,192,152,140,143,144,152,154,123,155,138,109,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(4,[116,131,146,161,176,170,164,158,153,146,139,132,126,123,121,118,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(5,[116,157,135,177,170,170,140,169,162,174,150,126,132,138,140,101,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(6,[116,120,125,144,164,140,116,143,171,166,161,150,139,149,160,138,116],{from:eth.coinbase,gas:2000000});

etheria.initElevations.sendTransaction(7,[116,155,129,161,158,181,143,153,180,193,166,126,146,111,147,129,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(8,[116,125,134,143,153,162,171,180,190,180,171,162,153,143,134,125,116],{from:eth.coinbase,gas:2000000});

etheria.initElevations.sendTransaction(9,[116,88,113,141,137,118,146,187,180,195,178,191,157,113,117,106,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(10,[116,104,93,107,121,121,121,146,171,178,186,173,161,131,101,108,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(11,[116,104,97,103,105,91,121,152,162,173,173,148,165,125,122,92,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(12,[116,109,102,95,89,105,121,137,153,157,161,165,170,156,143,129,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(13,[116,132,107,115,95,112,120,115,143,190,173,143,156,122,131,97,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(14,[116,114,112,107,102,110,119,126,134,159,185,164,143,131,120,118,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(15,[116,95,114,121,109,120,117,149,125,155,150,167,129,112,118,133,116],{from:eth.coinbase,gas:2000000});
etheria.initElevations.sendTransaction(16,[116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116],{from:eth.coinbase,gas:2000000});
etheria.getElevations(); // are they all properly initialized?
//etheria.initElevations.sendTransaction(8,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],{from:eth.coinbase,gas:3000000}); // try to set middle row to 1 elevation
//etheria.getElevations(); // make sure it didn't work

// BUY A TILE
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000
etheria.makeOffer.sendTransaction(8,8,{from:eth.accounts[0],value:100000000000000000}); // should fail. Too low.
etheria.makeOffer.sendTransaction(0,0,{from:eth.accounts[0],value:1000000000000000000}); // should fail. Can't buy water tiles
web3.fromWei(eth.getBalance(eth.accounts[0])); 
web3.fromWei(eth.getBalance(eth.accounts[1])); 
etheria.makeOffer.sendTransaction(8,8,{from:eth.accounts[0],value:1000000000000000000}); // should succeed
etheria.makeOffer.sendTransaction(7,7,{from:eth.accounts[1],value:1000000000000000000}); // should succeed
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000 except 8,8 which should be 250000000000000000
web3.fromWei(eth.getBalance(etheria.address)); // should be zero, money is sent to creator
web3.fromWei(eth.getBalance(eth.accounts[0])); // should be + 1
web3.fromWei(eth.getBalance(eth.accounts[1])); // should be - 1

// FARM A TILE
etheria.getBlocks(8,8); // should be empty array
etheria.farmTile.sendTransaction(8,8,{from:eth.coinbase,gas:2000000}); // should generate some random blocks
etheria.getBlocks(8,8); // should be an array of length 7 * 10 = 70
etheria.farmTile.sendTransaction(8,8,{from:eth.coinbase,gas:2000000}); // should fail if it's been less than X blocks.
etheria.getBlocks(8,8); // should be an array of length 7 * 10 = 70

// INIT BLOCK DEFINITIONS
blockdefstorage.initOccupies.sendTransaction(0, [[0,0,0],[0,0,1],[0,0,2],[0,0,3],[0,0,4],[0,0,5],[0,0,6],[0,0,7]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(1, [[0,0,0],[0,1,0],[1,2,0],[1,3,0],[2,4,0],[2,5,0],[3,6,0],[3,7,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(2, [[0,0,0],[1,0,0],[2,0,0],[3,0,0],[4,0,0],[5,0,0],[6,0,0],[7,0,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(3, [[0,0,0],[-1,1,0],[-1,2,0],[-2,3,0],[-2,4,0],[-3,5,0],[-3,6,0],[-4,7,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(4, [[0,0,0],[1,0,0],[1,1,0],[2,1,0],[3,2,0],[4,2,0],[4,3,0],[5,3,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(5, [[0,0,0],[-1,0,0],[-2,1,0],[-3,1,0],[-3,2,0],[-4,2,0],[-5,3,0],[-6,3,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(6, [[0,0,0],[1,0,0],[0,0,1],[1,0,1],[0,0,2],[1,0,2],[0,0,3],[1,0,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(7, [[0,0,0],[0,1,0],[0,0,1],[0,1,1],[0,0,2],[0,1,2],[0,0,3],[0,1,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(8, [[0,0,0],[-1,1,0],[0,0,1],[-1,1,1],[0,0,2],[-1,1,2],[0,0,3],[-1,1,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(9, [[0,0,0],[0,1,0],[1,2,0],[1,3,0],[0,0,1],[0,1,1],[1,2,1],[1,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(10, [[0,0,0],[1,0,0],[2,0,0],[3,0,0],[0,0,1],[1,0,1],[2,0,1],[3,0,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(11, [[0,0,0],[-1,1,0],[-1,2,0],[-2,3,0],[0,0,1],[-1,1,1],[-1,2,1],[-2,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(12, [[0,0,0],[1,0,0],[1,1,0],[2,1,0],[0,0,1],[1,0,1],[1,1,1],[2,1,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(13, [[0,0,0],[-1,0,0],[-2,1,0],[-3,1,0],[0,0,1],[-1,0,1],[-2,1,1],[-3,1,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(14, [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[0,4,0],[0,5,0],[0,6,0],[0,7,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(15, [[0,0,0],[-1,1,0],[0,2,0],[-1,3,0],[0,4,0],[-1,5,0],[0,6,0],[-1,7,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(16, [[0,0,0],[0,1,0],[0,2,0],[0,3,0],[0,0,1],[0,1,1],[0,2,1],[0,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(17, [[0,0,0],[-1,1,0],[0,2,0],[-1,3,0],[0,0,1],[-1,1,1],[0,2,1],[-1,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(18, [[0,0,0],[0,1,0],[0,1,1],[1,2,1],[1,2,2],[1,3,2],[1,3,3],[2,4,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(19, [[0,0,0],[1,0,0],[1,0,1],[2,0,1],[2,0,2],[3,0,2],[3,0,3],[4,0,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(20, [[0,0,0],[0,-1,0],[0,-1,1],[1,-2,1],[1,-2,2],[1,-3,2],[1,-3,3],[2,-4,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(21, [[0,0,0],[-1,-1,0],[-1,-1,1],[-1,-2,1],[-1,-2,2],[-2,-3,2],[-2,-3,3],[-2,-4,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(22, [[0,0,0],[-1,0,0],[-1,0,1],[-2,0,1],[-2,0,2],[-3,0,2],[-3,0,3],[-4,0,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(23, [[0,0,0],[-1,1,0],[-1,1,1],[-1,2,1],[-1,2,2],[-2,3,2],[-2,3,3],[-2,4,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(24, [[0,0,0],[0,0,1],[0,0,2],[0,1,2],[1,2,2],[1,3,2],[1,3,1],[1,3,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(25, [[0,0,0],[0,0,1],[0,0,2],[1,0,2],[2,0,2],[3,0,2],[3,0,1],[3,0,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(26, [[0,0,0],[0,0,1],[0,0,2],[0,-1,2],[1,-2,2],[1,-3,2],[1,-3,1],[1,-3,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(27, [[0,0,0],[0,0,1],[0,0,2],[1,0,2],[1,1,2],[1,2,2],[1,2,1],[1,2,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(28, [[0,0,0],[0,0,1],[0,0,2],[-1,-1,2],[0,-2,2],[1,-2,2],[1,-2,1],[1,-2,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(29, [[0,0,0],[0,0,1],[0,0,2],[-1,0,2],[-2,-1,2],[-1,-2,2],[-1,-2,1],[-1,-2,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(30, [[0,0,0],[0,0,1],[0,0,2],[0,1,2],[0,2,2],[-1,2,2],[-1,2,1],[-1,2,0]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initOccupies.sendTransaction(31, [[0,0,0],[0,0,1],[0,0,2],[0,0,3],[0,0,4],[-1,1,0],[-1,-1,0],[1,0,0]],{from:eth.coinbase, gas:3000000});

blockdefstorage.initAttachesto.sendTransaction(0, [[0,0,-1],[0,0,8]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(1, [[0,0,-1],[0,1,-1],[1,2,-1],[1,3,-1],[2,4,-1],[2,5,-1],[3,6,-1],[3,7,-1],[0,0,1],[0,1,1],[1,2,1],[1,3,1],[2,4,1],[2,5,1],[3,6,1],[3,7,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(2, [[0,0,-1],[1,0,-1],[2,0,-1],[3,0,-1],[4,0,-1],[5,0,-1],[6,0,-1],[7,0,-1],[0,0,1],[1,0,1],[2,0,1],[3,0,1],[4,0,1],[5,0,1],[6,0,1],[7,0,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(3, [[0,0,-1],[-1,1,-1],[-1,2,-1],[-2,3,-1],[-2,4,-1],[-3,5,-1],[-3,6,-1],[-4,7,-1],[0,0,1],[-1,1,1],[-1,2,1],[-2,3,1],[-2,4,1],[-3,5,1],[-3,6,1],[-4,7,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(4, [[0,0,-1],[1,0,-1],[1,1,-1],[2,1,-1],[3,2,-1],[4,2,-1],[4,3,-1],[5,3,-1],[0,0,1],[1,0,1],[1,1,1],[2,1,1],[3,2,1],[4,2,1],[4,3,1],[5,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(5, [[0,0,-1],[-1,0,-1],[-2,1,-1],[-3,1,-1],[-3,2,-1],[-4,2,-1],[-5,3,-1],[-6,3,-1],[0,0,1],[-1,0,1],[-2,1,1],[-3,1,1],[-3,2,1],[-4,2,1],[-5,3,1],[-6,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(6, [[0,0,-1],[1,0,-1],[0,0,4],[1,0,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(7, [[0,0,-1],[0,1,-1],[0,0,4],[0,1,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(8, [[0,0,-1],[-1,1,-1],[0,0,4],[-1,1,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(9, [[0,0,-1],[0,1,-1],[1,2,-1],[1,3,-1],[0,0,2],[0,1,2],[1,2,2],[1,3,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(10, [[0,0,-1],[1,0,-1],[2,0,-1],[3,0,-1],[0,0,2],[1,0,2],[2,0,2],[3,0,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(11, [[0,0,-1],[-1,1,-1],[-1,2,-1],[-2,3,-1],[0,0,2],[-1,1,2],[-1,2,2],[-2,3,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(12, [[0,0,-1],[1,0,-1],[1,1,-1],[2,1,-1],[0,0,2],[1,0,2],[1,1,2],[2,1,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(13, [[0,0,-1],[-1,0,-1],[-2,1,-1],[-3,1,-1],[0,0,2],[-1,0,2],[-2,1,2],[-3,1,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(14, [[0,0,-1],[0,1,-1],[0,2,-1],[0,3,-1],[0,4,-1],[0,5,-1],[0,6,-1],[0,7,-1],[0,0,1],[0,1,1],[0,2,1],[0,3,1],[0,4,1],[0,5,1],[0,6,1],[0,7,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(15, [[0,0,-1],[-1,1,-1],[0,2,-1],[-1,3,-1],[0,4,-1],[-1,5,-1],[0,6,-1],[-1,7,-1],[0,0,1],[-1,1,1],[0,2,1],[-1,3,1],[0,4,1],[-1,5,1],[0,6,1],[-1,7,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(16, [[0,0,-1],[0,1,-1],[0,2,-1],[0,3,-1],[0,0,2],[0,1,2],[0,2,2],[0,3,2]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(17, [[0,0,-1],[-1,1,-1],[0,2,-1],[-1,3,-1],[0,0,2],[-1,1,2],[0,2,2],[-1,3,1]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(18, [[0,0,-1],[0,1,-1],[1,2,0],[1,3,1],[2,4,2],[0,0,1],[0,1,2],[1,2,3],[1,3,4],[2,4,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(19, [[0,0,-1],[1,0,-1],[2,0,0],[3,0,1],[4,0,2],[0,0,1],[1,0,2],[2,0,3],[3,0,4],[4,0,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(20, [[0,0,-1],[0,-1,-1],[1,-2,0],[1,-3,1],[2,-4,2],[0,0,1],[0,-1,2],[1,-2,3],[1,-3,4],[2,-4,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(21, [[0,0,-1],[-1,-1,-1],[-1,-2,0],[-2,-3,1],[-2,-4,2],[0,0,1],[-1,-1,2],[-1,-2,3],[-2,-3,4],[-2,-4,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(22, [[0,0,-1],[-1,0,-1],[-2,0,0],[-3,0,1],[-4,0,2],[0,0,1],[-1,0,2],[-2,0,3],[-3,0,4],[-4,0,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(23, [[0,0,-1],[-1,1,-1],[-1,2,0],[-2,3,1],[-2,4,2],[0,0,1],[-1,1,2],[-1,2,3],[-2,3,4],[-2,4,4]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(24, [[0,0,-1],[0,1,1],[1,2,1],[1,3,-1],[0,0,3],[0,1,3],[1,2,3],[1,3,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(25, [[0,0,-1],[1,0,1],[2,0,1],[3,0,-1],[0,0,3],[1,0,3],[2,0,3],[3,0,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(26, [[0,0,-1],[0,-1,1],[1,-2,1],[1,-3,-1],[0,0,3],[0,-1,3],[1,-2,3],[1,-3,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(27, [[0,0,-1],[1,0,1],[1,1,1],[1,2,-1],[0,0,3],[1,0,3],[1,1,3],[1,2,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(28, [[0,0,-1],[-1,-1,1],[0,-2,1],[1,-2,-1],[0,0,3],[-1,-1,3],[0,-2,3],[1,-2,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(29, [[0,0,-1],[-1,0,1],[-2,-1,1],[-1,-2,-1],[0,0,3],[-1,0,3],[-2,-1,3],[-1,-2,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(30, [[0,0,-1],[0,1,1],[0,2,1],[-1,2,-1],[0,0,3],[0,1,3],[0,2,3],[-1,2,3]],{from:eth.coinbase, gas:3000000});
blockdefstorage.initAttachesto.sendTransaction(31, [[0,0,-1],[-1,1,-1],[-1,-1,-1],[1,0,-1],[0,0,5],[-1,1,1],[-1,-1,1],[1,0,1]],{from:eth.coinbase, gas:3000000});

// EDIT blocks
etheria.editBlock.sendTransaction(8,8,0,[0,1,2,3,40], {from:eth.coinbase,gas:2900000});
etheria.getBlocks(8,8); // should show the edited block

// MAKE A VALID OFFER ON AN OWNED TILE
etheria.makeOffer.sendTransaction(8,8, {from:eth.accounts[1],gas:3000000,value:10000000000000000});
etheria.getOfferers(8,8);
etheria.getOffers(8,8);
etheria.makeOffer.sendTransaction(8,8, {from:eth.accounts[1],gas:3000000,value:20000000000000000}); // second offer should update the offer value

// RETRACT OFFER
etheria.retractOffer.sendTransaction(8,8, {from:eth.accounts[1],gas:3000000});

// REJECT OFFER
etheria.rejectOffer.sendTransaction(8,8,0, {from:eth.coinbase,gas:3000000});

// ACCEPT OFFER
etheria.acceptOffer.sendTransaction(8,8,0, {from:eth.accounts[0],gas:3000000});

// MAKE SOME INVALID OFFERS
etheria.makeOffer.sendTransaction(8,8, {from:eth.accounts[1],gas:3000000,value:3000000}); // too low 
etheria.makeOffer.sendTransaction(8,8, {from:eth.accounts[1],gas:3000000,value:12089258196146291747061750}); // too high 

// GET OFFERS FOR THAT TILE
etheria.getOffers(8,8);

// MAKE AN OFFER ON AN UNOWNED TILE (SHOULD FAIL AND RETURN MONEY)
etheria.makeOffer.sendTransaction(2,2, 200000000000000000, {from:eth.coinbase,gas:3000000});

//GET OFFERS FOR THAT TILE
etheria.getOffers(2,2);

// GET OFFERS FOR A TILE

// KILL CONTRACT. DOES IT RETURN VALUE?

