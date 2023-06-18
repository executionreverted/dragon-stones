// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";


let Omniverse: OmniverseFacet;
let owner: any;

describe("Diamond deployment test",
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
    });
