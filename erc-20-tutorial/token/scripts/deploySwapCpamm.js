const hre = require("hardhat");

async function main() {
  const SwapCpamm = await hre.ethers.getContractFactory("SwapCpamm");
  const swapCpamm = await SwapCpamm.deploy("0x961d20e3b7F33E1D646b694FE857D94A5652948b", "0xDE4C3Bd6a418343Fb7cC93480A41B64F00F884e0");

  await swapCpamm.deployed();

  console.log("SwapCpamm deployed: ", swapCpamm.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});