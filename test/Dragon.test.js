import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, NonFungibleFacet, DragonStoneFacet, TestingFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Dragon", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]

        let deployed = await deployments.run(['DiamondApp'])
        console.log(`Diamond deployed to ${deployed.Diamond.address}`);
        TestingFacet = await ethers.getContractAt('TestingFacet', deployed.Diamond.address);
        UpgradeFacet = await ethers.getContractAt('UpgradeFacet', deployed.Diamond.address);
        PolishFacet = await ethers.getContractAt('PolishFacet', deployed.Diamond.address);
        DragonStoneFacet = await ethers.getContractAt('DragonStoneFacet', deployed.Diamond.address);
        SettingsFacet = await ethers.getContractAt('SettingsFacet', deployed.Diamond.address);
        RegisterFacet = await ethers.getContractAt('RegisterFacet', deployed.Diamond.address);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
    })


    it("should create token", async function () {
        await TestingFacet.createStone(1);
    })

    it("should give right raw token", async function () {
        const raw = await DragonStoneFacet.getRawDragonStone(1);
        console.log(raw.TIER);
        console.log(raw.STONE_TYPE);
        console.log(raw.BONUS_IDS);
        console.log(raw.OWNER);
    })

    it("should give right dragon stone", async function () {
        const stone = await DragonStoneFacet.getDragonStone(1);
        console.log(stone.TIER);
        console.log(stone.STONE_TYPE);
        console.log('BONUS::____');
        console.log(stone.BONUS[0]);
        console.log(stone.OWNER);
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

    it("equip stone id 1 to ruby slot", async function () {
        await SymbolFacet.equipDragonStone(0, 1);
    })

    it("should show active stone right", async function () {
        let page = await SymbolFacet.getPage(owner.address, 1);
        console.log(`Page contains: ${page?.length + 1} stones`);
        console.log(page[0]);
        console.log(`Equipped Stone Bonus Type Id:  ${page[0].BONUS[0].BONUS_TYPE}`);
        console.log(`Equipped Stone Bonus Stat Id:  ${page[0].BONUS[0].BONUS_STAT}`);
        console.log(`Equipped Stone Bonus Total Value:  ${page[0].BONUS[0].VALUE}`);
    })

    it("should show URI", async function () {
        let uri = await NonFungibleFacet.tokenURI();
        console.log({uri});
    })
})
