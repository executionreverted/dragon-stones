import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers"
const deployments = hre.deployments

let owner, owner2, PrayerFacet, DailyFacet, IdlerFacet, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Dragon", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]
        owner2 = accounts[1]

        let deployed = await deployments.run(['DiamondApp'])
        console.log(`Diamond deployed to ${deployed.Diamond.address}`);
        CombineFacet = await ethers.getContractAt('CombineFacet', deployed.Diamond.address);
        MinterFacet = await ethers.getContractAt('MinterFacet', deployed.Diamond.address);
        UpgradeFacet = await ethers.getContractAt('UpgradeFacet', deployed.Diamond.address);
        PolishFacet = await ethers.getContractAt('PolishFacet', deployed.Diamond.address);
        DragonStoneFacet = await ethers.getContractAt('DragonStoneFacet', deployed.Diamond.address);
        SettingsFacet = await ethers.getContractAt('SettingsFacet', deployed.Diamond.address);
        RegisterFacet = await ethers.getContractAt('RegisterFacet', deployed.Diamond.address);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
        DailyFacet = await ethers.getContractAt('DailyFacet', deployed.Diamond.address);
        IdlerFacet = await ethers.getContractAt('IdlerFacet', deployed.Diamond.address);
        PrayerFacet = await ethers.getContractAt('PrayerFacet', deployed.Diamond.address);
        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
    })

    it("account should be disabled", async function () {
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("0", "Not right")
    })

    it("account should be enabled and page set to 1", async function () {
        await RegisterFacet.registerAccount();
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("1", "Not right")
    })

    it("should claim daily", async function () {
        let lastClaim = await DailyFacet.lastDailyClaim(owner.address)
        expect(lastClaim).to.eq(0)
        await DailyFacet.claimDaily()
        lastClaim = await DailyFacet.lastDailyClaim(owner.address)
        expect(lastClaim).to.gt(0)
        const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
        console.log({ pieceBalance });
        expect(pieceBalance.eq("10000000000000000000")).to.be.true
    })

    it("should enter idle", async function () {
        await IdlerFacet.beginIdleing()
        await time.increase(60 * 60)

        const rewards = await IdlerFacet.calculatePieceReward(owner.address)
        console.log({ rewards: `${`${rewards}` / 1e18}` });

        await IdlerFacet.endIdleing()

        const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
        console.log({ pieceBalance });
        expect(pieceBalance.eq("70000000000000000000")).to.be.true

        const tryEndAgain = IdlerFacet.endIdleing()
        await expect(tryEndAgain).to.be.revertedWith("IdlerFacet: not idle")
    })


    it("should enter praying", async function () {
        await PrayerFacet.beginPraying()
        await time.increase(60 * 20)

        const rewards = await PrayerFacet.calculatePrayerReward(owner.address)
        console.log({ rewards: `${`${rewards}` / 1e18}` });

        await PrayerFacet.endPraying()

        const blessingBalance = await DragonStoneBlessing.balanceOf(owner.address)
        console.log({ blessingBalance });
        expect(blessingBalance.eq("1000000000000000000")).to.be.true

        const tryEndAgain = PrayerFacet.endPraying()
        await expect(tryEndAgain).to.be.revertedWith("PrayerFacet: not praying")
    })

})
