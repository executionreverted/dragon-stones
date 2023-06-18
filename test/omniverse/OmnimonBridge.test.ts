// @ts-nocheck
import { network, ethers, upgrades } from "hardhat";
import { expect } from "chai";
import { deployDiamond } from "./deploy";
import { OmniverseFacet } from "../../typechain-types";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";
import ItemList from "../../constants/items.json";


describe("ONFT721Upgradeable: ", function () {
    const chainId_A = 1
    const chainId_B = 2
    const minGasToStore = 250000
    const name = "Omnimons"
    const symbol = "OMNIMON"
    const defaultAdapterParams = ethers.utils.solidityPack(["uint16", "uint256"], [1, 1200000])

    let tx: any, owner: any, warlock: any, lzEndpointMockA: any, lzEndpointMockB: any, LZEndpointMock: any, ONFT721: any, ONFT_A: any, ONFT_B: any, OmnimonItems: any, OmnimonItems2: any
    before(async function () {
        owner = (await ethers.getSigners())[0]
        warlock = (await ethers.getSigners())[1]
        LZEndpointMock = await ethers.getContractFactory("LZEndpointMock")
        ONFT721 = await ethers.getContractFactory("Omnimons")
    })

    beforeEach(async function () {
        lzEndpointMockA = await LZEndpointMock.deploy(chainId_A)
        lzEndpointMockB = await LZEndpointMock.deploy(chainId_B)

        // generate a proxy to allow it to go ONFT
        ONFT_A = await upgrades.deployProxy(ONFT721, [name, symbol, minGasToStore, lzEndpointMockA.address, 1, 1000])
        ONFT_B = await upgrades.deployProxy(ONFT721, [name, symbol, minGasToStore, lzEndpointMockB.address, 1, 1000])

        // wire the lz endpoints to guide msgs back and forth
        lzEndpointMockA.setDestLzEndpoint(ONFT_B.address, lzEndpointMockB.address)
        lzEndpointMockB.setDestLzEndpoint(ONFT_A.address, lzEndpointMockA.address)

        // set each contracts source address so it can send to each other
        await ONFT_A.setTrustedRemote(chainId_B, ethers.utils.solidityPack(["address", "address"], [ONFT_B.address, ONFT_A.address]))
        await ONFT_B.setTrustedRemote(chainId_A, ethers.utils.solidityPack(["address", "address"], [ONFT_A.address, ONFT_B.address]))

        // set min dst gas for swap
        await ONFT_A.setMinDstGas(chainId_B, 1, 150000)
        await ONFT_B.setMinDstGas(chainId_A, 1, 150000)

        let OmnimonItemsFactory = await ethers.getContractFactory("OmnimonItems")
        OmnimonItems = await upgrades.deployProxy(OmnimonItemsFactory, ["https://myuri.com/", (lzEndpointMockA.address)])
        await OmnimonItems.deployed()
        OmnimonItems2 = await upgrades.deployProxy(OmnimonItemsFactory, ["https://myuri.com/", (lzEndpointMockB.address)])
        await OmnimonItems2.deployed()

        tx = await ONFT_A.setItems(OmnimonItems.address)
        await tx.wait(1)
        console.log('setItems');
        tx = await ONFT_B.setItems(OmnimonItems2.address)
        await tx.wait(1)
        console.log('setItems2');
        tx = await OmnimonItems.setOperator(ONFT_A.address, true)
        await tx.wait(1)
        console.log('setOperator1');
        tx = await OmnimonItems2.setOperator(ONFT_B.address, true)
        await tx.wait(1)
        console.log('setOperator2');
        tx = await OmnimonItems.setItems(ItemList)
        tx = await OmnimonItems2.setItems(ItemList)
        for (let index = 0; index < ItemList.length; index++) {
            let arr = new Array(ItemList[index]).fill(null)
            let itemIdsMock = arr.map((v, idx) => ((index + 1) * 1e7) + (idx + 1))
            // console.log({ itemIdsMock });

            tx = await OmnimonItems.setItemPool(index, itemIdsMock)
            await tx.wait(1)
            tx = await OmnimonItems2.setItemPool(index, itemIdsMock)
            await tx.wait(1)
            console.log('Setting item pool ', index);
        }
    })

    it("sendFrom() - your own tokens", async function () {
        const tokenId = 1


        await ONFT_A.mint()
        console.log('TK');

        console.log(
            await ONFT_A.tokenOfOwnerByIndex(owner.address, 0)
        );

        // verify the owner of the token is on the source chain
        expect(await ONFT_A.ownerOf(tokenId)).to.be.equal(owner.address)
        console.log('1');
        

        // token doesn't exist on other chain
        await expect(ONFT_B.ownerOf(tokenId)).to.be.revertedWith("ERC721: invalid token ID")
        console.log('2');

        // can transfer token on srcChain as regular erC721
        await ONFT_A.transferFrom(owner.address, warlock.address, tokenId)
        console.log('3');

        expect(await ONFT_A.ownerOf(tokenId)).to.be.equal(warlock.address)
        console.log('4');

        // approve the proxy to swap your token
        await ONFT_A.connect(warlock).approve(ONFT_A.address, tokenId)
        console.log('5');

        // estimate nativeFees
        let nativeFee = (await ONFT_A.estimateSendFee(chainId_B, warlock.address, tokenId, false, defaultAdapterParams)).nativeFee
        console.log('6');

        // swaps token to other chain
        await ONFT_A.connect(warlock).sendFrom(
            warlock.address,
            chainId_B,
            warlock.address,
            tokenId,
            warlock.address,
            ethers.constants.AddressZero,
            defaultAdapterParams,
            { value: nativeFee }
        )
        console.log('7');

        // token is burnt
        expect(await ONFT_A.ownerOf(tokenId)).to.be.equal(ONFT_A.address)
        console.log('8');

        // token received on the dst chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(warlock.address)
        console.log('0');

        // estimate nativeFees
        nativeFee = (await ONFT_B.estimateSendFee(chainId_A, owner.address, tokenId, false, defaultAdapterParams)).nativeFee
        console.log('11');

        // can send to other onft contract eg. not the original nft contract chain
        await ONFT_B.connect(warlock).sendFrom(
            warlock.address,
            chainId_A,
            warlock.address,
            tokenId,
            warlock.address,
            ethers.constants.AddressZero,
            defaultAdapterParams,
            { value: nativeFee }
        )
        console.log('12');

        // token is burned on the sending chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(ONFT_B.address)
        console.log('13');
    })

    it("sendFrom() - reverts if not owner on non proxy chain", async function () {
        const tokenId = 1
        await ONFT_A.mint()

        // approve the proxy to swap your token
        await ONFT_A.approve(ONFT_A.address, tokenId)

        // estimate nativeFees
        let nativeFee = (await ONFT_A.estimateSendFee(chainId_B, owner.address, tokenId, false, defaultAdapterParams)).nativeFee

        // swaps token to other chain
        await ONFT_A.sendFrom(owner.address, chainId_B, owner.address, tokenId, owner.address, ethers.constants.AddressZero, defaultAdapterParams, {
            value: nativeFee,
        })

        // token received on the dst chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(owner.address)

        // reverts because other address does not own it
        await expect(
            ONFT_B.connect(warlock).sendFrom(
                warlock.address,
                chainId_A,
                warlock.address,
                tokenId,
                warlock.address,
                ethers.constants.AddressZero,
                defaultAdapterParams
            )
        ).to.be.revertedWith("ONFT721: send caller is not owner nor approved")
    })

    it("sendFrom() - on behalf of other user", async function () {
        const tokenId = 1
        await ONFT_A.mint()

        // approve the proxy to swap your token
        await ONFT_A.approve(ONFT_A.address, tokenId)

        // estimate nativeFees
        let nativeFee = (await ONFT_A.estimateSendFee(chainId_B, owner.address, tokenId, false, defaultAdapterParams)).nativeFee

        // swaps token to other chain
        await ONFT_A.sendFrom(owner.address, chainId_B, owner.address, tokenId, owner.address, ethers.constants.AddressZero, defaultAdapterParams, {
            value: nativeFee,
        })

        // token received on the dst chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(owner.address)

        // approve the other user to send the token
        await ONFT_B.approve(warlock.address, tokenId)

        // estimate nativeFees
        nativeFee = (await ONFT_B.estimateSendFee(chainId_A, owner.address, tokenId, false, defaultAdapterParams)).nativeFee

        // sends across
        await ONFT_B.connect(warlock).sendFrom(
            owner.address,
            chainId_A,
            warlock.address,
            tokenId,
            warlock.address,
            ethers.constants.AddressZero,
            defaultAdapterParams,
            { value: nativeFee }
        )

        // token received on the dst chain
        expect(await ONFT_A.ownerOf(tokenId)).to.be.equal(warlock.address)
    })

    it("sendFrom() - reverts if contract is approved, but not the sending user", async function () {
        const tokenId = 1
        await ONFT_A.mint()

        // approve the proxy to swap your token
        await ONFT_A.approve(ONFT_A.address, tokenId)

        // estimate nativeFees
        let nativeFee = (await ONFT_A.estimateSendFee(chainId_B, owner.address, tokenId, false, defaultAdapterParams)).nativeFee

        // swaps token to other chain
        await ONFT_A.sendFrom(owner.address, chainId_B, owner.address, tokenId, owner.address, ethers.constants.AddressZero, defaultAdapterParams, {
            value: nativeFee,
        })

        // token received on the dst chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(owner.address)

        // approve the contract to swap your token
        await ONFT_B.approve(ONFT_B.address, tokenId)

        // reverts because contract is approved, not the user
        await expect(
            ONFT_B.connect(warlock).sendFrom(
                owner.address,
                chainId_A,
                warlock.address,
                tokenId,
                warlock.address,
                ethers.constants.AddressZero,
                defaultAdapterParams
            )
        ).to.be.revertedWith("ONFT721: send caller is not owner nor approved")
    })

    it("sendFrom() - reverts if not approved on non proxy chain", async function () {
        const tokenId = 1
        await ONFT_A.mint()

        // approve the proxy to swap your token
        await ONFT_A.approve(ONFT_A.address, tokenId)

        // estimate nativeFees
        let nativeFee = (await ONFT_A.estimateSendFee(chainId_B, owner.address, tokenId, false, defaultAdapterParams)).nativeFee

        // swaps token to other chain
        await ONFT_A.sendFrom(owner.address, chainId_B, owner.address, tokenId, owner.address, ethers.constants.AddressZero, defaultAdapterParams, {
            value: nativeFee,
        })

        // token received on the dst chain
        expect(await ONFT_B.ownerOf(tokenId)).to.be.equal(owner.address)

        // reverts because user is not approved
        await expect(
            ONFT_B.connect(warlock).sendFrom(
                owner.address,
                chainId_A,
                warlock.address,
                tokenId,
                warlock.address,
                ethers.constants.AddressZero,
                defaultAdapterParams
            )
        ).to.be.revertedWith("ONFT721: send caller is not owner nor approved")
    })

    it("sendFrom() - reverts if sender does not own token", async function () {
        const tokenIdA = 1
        const tokenIdB = 1
        // mint to both owners
        await ONFT_A.mint()
        await ONFT_A.mint()

        // approve owner.address to transfer, but not the other
        await ONFT_A.setApprovalForAll(ONFT_A.address, true)

        await expect(
            ONFT_A.connect(warlock).sendFrom(
                warlock.address,
                chainId_B,
                warlock.address,
                tokenIdA,
                warlock.address,
                ethers.constants.AddressZero,
                defaultAdapterParams
            )
        ).to.be.revertedWith("ONFT721: send caller is not owner nor approved")
        await expect(
            ONFT_A.connect(warlock).sendFrom(
                warlock.address,
                chainId_B,
                owner.address,
                tokenIdA,
                owner.address,
                ethers.constants.AddressZero,
                defaultAdapterParams
            )
        ).to.be.revertedWith("ONFT721: send caller is not owner nor approved")
    })
})
