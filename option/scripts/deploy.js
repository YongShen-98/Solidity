const hre = require("hardhat");

async function main() {
  const CallOption = await hre.ethers.getContractFactory("callOption");
  const callOption = await CallOption.deploy();

  await callOption.deployed();

  console.log("callOption deployed: ", callOption.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

