require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();


/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    sepolia: {
      url: process.env.INFURA_SEPOLIA_ENDPOINT,
      accounts: [process.env.PRIVATE_KEY],
    },
    goerli: {
        url: process.env.INFURA_GOERLI_ENDPOINT,
        accounts: [process.env.PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: "6TA2YZF2Z1I9W2SFI62B4V38FXCJW6NA33",
  },
};
