import { expect } from "chai";
import hre, { ethers } from "hardhat"
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
        await RegisterFacet.registerAccount();
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("1", "Not right")
    })

    it("should create 1000 piece", async function () {
        await MinterFacet.mintPiece();
    })

    it("should swap piece into blessing", async function () {
        const adventures = await AdventureFacet.getAllMaps();

        for (let i = 0; i < adventures.length; i++) {
            const map = adventures[i]
            const BASE_CYCLE = Math.floor(map.BASE_CYCLE / 60 / 60);
            console.log(`
$ ____________________________________ $
        MAP ID: ${i + 1} .
            REQUIRED_LEVEL: ${map.MIN_LEVEL} .
            MAP CYCLE: ${BASE_CYCLE} hours .
            +${map.EXP_PER_CYCLE} EXP every cycle .
            ${map.BASE_DROP_AMOUNT / 1e18} piece drops every ${BASE_CYCLE} hours .
            ${map.STONE_DROP_CHANCE}% chance to drop a dragon stone after minimum ${map.STONE_DROP_MIN_TIME / 60 / 60} hours .
            MAX ADVENTURE TIME IS ${BASE_CYCLE * map.MAX_CYCLE} hours .
            MAX EXP CLAIMABLE IS ${map.MAX_CYCLE * map.EXP_PER_CYCLE} .
            MAX PIECE CLAIMABLE IS ${map.MAX_CYCLE * map.BASE_DROP_AMOUNT / 1e18} .`);
        }
    })


})
