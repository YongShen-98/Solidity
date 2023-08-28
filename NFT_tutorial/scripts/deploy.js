const { ethers } = require("hardhat")

async function main(){
  const CryptoCKGSB = await ethers.getContractFactory("CryptoCKGSB")
  const cryptoCKGSB = await CryptoCKGSB.deploy("CryptoCKGSB","CkGSB")

  await cryptoCKGSB.deployed()
  console.log('Contract successfully deployed to: '+ cryptoCKGSB.address)
  
//  const newItemId0 = await cryptoCKGSB.mint("https://ipfs.io/ipfs/QmeXy1SWUy9rzR5DqrxwNQYcEL2kp916weU71MZxGhQ3s9")
//  const newItemId1 = await cryptoCKGSB.mint("https://ipfs.io/ipfs/QmeXy1SWUy9rzR5DqrxwNQYcEL2kp916weU71MZxGhQ3s9")
//  const newItemId2 = await cryptoCKGSB.mint("https://ipfs.io/ipfs/QmeXy1SWUy9rzR5DqrxwNQYcEL2kp916weU71MZxGhQ3s9")
//  console.log("NFT successfully minted: "+newItemId0+newItemId1+newItemId2)
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
