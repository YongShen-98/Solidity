const hre = require("hardhat");
//领OTC 的水龙头
async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0xDE4C3Bd6a418343Fb7cC93480A41B64F00F884e0");

  await faucet.deployed();

  console.log("Facuet contract deployed: ", faucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});