const hre = require("hardhat");

async function main() {
  const BondOption = await hre.ethers.getContractFactory("ERC7092");
  const issuer = {
    name: 'CKGSB',
    email: 'yongshen0730@163.com',
    country: 'China',
    headquarters: 'Wuhan',
    issuerType: 'university',
    creditRating: 'A',
    //carbonCredit: 1000, // 替换为你的具体值
    issuerAddress: "0x1c8F73b05EB6EccE2f37415EA47a28867f17efe9"
};

  console.log("bondOption starts to deploy: ");
  const bondOption = await BondOption.deploy("001", issuer);

  await bondOption.deployed();

  console.log("bondOption deployed: ", bondOption.address);
}
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
