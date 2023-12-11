import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers"
const deployments = hre.deployments


let owner, owner2, BossFacet, AdventureFacet, MerchantFacet, DailyFacet, TestFacet, CombineFacet, DragonStonePieces, DragonStoneGold, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        RegisterFacet = await ethers.getContractAt('RegisterFacet', deployed.Diamond.address);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
        MerchantFacet = await ethers.getContractAt('MerchantFacet', deployed.Diamond.address);
        AdventureFacet = await ethers.getContractAt('AdventureFacet', deployed.Diamond.address);
        BossFacet = await ethers.getContractAt('BossFacet', deployed.Diamond.address);

        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
        DragonStoneGold = await ethers.getContract('DragonStoneGold');
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

    it("should set boss", async function () {
        await TestFacet.setStatVal(owner.address, 8, 30);
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        await BossFacet.setBoss({
            HP: 50,
            GOLD_REWARD_PER_DMG: ethers.utils.parseEther('1'),
            PIECE_REWARD_PER_DMG: ethers.utils.parseEther('0.1'),
            BLESSING_REWARD_PER_DMG: ethers.utils.parseEther('0.03'),
            EXP_REWARD_PER_DMG: 1,
            DEF: 1,
            EXPIRES_AT: Math.floor(Date.now() / 1000) + (24 * 60 * 60),
            STARTS_AT: Math.floor(Date.now() / 1000) + 60,
            BASE_COOLDOWN: 60 * 15,
        });
    })

    it("should revert early", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        expect(BossFacet.attack()).to.revertedWith('BossFacet: too soon');
    })

    it("should attack", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        await time.increase(60)
        await BossFacet.attack();
    })

    it("should attack second time", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        await time.increase(60)
        await BossFacet.attack();
    })


    it("should revert with cooldown", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        expect(BossFacet.attack()).to.revertedWith('BossFacet: cooldown');
        await time.increase(60 * 15)
    })

    it("should revert boss dead", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        expect(BossFacet.attack()).to.revertedWith('BossFacet: boss is dead')
    })

    it("should fetch and claim rewards", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        const worldBossInventory = await BossFacet.worldBossInventory(owner.address);
        console.log(worldBossInventory);
        await BossFacet.claimBossRewards();

        console.log(`balance piece: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`balance gold: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
        console.log(`balance blessing: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`player exp: ${playerState.EXP}`);
    })

    it("boss", async function () {
        console.log(await BossFacet.boss());
    })


    it("should set boss again", async function () {
        /*
            uint HP;
            uint GOLD_REWARD_PER_DMG;
            uint PIECE_REWARD_PER_DMG;
            uint BLESSING_REWARD_PER_DMG;
            uint EXP_REWARD_PER_DMG;
            uint DEF;
            uint EXPIRES_AT;
            uint STARTS_AT;
            uint BASE_COOLDOWN;
         */
        await BossFacet.setBoss({
            HP: 50,
            GOLD_REWARD_PER_DMG: ethers.utils.parseEther('1'),
            PIECE_REWARD_PER_DMG: ethers.utils.parseEther('0.1'),
            BLESSING_REWARD_PER_DMG: ethers.utils.parseEther('0.03'),
            EXP_REWARD_PER_DMG: 1,
            DEF: 1,
            EXPIRES_AT: Math.floor(Date.now() / 1000) + (24 * 60 * 60),
            STARTS_AT: Math.floor(Date.now() / 1000) + 60,
            BASE_COOLDOWN: 60 * 15,
        });
    })

    it("should escape", async function () {
        await time.increase(24 * 60 * 60)
        expect(BossFacet.attack()).to.revertedWith('BossFacet: escaped')
    })
})