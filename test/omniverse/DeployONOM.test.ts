// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { ONOM, OmnimonItems, OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";


let Omniverse: OmniverseFacet;
let OmnimonItems: OmnimonItems;
let ONOM: ONOM;
let owner: any;

describe("ONOM deployment test",
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


            let onomFactory = await ethers.getContractFactory("ONOM")
            ONOM = await upgrades.deployProxy(onomFactory, ["Omnimons", "ONOM", 0, LZEndpoints[network.name.toLowerCase()] || LZEndpoints.goerli])
            await ONOM.deployed();
           
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

        it("should deploy ONOM", async () => {
            expect(await ONOM.name()).to.be.eq("Omnimons")
            expect(await ONOM.symbol()).to.be.eq("ONOM")
        })
    });
