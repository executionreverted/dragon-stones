// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { OmnimonItems, Omnimons, OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";
import ItemList from "../../constants/items.json";
import LootBoxList from "../../constants/lootbox.json";
import { LootBoxStruct } from "../../typechain-types/contracts/OmniverseNFT/OmnimonItems";


let Omniverse: OmniverseFacet;
let Omnimons: Omnimons;
let OmnimonItems: OmnimonItems;
let owner: any;
const minGas = 150000;
let tx
const testAssets = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50]

describe("Omnimon ticket test",

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
            Omnimons = await upgrades.deployProxy(OmnimonsFactory, ["Omnimons", "ONOM", minGas, (LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli), 1, 1000])
            await Omnimons.deployed();
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

        it("should deploy OmnimonItems", async () => {
            let OmnimonItemsFactory = await ethers.getContractFactory("OmnimonItems")
            OmnimonItems = await upgrades.deployProxy(OmnimonItemsFactory, ["https://myuri.com/", (LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli)])
            await OmnimonItems.deployed()
            OmnimonItems.setOmnimon(Omnimons.address)
        })

        it("should set ItemList", async () => {
            tx = await OmnimonItems.setItems(ItemList)
            await tx.wait(1)
        })

        it("should set ItemPool", async () => {
            tx = await OmnimonItems.setItemPool(1, [3, 5, 7])
            await tx.wait(1)
        })

        it("should set ItemPool", async () => {
            tx = await OmnimonItems.setItemPool(2, [23, 22, 21])
            await tx.wait(1)
        })

        it("should set LootBoxes", async () => {
            tx = await OmnimonItems.setLootBoxes(LootBoxList)
            await tx.wait(1)
        })

        it("should set BoxPool", async () => {
            tx = await OmnimonItems.setLootBoxPool([999996, 999997, 999998])
            await tx.wait(1)
        })


        it("should fetch Pools", async () => {
            console.log('Item pool for slot 1');

            console.log(
                (await OmnimonItems.itemPool(1)).map(a => a.toNumber())
            );
            console.log('Item pool for slot 2');
            console.log(
                (await OmnimonItems.itemPool(2)).map(a => a.toNumber())
            );
            console.log('Lootbox pools as rewards');
            console.log(
                (await OmnimonItems.lootboxPool()).map(a => a.toNumber())
            );
        })

        it("should create Lootbox", async () => {
            const box: LootBoxStruct = {
                boxId: 10000000002,
                buyable: true,
                price: 0,
                itemLootPool: [1, 2, 3, 4]
            }
            const box2: LootBoxStruct = {
                boxId: 10000000003,
                buyable: true,
                price: 0,
                itemLootPool: [1, 12, 13, 14]
            }
            const tx = await OmnimonItems.setLootBoxes([box, box2])
        })

        it("should mint Lootbox", async () => {
            const tx = await OmnimonItems.buyBox(10000000002, 5)
            const tx2 = await OmnimonItems.buyBox(10000000003, 10)
            const baln = await OmnimonItems.balanceOf(owner.address, 10000000002)
            console.log(baln);
            expect(baln.toNumber()).to.be.eql(5)
        })

        it("should open the box", async () => {
            const box = await OmnimonItems.lootbox(10000000002)
            const box2 = await OmnimonItems.lootbox(10000000003)
            const tx = await OmnimonItems.openLootBox([10000000002, 10000000003], [5, 10])

            let combpool = Array.from(new Set(
                [
                    ...box.itemLootPool.map(a => a.toNumber()),
                    ...box2.itemLootPool.map(a => a.toNumber())
                ]))

            console.log(combpool);
            const r = []

            for (let index = 0; index < combpool.length; index++) {
                const token = combpool[index];
                const bal = (await OmnimonItems.balanceOf(owner.address, token)).toString()
                console.log(`token: ${token} , balance: ${bal}`);
                r.push({ token: token.toString(), balance: bal.toString() })
            }
            console.table(r)
        })

        it("should claim Lootbox", async () => {
            // to test this, disable requirements in claim function.
            return;
            const boxes = [999996, 999997, 999998]
            console.log('pre:');
            for (let index = 0; index < boxes.length; index++) {
                const token = boxes[index]
                console.log(
                    `${token} :`,
                    await OmnimonItems.balanceOf(owner.address, boxes[index])
                );
            }
            const tx = await OmnimonItems.claimBox(1)
            console.log('post:');
            for (let index = 0; index < boxes.length; index++) {
                const token = boxes[index]
                console.log(
                    `${token} :`,
                    await OmnimonItems.balanceOf(owner.address, boxes[index])
                );
            }
        })
    });
