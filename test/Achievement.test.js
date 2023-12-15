import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers"
const deployments = hre.deployments


let owner, owner2, AchievementFacet, BossFacet, PremiumFacet, AdventureFacet, MerchantFacet, DailyFacet, TestFacet, CombineFacet, DragonStonePieces, DragonStoneGold, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Stats", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]
        owner2 = accounts[1]
        let deployed = await deployments.run(['DiamondApp'])
        console.log(`Diamond deployed to ${deployed.Diamond.address}`);
        CombineFacet = await ethers.getContractAt('CombineFacet', deployed.Diamond.address);
        DailyFacet = await ethers.getContractAt('DailyFacet', deployed.Diamond.address);
        TestFacet = await ethers.getContractAt('TestFacet', deployed.Diamond.address);
        MinterFacet = await ethers.getContractAt('MinterFacet', deployed.Diamond.address);
        UpgradeFacet = await ethers.getContractAt('UpgradeFacet', deployed.Diamond.address);
        PolishFacet = await ethers.getContractAt('PolishFacet', deployed.Diamond.address);
        DragonStoneFacet = await ethers.getContractAt('DragonStoneFacet', deployed.Diamond.address);
        SettingsFacet = await ethers.getContractAt('SettingsFacet', deployed.Diamond.address);
        RegisterFacet = await (await ethers.getContractAt('RegisterFacet', deployed.Diamond.address)).connect(owner2);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
        MerchantFacet = await ethers.getContractAt('MerchantFacet', deployed.Diamond.address);
        AdventureFacet = await ethers.getContractAt('AdventureFacet', deployed.Diamond.address);
        BossFacet = await ethers.getContractAt('BossFacet', deployed.Diamond.address);
        PremiumFacet = await ethers.getContractAt('PremiumFacet', deployed.Diamond.address);
        AchievementFacet = await (await ethers.getContractAt('AchievementFacet', deployed.Diamond.address)).connect(owner2);

        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
        DragonStoneGold = await ethers.getContract('DragonStoneGold');
    })
    let achs;
    it("should fetch all achievements", async function () {
        achs = await AchievementFacet.achievements();
    })

    it("set merchant trade count", async function () {
        await TestFacet.setMerchantDeal(owner2.address, 1000)
    })

    it("claim achievement 42", async function () {
        await RegisterFacet.registerAccount(1, 1);
        await AchievementFacet.claimAchievement(42)

        const pBal = await DragonStonePieces.balanceOf(owner2.address)
        const gBal = await DragonStoneGold.balanceOf(owner2.address)
        const bBal = await DragonStoneBlessing.balanceOf(owner2.address)
        expect(gBal.eq(achs[41].REWARD_AMOUNT_1)).to.be.true
        expect(pBal.eq(achs[41].REWARD_AMOUNT_2)).to.be.true
        expect(bBal.eq(achs[41].REWARD_AMOUNT_3)).to.be.true
    })

    it("set success counters ", async function () {
        await TestFacet.setSuccess(owner2.address, 1000)
    })

    it("claim achievement 7", async function () {
        await AchievementFacet.claimAchievement(7)

        const pBal = await DragonStonePieces.balanceOf(owner2.address)
        const gBal = await DragonStoneGold.balanceOf(owner2.address)
        const bBal = await DragonStoneBlessing.balanceOf(owner2.address)
        expect(gBal.eq(achs[41].REWARD_AMOUNT_1.add(achs[6].REWARD_AMOUNT_1))).to.be.true
        expect(pBal.eq(achs[41].REWARD_AMOUNT_2.add(achs[6].REWARD_AMOUNT_2))).to.be.true
        expect(bBal.eq(achs[41].REWARD_AMOUNT_3.add(achs[6].REWARD_AMOUNT_3))).to.be.true
    })

    it("shouldnt let claim again", async function () {
        await expect(AchievementFacet.claimAchievement(7)).to.be.revertedWith('AchievementFacet: already claimed')

        const pBal = await DragonStonePieces.balanceOf(owner2.address)
        const gBal = await DragonStoneGold.balanceOf(owner2.address)
        const bBal = await DragonStoneBlessing.balanceOf(owner2.address)
        expect(gBal.eq(achs[41].REWARD_AMOUNT_1.add(achs[6].REWARD_AMOUNT_1))).to.be.true
        expect(pBal.eq(achs[41].REWARD_AMOUNT_2.add(achs[6].REWARD_AMOUNT_2))).to.be.true
        expect(bBal.eq(achs[41].REWARD_AMOUNT_3.add(achs[6].REWARD_AMOUNT_3))).to.be.true

        console.log(`balances : ${gBal / 1e18}, ${pBal / 1e18}, ${bBal / 1e18}`);
    })
})