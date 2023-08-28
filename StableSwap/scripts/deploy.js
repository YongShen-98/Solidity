const hre = require("hardhat");

async function main() {
  const StableSwap = await hre.ethers.getContractFactory("StableSwap");
  const stableSwap = await StableSwap.deploy();

  await stableSwap.deployed();

  console.log("StableSwap contract deployed: ", stableSwap.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});