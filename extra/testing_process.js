/**
Etheria testing
**/

// CHECK INITIALIZATION
etheria.getElevations(); // should be zeros
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000 (40 zeros)

// INITIALIZE A ROW
etheria.initializeTiles.sendTransaction(8,[116,125,134,143,153,162,171,180,190,180,171,162,153,143,134,125,116],{from:eth.coinbase,gas:3000000});
etheria.getElevations(); // should be zeros except for middle row

// BUY A TILE
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000
etheria.buyTile.sendTransaction(8,8,{from:eth.coinbase,value:250000000000000000});
etheria.getOwners(); // should be all 0x0000000000000000000000000000000000000000 except 8,8 which should be 250000000000000000
etheria.getLiquidBalance(); // should be 250000000000000000
etheria.getIlliquidBalance(); // should be 0



// FARM A TILE
etheria.getBlocksForTile(8,8); // should be empty array
etheria.farmTile.sendTransaction(8,8,{from:eth.coinbase,gas:3000000});
etheria.getBlocksForTile(8,8); // should be an array of length 7 * 10 = 70

// EDIT A BLOCK
etheria.editBlock(8,8,2, [0,5,5,0,10,10,10],{from:eth.coinbase,gas:3000000});
etheria.getBlocksForTile(8,8); // should show the edited block



// INITIALIZE WHOLE MAP AND TEST THAT IT CAN'T BE CHANGED AFTERWARDS
etheria.initializeTiles.sendTransaction(0,[116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(1,[116,156,130,102,131,96,128,103,125,145,141,105,118,103,136,119,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(2,[116,130,145,145,146,143,140,137,134,150,166,143,121,138,156,136,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(3,[116,96,145,149,161,192,152,140,143,144,152,154,123,155,138,109,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(4,[116,131,146,161,176,170,164,158,153,146,139,132,126,123,121,118,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(5,[116,157,135,177,170,170,140,169,162,174,150,126,132,138,140,101,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(6,[116,120,125,144,164,140,116,143,171,166,161,150,139,149,160,138,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(7,[116,155,129,161,158,181,143,153,180,193,166,126,146,111,147,129,116],{from:eth.coinbase,gas:3000000});

etheria.initializeTiles.sendTransaction(8,[116,125,134,143,153,162,171,180,190,180,171,162,153,143,134,125,116],{from:eth.coinbase,gas:3000000});

etheria.initializeTiles.sendTransaction(9,[116,88,113,141,137,118,146,187,180,195,178,191,157,113,117,106,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(10,[116,104,93,107,121,121,121,146,171,178,186,173,161,131,101,108,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(11,[116,104,97,103,105,91,121,152,162,173,173,148,165,125,122,92,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(12,[116,109,102,95,89,105,121,137,153,157,161,165,170,156,143,129,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(13,[116,132,107,115,95,112,120,115,143,190,173,143,156,122,131,97,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(14,[116,114,112,107,102,110,119,126,134,159,185,164,143,131,120,118,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(15,[116,95,114,121,109,120,117,149,125,155,150,167,129,112,118,133,116],{from:eth.coinbase,gas:3000000});
etheria.initializeTiles.sendTransaction(16,[116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116,116],{from:eth.coinbase,gas:3000000});
etheria.getElevations(); // are they all properly initialized?
etheria.initializeTiles.sendTransaction(8,[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],{from:eth.coinbase,gas:3000000}); // try to set middle row to 1 elevation
etheria.getElevations(); // make sure it didn't work
