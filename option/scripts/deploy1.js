const hre = require("hardhat");

async function main() {
  const CallOptionAut = await hre.ethers.getContractFactory("callOptionAut");
  const callOptionAut = await CallOptionAut.deploy();

  await callOptionAut.deployed();

  console.log("callOptionAut deployed: ", callOptionAut.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
