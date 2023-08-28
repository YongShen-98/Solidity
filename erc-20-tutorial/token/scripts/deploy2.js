// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const MountainToken = await hre.ethers.getContractFactory("MountainToken");
  const mountainToken = await MountainToken.deploy(100000000,50);

  await mountainToken.deployed();

  console.log("Mountain Token deployed: ", mountainToken.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
