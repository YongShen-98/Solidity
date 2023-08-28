const hre = require("hardhat");

async function main() {
  const Sell = await hre.ethers.getContractFactory("sell");
  const sell = await Sell.deploy("0x961d20e3b7F33E1D646b694FE857D94A5652948b", "0x0285c4727C5903ccfbc42349AFd2Ce74B68FA98e", 0, 10);

  await sell.deployed();

  console.log("Sell contract deployed: ", sell.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});