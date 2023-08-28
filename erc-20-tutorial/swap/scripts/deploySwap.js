const hre = require("hardhat");

async function main() {
  const CPAMM = await hre.ethers.getContractFactory("CPAMM");
  const cPAMM = await CPAMM.deploy("0x386EEF09D9a440Bc6CE5d104cD8Db671E17F27b1", "0x03Ae952C8320C65738b7B0F4d4E5f307801FEF56");

  await cPAMM.deployed();

  console.log("swap deployed: ", cPAMM.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});