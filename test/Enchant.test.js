import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, owner3, EnchantFacet, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
        EnchantFacet = await ethers.getContractAt('EnchantFacet', deployed.Diamond.address);
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

    it("should mint", async function () {
        await MinterFacet.mintPiece()
        await MinterFacet.createStone()
        console.log(`Token 1 owner: ${await NonFungibleFacet.ownerOf(1)}`);
    })

    it("try enchant", async function () {
        for (let index = 0; index < 200; index++) {
            try {
                await EnchantFacet.enchant(1)
            } catch (error) {
                console.log(error);
                break;
            }
            let stone = await DragonStoneFacet.getRawDragonStone(1)
            console.log('TRY: ', index);
            console.log('Stone type:', stone.STONE_TYPE);
            console.log(stone.BONUS_IDS?.slice(0, 10)?.map(a => `${a}`));
            console.log(stone.BONUS_EFFS?.slice(0, 10).map(a => `${a}`));
        }
    })



})
