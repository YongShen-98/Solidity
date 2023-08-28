const hre = require("hardhat");

async function main() {
  const EnglishAuction = await hre.ethers.getContractFactory("EnglishAuction");
  const eutchAuction = await EnglishAuction.deploy("0x0285c4727C5903ccfbc42349AFd2Ce74B68FA98e", 2, 1000, '0x961d20e3b7F33E1D646b694FE857D94A5652948b');

  await eutchAuction.deployed();

  console.log("eutchAuction deployed: ", eutchAuction.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
