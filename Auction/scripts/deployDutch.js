// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const DutchAuction = await hre.ethers.getContractFactory("DutchAuction");
  const dutchAuction = await DutchAuction.deploy(6000, 1, '0x0285c4727C5903ccfbc42349AFd2Ce74B68FA98e', 1, '0x961d20e3b7F33E1D646b694FE857D94A5652948b');

  await dutchAuction.deployed();

  console.log("dutchAuction deployed: ", dutchAuction.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
