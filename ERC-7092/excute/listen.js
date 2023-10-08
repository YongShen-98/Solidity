const hre = require('hardhat');
require("dotenv").config();
async function main() {
    const provider = new hre.ethers.providers.JsonRpcProvider(process.env.INFURA_SEPOLIA_ENDPOINT);
    const privateKey =process.env.PRIVATE_KEY; 
    const wallet = new hre.ethers.Wallet(privateKey, provider);

    const contractAddress = '0xcb69627391FFC752df3CBD6420dE57b4355B7a06'; 
    const contractAbi = require('../ABI/ERC7092.json');

    const contract = new hre.ethers.Contract(contractAddress, contractAbi, wallet);

    contract.on('BondIssued', (issueDataArray, bondObject, 
        event) => {
        console.log("BondIssued event received:");
        console.log("ISIN:", bondObject.isin);
        console.log("symbol:", bondObject.symbol);
        console.log("currency:", bondObject.currency);
        console.log("currencyOfCoupon:", bondObject.currencyOfCoupon);
        console.log("decimals:", bondObject.decimals);
        console.log("denominationIN:", bondObject.denomination);
        console.log("issueVolume:", bondObject.issueVolume);
        console.log("couponRate:", bondObject.couponRate);
        console.log("couponType:", bondObject.couponType);
        console.log("couponFrequency:", bondObject.couponFrequency);
        console.log("issueDate:", bondObject.issueDate);+
        console.log("maturityDate:", bondObject.maturityDate);
        console.log("dayCountBasis:", bondObject.dayCountBasis);
      })
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
