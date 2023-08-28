const hre = require("hardhat");

async function main() {
  console.log("deploying...");
  const MarketInteractions = await hre.ethers.getContractFactory("MarketInteractions");
  const marketInteractions = await MarketInteractions.deploy("0x0496275d34753A48320CA58103d5220d394FF77F")

  await marketInteractions.deployed();

  console.log(
    "MarketInteractions loan contract deployed: ",
    marketInteractions.address
  )

}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
