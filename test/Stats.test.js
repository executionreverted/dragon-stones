import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, DailyFacet, TestFacet, StatsFacet, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        StatsFacet = await ethers.getContractAt('StatsFacet', deployed.Diamond.address);
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

    it("should have 10 stat points at start", async function () {
        console.log(await StatsFacet.playerStatPoints(owner.address));
        expect(`${await StatsFacet.playerStatPoints(owner.address)}`).to.be.eq('10')
    })

    it("should give 10 stat points to STR", async function () {
        await StatsFacet.useStatPoint([0, 0, 0, 0, 0, 0, 0, 0, 0, 0]);
        expect(`${await StatsFacet.playerStatPoints(owner.address)}`).to.be.eq('0')
    })


    it("should have 10 STR", async function () {
        console.log(
            await SymbolFacet.getPlayerStats(owner.address)
        );
        const stats = await SymbolFacet.getPlayerStats(owner.address);
        expect(`${stats[1]}`).to.be.eq("10")
    })


    it("should have 10 DMG", async function () {
        console.log(
            await SymbolFacet.getPlayerStats(owner.address)
        );
        const stats = await SymbolFacet.getPlayerStats(owner.address);
        expect(`${stats[8]}`).to.be.eq("15")
    })


})
