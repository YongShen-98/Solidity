// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const Vault = await hre.ethers.getContractFactory("Vault");
  const vault = await Vault.deploy("0x961d20e3b7F33E1D646b694FE857D94A5652948b");

  await vault.deployed();

  console.log("vault deployed: ", vault.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
