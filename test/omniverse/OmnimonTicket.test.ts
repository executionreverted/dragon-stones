// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { Omnimons, OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";


let Omniverse: OmniverseFacet;
let Omnimons: Omnimons;
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

        // it("should reward Omnimon ticket", async () => {
        //     tx = await Omnimons.setOperator(owner.address, true)
        //     await tx.wait(1)
        //     expect((await Omnimons.ticketsOf(0)).eq(0)).to.be.true

        //     tx = await Omnimons.rewardTicket(0, 1)
        //     await tx.wait(1)
        //     expect((await Omnimons.ticketsOf(0)).eq(1)).to.be.true
        // })
        // it("should spend Omnimon ticket", async () => {
        //     expect((await Omnimons.omnimon(0)).eq(1)).to.be.true

        //     tx = await Omnimons.spendTicket(0, 1)
        //     await tx.wait(1)
        //     expect((await Omnimons.ticketsOf(0)).eq(0)).to.be.true
        // })
    });
