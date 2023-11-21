import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Dragon", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]
        owner2 = accounts[1]

        let deployed = await deployments.run(['DiamondApp'])
        console.log(`Diamond deployed to ${deployed.Diamond.address}`);
        MinterFacet = await ethers.getContractAt('MinterFacet', deployed.Diamond.address);
        UpgradeFacet = await ethers.getContractAt('UpgradeFacet', deployed.Diamond.address);
        PolishFacet = await ethers.getContractAt('PolishFacet', deployed.Diamond.address);
        DragonStoneFacet = await ethers.getContractAt('DragonStoneFacet', deployed.Diamond.address);
        SettingsFacet = await ethers.getContractAt('SettingsFacet', deployed.Diamond.address);
        RegisterFacet = await ethers.getContractAt('RegisterFacet', deployed.Diamond.address);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
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


    it("should create tokens", async function () {
        await MinterFacet.createStone();
        await MinterFacet.createStone();
        await MinterFacet.createStone();
        await MinterFacet.createStone();
        await MinterFacet.createStone();
        await MinterFacet.createStone();
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

    it("should calculate my active page stats right", async function () {
        let page = await SymbolFacet.getPlayerStats(owner.address);
        console.log('STATS::::::::');
        console.log('STATS::::::::'); console.log('STATS::::::::'); console.log('STATS::::::::'); console.log('STATS::::::::'); console.log('STATS::::::::');
        console.log(page[1].toNumber());
    })

    it("should show URI", async function () {
        let uri = await NonFungibleFacet.tokenURI(1);
        console.log({ uri });
    })

    it("should show owner", async function () {
        let owner$ = await NonFungibleFacet.ownerOf(1);
        console.log(owner$);
        expect(owner$).to.eq(owner.address)
    })

    it("should show token ids of owner", async function () {
        let tokenIds = await NonFungibleFacet.tokenIdsOfOwner(owner.address);
        console.log({ tokenIds });
    })


    it("should show balanceOf", async function () {
        let balance$ = await NonFungibleFacet.balanceOf(owner.address);
        console.log(balance$);
        expect(balance$.toNumber()).to.eq(6)
    })

    it("should transfer to owner2", async function () {
        await NonFungibleFacet.transferFrom(owner.address, owner2.address, 1);
        let owner$ = await NonFungibleFacet.ownerOf(1);
        console.log(owner$);
        expect(owner$).to.eq(owner2.address)
    })

    it("should show balanceOf -1", async function () {
        let balance$ = await NonFungibleFacet.balanceOf(owner.address);
        console.log(balance$);
        expect(balance$.toNumber()).to.eq(5)
    })
    it("should show token ids of owner", async function () {
        let tokenIds = await NonFungibleFacet.tokenIdsOfOwner(owner.address);
        console.log({ tokenIds });
    })

    it("should delete equipped stone from owner1 symbols", async function () {
        let page = await SymbolFacet.getPage(owner.address, 1);
        console.log(`Page contains: ${page?.length + 1} stones`);
        console.log(`Equipped Stone Bonus Type Id:  ${page[0].BONUS[0].BONUS_TYPE}`);
        console.log(`Equipped Stone Bonus Stat Id:  ${page[0].BONUS[0].BONUS_STAT}`);
        console.log(`Equipped Stone Bonus Total Value:  ${page[0].BONUS[0].VALUE}`);
    })
})
