// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { OmnimonItems, Omnimons, OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";
import ItemList from "../../constants/items.json";
import LootBoxList from "../../constants/lootbox.json";

let tx
let Omniverse: OmniverseFacet;
let Omnimons: Omnimons;
let OmnimonItems: OmnimonItems;
let owner: any;
const minGas = 150000;

const testAssets = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]

describe("Omnimon deployment test",

    function () {
        async function deployAll() {
            // console.log('Deploying contracts...');
            const [owner$] = await ethers.getSigners();
            owner = owner$;
            const diamond = await deployDiamond(
                [
                    100000,
                    LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli
                ]
            )
            Omniverse = await ethers.getContractAt("OmniverseFacet", diamond) as any
            let OmnimonsFactory = await ethers.getContractFactory("Omnimons")
            let OmnimonItemsFactory = await ethers.getContractFactory("OmnimonItems")


            Omnimons = await upgrades.deployProxy(OmnimonsFactory, ["Omnimons", "ONOM", minGas, (LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli), 1, 1000])
            await Omnimons.deployed();
            console.log('Deployed Omnimons');

            OmnimonItems = await upgrades.deployProxy(OmnimonItemsFactory, ["Omnimons.com/", (LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli)])
            await OmnimonItems.deployed();
            console.log('Deployed OmnimonItems');
            tx = await Omnimons.setItems(OmnimonItems.address)
            await tx.wait(1)
            console.log('setItems');
            tx = await OmnimonItems.setOperator(Omnimons.address, true)
            await tx.wait(1)
            console.log('setOperator');
        }

        before(async function () {
            await deployAll()
        });

        it("should deploy", async () => {
            console.log(await Omniverse.getLzEndpoint());
            console.log(await Omniverse.minGasToTransferAndStore());
            expect(await Omniverse.getLzEndpoint()).to.be.eq(LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli)
            expect(await Omniverse.minGasToTransferAndStore()).to.be.eq(100000)
            expect(await Omniverse.hello()).to.eq("world");
        })

        it("should deploy Omnimons", async () => {
            expect(await Omnimons.FUNCTION_TYPE_SEND()).to.be.eq(1)
            expect(await Omnimons.lzEndpoint()).to.be.eq(LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli)
            expect(await Omnimons.maxMintId()).to.be.eq(1000)
        })

        it("should set ItemList", async () => {
            tx = await OmnimonItems.setItems(ItemList)
            await tx.wait(1)
        })

        it("should set ItemPool", async () => {
            for (let index = 0; index < ItemList.length; index++) {
                let arr = new Array(ItemList[index]).fill(null)
                let itemIdsMock = arr.map((v, idx) => ((index + 1) * 1e7) + (idx + 1))
                // console.log({ itemIdsMock });

                tx = await OmnimonItems.setItemPool(index, itemIdsMock)
                await tx.wait(1)
            }
        })

        it("should mint token", async () => {
            let tx = await Omnimons.mint()
            await tx.wait(1)
            expect((await Omnimons.nextMintId()).eq(2)).to.be.true
            expect(await Omnimons.ownerOf(1)).to.be.eq(owner.address)
        })

        it("should mint token", async () => {
            let tx = await Omnimons.mint()
            await tx.wait(1)
            expect((await Omnimons.nextMintId()).eq(3)).to.be.true
            expect(await Omnimons.ownerOf(2)).to.be.eq(owner.address)
        })

        it("should mint token 2", async () => {
            let tx = await Omnimons.mint()
            await tx.wait(1)
            expect((await Omnimons.nextMintId()).eq(4)).to.be.true
            expect(await Omnimons.ownerOf(3)).to.be.eq(owner.address)
        })

        it("fetch Omnimon 1 properties", async () => {
            const omnimon = await Omnimons.omnimon(1)
            console.log(omnimon.traits.map(a => a.toNumber()));
            expect(omnimon.lastBridgeBlock).to.be.gt(0)
        })
        it("fetch Omnimon 2 properties", async () => {
            const omnimon = await Omnimons.omnimon(2)
            console.log(omnimon.traits.map(a => a.toNumber()));
            expect(omnimon.lastBridgeBlock).to.be.gt(0)
        })
        it("fetch Omnimon 3 properties", async () => {
            const omnimon = await Omnimons.omnimon(3)
            console.log(omnimon.traits.map(a => a.toNumber()));
            expect(omnimon.lastBridgeBlock).to.be.gt(0)
        })

        it("fetch Omnimon 3 override traits", async () => {
            const omnimon = await Omnimons.omnimon(3)
            console.log(omnimon.equippedTraits);
            expect(omnimon.equippedTraits[0].toNumber()).to.be.eq(0)
        })

        it("fetch Omnimon 3, lock trait 0 and be override", async () => {
            let omnimon = await Omnimons.omnimon(3)
            const traitBeforeConversion = omnimon.equippedTraits[0].toNumber()
            expect(omnimon.traits[0].toNumber()).to.be.gt(0)
            console.log({
                traitBeforeUnequip: traitBeforeConversion
            });
            tx = await Omnimons.convertTraitToItem(3, 0)
            await tx.wait(1)

            omnimon = await Omnimons.omnimon(3)

            const traitAfter = omnimon.traits[0].toNumber()
            console.log({
                traitAfter
            });

            const overriddenTraitAfter = omnimon.equippedTraits[0].toNumber()
            expect(overriddenTraitAfter).to.be.gt(0)
            console.log("overriden trait:");
            console.log(overriddenTraitAfter);
            equipmentId = overriddenTraitAfter;

            const balance = await OmnimonItems.balanceOf(owner.address, overriddenTraitAfter)
            console.log({ balance });
            expect(balance.toNumber()).to.be.eq(0, "Token not minted")
        })

        let equipmentId;

        it("fetch Omnimon 3, unequip & equipped trait item", async () => {
            let omnimon = await Omnimons.omnimon(3)
            console.log({
                equipmentId
            });

            console.log({
                traits: omnimon.traits,
                overriden: omnimon.equippedTraits
            });

            tx = await Omnimons.unequipItem(3, 0)
            await tx.wait(1)
            omnimon = await Omnimons.omnimon(3)
            const traitAfterUnEquip = omnimon.equippedTraits[0].toNumber()
            console.log("overriden trait after unequip");
            console.log({
                traitAfterUnEquip: traitAfterUnEquip
            });
            expect(traitAfterUnEquip).to.be.eq(0)
            const balance = await OmnimonItems.balanceOf(owner.address, equipmentId)
            console.log(balance);
            expect(balance.toNumber()).to.be.eq(1, "Token not minted")

            tx = await Omnimons.equipItem(3, equipmentId)
            await tx.wait(1)

            omnimon = await Omnimons.omnimon(3)
            console.log({
                traits2: omnimon.traits,
                overriden2: omnimon.equippedTraits
            });

            const traitAfterEquip = omnimon.equippedTraits[0].toNumber()
            console.log("overriden trait after unequip");
            console.log({
                traitAfterUnequip: traitAfterEquip
            });
            expect(traitAfterEquip).to.be.eq(equipmentId)
            const balance2 = await OmnimonItems.balanceOf(owner.address, equipmentId)
            console.log(balance2);
            expect(balance2.toNumber()).to.be.eq(0, "Token not burned")
        })
    });
