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
    const StoneTypes = {
        0: "RUBY", // FIRE
        1: "SAPPHIRE", // COLD
        2: "AMBER", // LIGHTNING
        3: "EMERALD", // NATURE
        4: "DIAMOND", // HOLY
        5: "AMETHYST", // DARK
        6: "COSMIC" // GIGA!
    }
    
    const tokensToMint = 100
    it("should create tokens", async function () {
        for (let index = 0; index < tokensToMint; index++) {
            await MinterFacet.createStone();
        }
    })

    it("should have different tokens", async function () {
        for (let index = 0; index < tokensToMint; index++) {
            const ds = await DragonStoneFacet.getRawDragonStone(index);
            console.log(` token ${index} stone type: ${StoneTypes[ds.STONE_TYPE]} `);
        }
    })

})
