import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers";
const deployments = hre.deployments


let owner, owner2, owner3, IdlerFacet, PremiumFacet, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Dragon", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]
        owner2 = accounts[1]
        owner3 = accounts[2]

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
        IdlerFacet = await ethers.getContractAt('IdlerFacet', deployed.Diamond.address);
        PremiumFacet = await ethers.getContractAt('PremiumFacet', deployed.Diamond.address);
        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
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

    it("account has no premium", async function () {
        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })

    it("begin idle", async function () {
        await IdlerFacet.beginIdleing()
        await time.increase(24 * 60 * 60)
        console.log(`will get ${await IdlerFacet.calculatePieceReward(owner.address) / 1e18} piece from idleing`);
    })

    it("account buys premium", async function () {
        await PremiumFacet.buyPremium(1, { value: ethers.utils.parseEther('1') })

        const data = await PremiumFacet.userPremiumStatus(owner.address)
    })

    it("should revert if no value", async function () {
        expect(PremiumFacet.buyPremium(1, { value: ethers.utils.parseEther('0.5') })).to.revertedWith('PremiumFacet: payment required')

        const data = await PremiumFacet.userPremiumStatus(owner.address)
    })

    it("should change price of premium", async function () {
        await PremiumFacet.setPremiumPrice(ethers.utils.parseEther('0.05'));
    })

    it("account buys premium", async function () {
        await PremiumFacet.buyPremium(1, { value: ethers.utils.parseEther('0.05') })

        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })

    it("begin idle", async function () {
        console.log(`with premium will get ${await IdlerFacet.calculatePieceReward(owner.address) / 1e18} piece from idleing`);
    })

})
