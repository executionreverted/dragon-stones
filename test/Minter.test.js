import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Dragon", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        owner = accounts[0]
        owner2 = accounts[1]

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

    const tokensToMint = 10
    it("should create tokens", async function () {
        for (let index = 0; index < tokensToMint; index++) {
            await MinterFacet.mintPiece();
            console.log(await DragonStonePieces.balanceOf(owner.address));
            await MinterFacet.createStone();
        }
    })

    it("should have different tokens", async function () {
        for (let index = 0; index < tokensToMint; index++) {
            const ds = await DragonStoneFacet.getRawDragonStone(index);
            console.log(` token ${index} stone type: ${StoneTypes[ds.STONE_TYPE]} `);
        }
    })


    it("should polish token 1", async function () {
        await MinterFacet.mintPiece();


        await PolishFacet.polish(1, 2);
        let ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        await PolishFacet.polish(3, 4);
        ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        await PolishFacet.polish(1, 3);
        ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
        console.log(`Piece left: ${pieceBalance}`);
    })

    it("should equip token 1", async function () {
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
        console.log('::::::::TIER 0 POLISH 1 STATS::::::::');
        console.log(page[1]);
    })

    it("should polish token 5", async function () {
        await PolishFacet.polish(5, 6);
        let ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        await PolishFacet.polish(7, 8);
        ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        await PolishFacet.polish(5, 7);
        ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.POLISH_LEVEL}`);

        const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
        console.log(`Piece left: ${pieceBalance}`);
    })

    it("should combine token 1 with 5", async function () {
        await CombineFacet.combine(1, 5);
        let ds = await DragonStoneFacet.getRawDragonStone(1);
        console.log(`Token 1 polish level: ${ds.TIER}`);

        const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
        console.log(`Piece left: ${pieceBalance}`);
    })

    it("should calculate my active page stats right", async function () {
        let page = await SymbolFacet.getPlayerStats(owner.address);
        console.log('::::::::TIER 1 POLISH 1 STATS::::::::');
        console.log(page[1]);
    })

    it("should upgrade token 1, 50 times", async function () {
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintBlessing();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();
        await MinterFacet.mintPiece();


        for (let index = 0; index < 50; index++) {
            await UpgradeFacet.upgrade(1, true);
            let ds = await DragonStoneFacet.getRawDragonStone(1);
            console.log('Iter: ' , index);
            console.log(`Token 1 upgrade level: ${ds.UPGRADE_LEVEL}`);
            if (ds.UPGRADE_LEVEL.eq(15)) {
                console.log('+15! WOHOOOO');
                break;
            }
            const pieceBalance = await DragonStonePieces.balanceOf(owner.address)
            console.log(`Piece left: ${pieceBalance/ 1e18}`);
            const blessingBalance = await DragonStoneBlessing.balanceOf(owner.address)
            console.log(`Blessings left: ${blessingBalance/ 1e18}`);
            let page = await SymbolFacet.getPlayerStats(owner.address);
            console.log('::::::::TIER 1 POLISH 1 STATS::::::::');
            console.log(`STR: ${page[1]}`);
        }
    })
})
