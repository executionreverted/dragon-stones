import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, owner3, PremiumFacet, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        await RegisterFacet.registerAccount(1, 1);
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("1", "Not right")
    })

    it("account has no premium", async function () {
        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })
    it("account buys premium", async function () {
        const price = await PremiumFacet.premiumPriceByDays(1)
        await PremiumFacet.buyPremium(1, { value: price })

        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })

    it("should revert if no value", async function () {
        expect(PremiumFacet.buyPremium(1, { value: ethers.utils.parseEther('0.5') })).to.revertedWith('PremiumFacet: payment required')

        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })

    it("should change price of premium", async function () {
        await PremiumFacet.setPremiumPrice(ethers.utils.parseEther('0.05'));
    })

    it("account buys premium", async function () {
        await PremiumFacet.buyPremium(1, { value: ethers.utils.parseEther('0.05') })

        const data = await PremiumFacet.userPremiumStatus(owner.address)
        console.log(data);
    })


    it("bulk 14 / 31 days discount", async function () {
        const price = await PremiumFacet.premiumPriceByDays(1)
        const price2 = await PremiumFacet.premiumPriceByDays(14)
        const price3 = await PremiumFacet.premiumPriceByDays(31)
        expect(price.lt(price2), "14 days is not cheaper").to.be.true
        expect(price2.lt(price3), "31 days is not cheaper").to.be.true
    })

})
