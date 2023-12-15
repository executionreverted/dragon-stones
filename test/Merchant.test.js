import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, MerchantFacet, DailyFacet, TestFacet, CombineFacet, DragonStonePieces, DragonStoneGold, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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

    it("should create 1000 piece", async function () {
        await MinterFacet.mintPiece();
        console.log(`Piece balance: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
    })

    it("should swap piece into blessing", async function () {
        await MerchantFacet.deal(1, 1)
        console.log(`Piece balance: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        console.log(`Gold balance: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
    })

    it("should swap blessing into piece", async function () {
        await MerchantFacet.deal(3, 1)
        console.log(`Piece balance: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        console.log(`Gold balance: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
    })

    it("should swap piece into blessing", async function () {
        await MerchantFacet.deal(1, 1)
        console.log(`Piece balance: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`);
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        console.log(`Gold balance: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
    })

    it("should swap blessing into gold", async function () {
        await MerchantFacet.deal(5, 1)
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        console.log(`Blessing balance: ${await DragonStoneBlessing.balanceOf(owner.address) / 1e18}`);
        console.log(`Gold balance: ${await DragonStoneGold.balanceOf(owner.address) / 1e18}`);
    })
})
