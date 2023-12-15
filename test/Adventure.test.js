import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers"
const deployments = hre.deployments


let owner, owner2, AdventureFacet, MerchantFacet, DailyFacet, TestFacet, CombineFacet, DragonStonePieces, DragonStoneGold, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        await RegisterFacet.registerAccount(1,1);
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("1", "Not right")
    })



    it("should fetch adventures", async function () {
        const adventures = await AdventureFacet.getAllMaps();

        //         for (let i = 0; i < adventures.length; i++) {
        //             const map = adventures[i]
        //             const BASE_CYCLE = Math.floor(map.BASE_CYCLE / 60 / 60);
        //             console.log(`
        // $ ____________________________________ $
        //         MAP ID: ${i + 1} .
        //             REQUIRED_LEVEL: ${map.MIN_LEVEL} .
        //             MAP CYCLE: ${BASE_CYCLE} hours .
        //             +${map.EXP_PER_CYCLE} EXP every cycle .
        //             ${map.BASE_DROP_AMOUNT / 1e18} piece drops every ${BASE_CYCLE} hours .
        //             ${map.STONE_DROP_CHANCE}% chance to drop a dragon stone after minimum ${map.STONE_DROP_MIN_TIME / 60 / 60} hours .
        //             MAX ADVENTURE TIME IS ${BASE_CYCLE * map.MAX_CYCLE} hours .
        //             MAX EXP CLAIMABLE IS ${map.MAX_CYCLE * map.EXP_PER_CYCLE} .
        //             MAX PIECE CLAIMABLE IS ${map.MAX_CYCLE * map.BASE_DROP_AMOUNT / 1e18} .`);
        //         }
    })
    it("should go in adventure", async function () {
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`LEVEL: ${playerState.LEVEL}`);
        console.log(`ACTION_STATE: ${playerState.ACTION_STATE}`);
        console.log(`ACTION_START: ${playerState.ACTION_START}`);
        console.log(`ACTION_DEADLINE: ${playerState.ACTION_DEADLINE}`);
        console.log(`ACTION_DATA1: ${playerState.ACTION_DATA1}`);

        await AdventureFacet.enterAdventure(1);

        playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`LEVEL: ${playerState.LEVEL}`);
        console.log(`ACTION_STATE: ${playerState.ACTION_STATE}`);
        console.log(`ACTION_START: ${playerState.ACTION_START}`);
        console.log(`ACTION_DEADLINE: ${playerState.ACTION_DEADLINE}`);
        console.log(`ACTION_DATA1: ${playerState.ACTION_DATA1}`);
    })

    it("should calculate 1 hour rewards right", async function () {
        await time.increase(60 * 60);
        const rewards = await AdventureFacet.calculateRewards(owner.address);
        console.log(`piece: ${rewards[0] / 1e18}`);
        console.log(`gold: ${rewards[1] / 1e18}`);
        console.log(`exp: ${rewards[2]}`);
    })


    it("should calculate 1 day rewards right", async function () {
        await time.increase(60 * 60 * 23);
        const rewards = await AdventureFacet.calculateRewards(owner.address);
        console.log(`piece: ${rewards[0] / 1e18}`);
        console.log(`gold: ${rewards[1] / 1e18}`);
        console.log(`exp: ${rewards[2]}`);
    })


    it("should calculate 2 day rewards right", async function () {
        await time.increase(60 * 60 * 24);
        const rewards = await AdventureFacet.calculateRewards(owner.address);
        console.log(`piece: ${rewards[0] / 1e18}`);
        console.log(`gold: ${rewards[1] / 1e18}`);
        console.log(`exp: ${rewards[2]}`);
        console.log(`first stone balance: ${await NonFungibleFacet.balanceOf(owner.address)}`);
    })


    it("should claim rewards leave adventure and right", async function () {
        const rewards = await AdventureFacet.leaveAdventure();
        console.log(`balance piece: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`balance gold: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`player exp: ${playerState.EXP}`);
        console.log(`action state: ${playerState.ACTION_STATE}`)
        console.log(`action time: ${playerState.ACTION_START}`)
        console.log(`action param: ${playerState.ACTION_DATA1}`)
        console.log(`stone balance: ${await NonFungibleFacet.balanceOf(owner.address)}`);
    })


    it("should go in adventure again", async function () {
        await AdventureFacet.enterAdventure(1);
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log('--- ADV 2 test for reenter');
        console.log(`LEVEL: ${playerState.LEVEL}`);
        console.log(`ACTION_STATE: ${playerState.ACTION_STATE}`);
        console.log(`ACTION_START: ${playerState.ACTION_START}`);
        console.log(`ACTION_DEADLINE: ${playerState.ACTION_DEADLINE}`);
        console.log(`ACTION_DATA1: ${playerState.ACTION_DATA1}`);
        console.log(`stone balance: ${await NonFungibleFacet.balanceOf(owner.address)}`);
    })

    it("should get 2 day rewards with reenter", async function () {
        await time.increase(60 * 60 * 48);
    })
    it("get rewards and keep in adventure after reenter", async function () {
        await AdventureFacet.reenterAdventure();
        console.log(`balance piece: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`balance gold: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`2 player exp: ${playerState.EXP}`);
        console.log(`2 action state: ${playerState.ACTION_STATE}`)
        console.log(`2 action time: ${playerState.ACTION_START}`)
        console.log(`2 action param: ${playerState.ACTION_DATA1}`)
        console.log(`2 stone balance: ${await NonFungibleFacet.balanceOf(owner.address)}`);
    })

    it("should get 2 day rewards with reenter", async function () {
        await time.increase(60 * 60 * 48);
        await AdventureFacet.reenterAdventure();
    })

    it("get rewards and keep in adventure after reenter", async function () {
        let playerState = await DragonStoneFacet.getPlayer(owner.address)
        console.log(`3 player level: ${playerState.LEVEL}`);
        console.log(`3 player exp: ${playerState.EXP}`);
        console.log(`3 action state: ${playerState.ACTION_STATE}`)
        console.log(`3 action time: ${playerState.ACTION_START}`)
        console.log(`3 action param: ${playerState.ACTION_DATA1}`)
        console.log(`3 stone balance: ${await NonFungibleFacet.balanceOf(owner.address)}`);
    })
})
