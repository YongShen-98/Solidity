const hre = require("hardhat");
//领OTC 的水龙头
async function main() {
  const Faucet = await hre.ethers.getContractFactory("Faucet");
  const faucet = await Faucet.deploy("0x961d20e3b7F33E1D646b694FE857D94A5652948b");

  await faucet.deployed();

  console.log("Facuet contract deployed: ", faucet.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});