const { ethers, deployments } = require("hardhat")
const {moveBlocks} = require("../utils/move-blocks")
const {moveTime} = require("../utils/move-time")

const SECONDS_IN_DAY = 86400

describe("Staking Test", async function(){
    let staking, rewardToken, deployer, stakeAmount

    beforeEach(async function () {
        const accounts = await ethers.getSigners()
        deployer = accounts[0]
        await deployments.fixture(["all"])
        staking = await ethers.getContract("Staking")
        rewardToken = await ethers.getContract("RewardToken")
        stakeAmount = ethers.utils.parseEther("100000")
    })

    it("Allows users to stake and claim rewards", async function(){    
        await rewardToken.approve(staking.address, stakeAmount)
        await staking.stake(stakeAmount)
        const startingEarned = await staking.earned(deployer.address)
        console.log('Earned' +' '+ startingEarned)

        await moveTime(SECONDS_IN_DAY)
        await moveBlocks(1)

        const endingEarned = await staking.earned(deployer.address)
        console.log('Earned' +' '+ endingEarned)
    })
})