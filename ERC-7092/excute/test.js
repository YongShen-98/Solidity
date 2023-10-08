const hre = require('hardhat');
require("dotenv").config();
async function main() {
    const provider = new hre.ethers.providers.JsonRpcProvider(process.env.INFURA_SEPOLIA_ENDPOINT);
    const privateKey =process.env.PRIVATE_KEY; 
    const wallet = new hre.ethers.Wallet(privateKey, provider);

    const contractAddress = '0xcb69627391FFC752df3CBD6420dE57b4355B7a06'; 
    const contractAbi = require('../ABI/ERC7092.json');

    const contract = new hre.ethers.Contract(contractAddress, contractAbi, wallet);

    const issueData = 
    [['0xA2d1B4919E62E6cA5475dDD5645E3bDf518Cf2e1',
    1000]]
    const bondInfo = ["A","A","A",
    "0x961d20e3b7F33E1D646b694FE857D94A5652948b",
    "0x961d20e3b7F33E1D646b694FE857D94A5652948b",
    18,1,1000,5,1,1,1696473108,1796474108,1]
    
    const tx = await contract.issue(issueData, bondInfo);
    const receipt = await tx.wait();
    console.log(receipt)
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
