import { expect } from "chai";
import { Contract, Signer } from "ethers";
import { network, ethers, upgrades } from "hardhat";
import LZEndpoints from "../../constants/layerzeroEndpoints.json";

let nonce = 0;

const itemsData = [
    { limit: 10, supply: 100 },
    { limit: 20, supply: 1000 },
    { limit: 30, supply: 1000 },
    { limit: 40, supply: 1000 },
    { limit: 50, supply: 1000 },
    { limit: 60, supply: 1000 },
];


const contractParams = [
    'https://hatchysummoners/api/items/',
    itemsData.map(item => item.limit),
    itemsData.map(item => item.supply),
    1, // common item price
    5, // rare item price
    //hatchyTokenTestnet
]
/*
        string memory _name,
        string memory _symbol,
        uint256 _minGasToTransfer,
        address _lzEndpoint,
        uint startMintId,
        uint endMintId,
        string memory _uri,
        uint256 _mintPrice,
        uint256 _maxSupply,
        uint256 _traitsLength,
        address _items
         */
// const summonersPFPParams = [
//     "SummonersPFP",
//     "SUMMONERS$PFP",
//     200000,
//     LZEndpoints[network.name],
//     "https://hatchysummoners/api/pfp",
//     ethers.utils.parseEther("0.0000001"),
//     1000,
//     5
// ]



describe("SummonersPFPTest: Deploy contracts in testnet", function () {
    let signer: Signer;
    let senderAddress: string;
    let thirdAddress: string;
    let signerAddress: string;
    let hatchyToken: Contract;
    let summonersItems: Contract;
    let summonersPFP: Contract;
    let items: any[];

    before("Deploy Contract", async function () {
        [senderAddress, signerAddress, thirdAddress] = await ethers.provider.listAccounts();
        signer = ethers.provider.getSigner(signerAddress);
        let LZEndpointMock
        let lzEndpointMockA

        if (network.name == "hardhat") {
            LZEndpointMock = await ethers.getContractFactory("LZEndpointMock")
            lzEndpointMockA = await LZEndpointMock.deploy(1)
        }
        const lz: any = lzEndpointMockA?.address as any;
        // hatchyToken
        const HATCHY = await ethers.getContractFactory("ERC20Mock");
        const hatchy = await HATCHY.deploy('hatchy', 'hatchymock');
        await hatchy.deployed();
        hatchyToken = hatchy;
        console.log('deployed hatchy token');

        const SummonersItems = await ethers.getContractFactory("SummonersItems");
        summonersItems = await upgrades.deployProxy(SummonersItems,
            /*   string memory _baseUri,
          address _lzEndpoint,
          uint256[] memory initialItemsLimits,
          uint256[] memory initialItemsSupplies,
          uint256 _commonItemPrice,
          uint256 _rareItemPrice,
          address _hatchyToken,
          address _avatarsAddress */
            [
                'https://hatchysummoners/api/items/',
                lz,
                itemsData.map(item => item.limit),
                itemsData.map(item => item.supply),
                1, // common item price
                5,
                hatchy.address,
                ethers.constants.AddressZero
            ]);
        await summonersItems.deployed()
        await summonersItems.flipState();
        console.log(`SummonersItems deployed to ${summonersItems.address}`);

        const SummonersPFP = await ethers.getContractFactory("SummonersPFP");
        summonersPFP = await upgrades.deployProxy(SummonersPFP, [
            /*
           string memory _name,
           string memory _symbol,
           uint256 _minGasToTransfer,
           address _lzEndpoint,
           uint startMintId,
           uint endMintId,
           string memory _uri,
           uint256 _mintPrice,
           uint256 _maxSupply,
           uint256 _traitsLength,
           address _items
            */
            "SummonersPFP",
            "SUMMONERS$PFP",
            200000,
            lz,
            0,
            1000,
            "https://hatchysummoners/api/pfp",
            ethers.utils.parseEther("0.0000001"),
            1000,
            5,
            summonersItems.address
        ]);
        await summonersPFP.deployed();
        await summonersPFP.flipSale();
        await summonersItems.setAvatarsAddress(summonersPFP.address)
        console.log(`SummonersPFP deployed to ${summonersPFP.address}`);
    });

    it("Mint Summoner PFP", async function () {
        const data = await summonersPFP.mint(1, [[1, 2, 3, 4, 5]], { value: ethers.utils.parseEther("0.0000001") });
        const res = await data.wait(1);
        console.log(res);
        console.log(await summonersPFP.ownerOf(0));
    });

    it("Approve SummonersItems to spend $HATCHY", async function () {
        const data = await hatchyToken.approve(summonersItems.address, ethers.constants.MaxUint256);
        await data.wait(1);
        console.log(`contract ${summonersItems.address} approved to spend $HATCHY`)
    });

    it("Approve summonersPFP to spend SummonersItems", async function () {
        const data = await summonersItems.setApprovalForAll(summonersPFP.address, true);
        await data.wait(1);
        console.log(`contract ${summonersPFP.address} approved to spend SummonersItems`)
    });

    it("Get items data", async function () {
        const newItems = await summonersItems.getItemsData();
        const itemsData = newItems.map((item: any) => ({
            limit: item[0].toNumber(),
            supply: item[0].toNumber(),
        }))
        console.table(itemsData);
    });

    it("Mint full lootbox - amount: 1", async function () {
        const data = await summonersItems.fullLootbox(1);
        const res = await data.wait(1);
        items = res.events.filter((event: any) => {
            return event.event === "NewItemMinted";
        }).map((event: any) => (
            {
                amount: event.args?.amount.toNumber(),
                itemType: event.args?.itemType.toNumber(),
                id: event.args?.id.toNumber(),
                owner: event.args?.owner,
            }
        ))
        console.table(items);
    });

    it("Mint single lootbox - amount: 1", async function () {
        const data = await summonersItems.singleLootbox(1, 1);
        const res = await data.wait(1);
        const item = res.events.filter((event: any) => {
            return event.event === "NewItemMinted";
        }).map((event: any) => (
            {
                amount: event.args?.amount.toNumber(),
                itemType: event.args?.itemType.toNumber(),
                id: event.args?.id.toNumber(),
                owner: event.args?.owner,
            }
        ))
        console.table(item);
    });

    it("Fail to call summonersItems.burnEquippedItems", async function () {
        await expect(summonersItems.burnEquippedItem(1)).to.be.reverted;
        await expect(summonersItems.returnEquippedItem(1)).to.be.reverted;
    });

    it("Fail to call summonersPFP.equip", async function () {
        const paramsToSign = {
            owner: thirdAddress,
            pfp: 2,
            items: items.map(item => item.id),
            nonce: nonce++,
        }
        const signData = await signMessage(signer, paramsToSign);
        await expect(summonersPFP.equip(
            paramsToSign.pfp,
            paramsToSign.items,
            { gasLimit: 1000000 }
        )).to.be.revertedWith('caller is not the owner');

        const paramsToSign2 = {
            owner: senderAddress,
            pfp: 0,
            items: items.map(item => item.id),
            nonce: nonce++,
        }
        const signData2 = await signMessage(ethers.provider.getSigner(senderAddress), paramsToSign2);
        await expect(summonersPFP.equip(
            {
                ...paramsToSign2,
                ...signData2
            },
            { gasLimit: 1000000 }
        )).to.be.revertedWith('invalid signer');

        const paramsToSign3 = {
            owner: senderAddress,
            pfp: 0,
            items: [1],
            nonce: nonce++,
        }
        const signData3 = await signMessage(signer, paramsToSign3);
        await expect(summonersPFP.equip(
            {
                ...paramsToSign3,
                ...signData3
            },
            { gasLimit: 1000000 }
        )).to.be.revertedWith('item not owned');
    });

    it.skip("Equip items with summonersPFP.equip", async function () {
        console.log(`sending equip from ${senderAddress}`)
        const paramsToSign = {
            owner: senderAddress,
            pfp: 0,
            items: [...items.map(item => item.id)],
            nonce: nonce++,
        }
        console.table(paramsToSign);
        const signData = await signMessage(signer, paramsToSign);
        const res = await summonersPFP.equip(
            {
                ...paramsToSign,
                ...signData
            },
            { gasLimit: 1000000 }
        );
        await res.wait(1);
        console.log(`equipped items`);
    });

    it("Get equipped items", async function () {
        const equippedItems = await summonersPFP.getEquippedItems(0);
        const equippedItemsData = equippedItems.map((item: any) => ({
            id: item.toNumber(),
        }));
        console.table(equippedItemsData);
    });

    it("Mint mixed lootbox - amount: 3", async function () {
        const data = await summonersItems.mixedLootbox(3);
        const res = await data.wait(1);
        items = res.events.filter((event: any) => {
            return event.event === "NewItemMinted";
        }).map((event: any) => (
            {
                amount: event.args?.amount.toNumber(),
                itemType: event.args?.itemType.toNumber(),
                id: event.args?.id.toNumber(),
                owner: event.args?.owner,
            }
        ))
        console.table(items);
    });

    it("Mint rare lootbox - amount: 1", async function () {
        const data = await summonersItems.rareLootbox(1);
        const res = await data.wait(1);
        items = [...items,
        ...res.events.filter((event: any) => {
            return event.event === "NewItemMinted";
        }).map((event: any) => (
            {
                amount: event.args?.amount.toNumber(),
                itemType: event.args?.itemType.toNumber(),
                id: event.args?.id.toNumber(),
                owner: event.args?.owner,
            }
        ))
        ]
        console.table(items);
    });

    it("Equip new items replacing previous ones", async function () {
        const itemIdToEquip = items[0].id;
        console.log({items});
        console.log({itemIdToEquip});
        
        const paramsToSign = {
            owner: senderAddress,
            pfp: 0,
            items: [itemIdToEquip],
            nonce: nonce++,
        }
        const res = await summonersPFP.equip(
            paramsToSign.pfp, paramsToSign.items,
            { gasLimit: 1000000 }
        );
        await res.wait(1);
        const equippedItems = await summonersPFP.getEquippedItems(0);
        const equippedItemsData = equippedItems.map((item: any) => item.toNumber());
        console.table(equippedItemsData)
        expect(equippedItemsData.includes(itemIdToEquip)).to.be.true;
    });

    it("Unequip items", async function () {
        const paramsToSign = {
            owner: senderAddress,
            pfp: 0,
            items: [0, 1, 2, 3, 4, 5],
            nonce: nonce++,
        }
        const signData = await signMessage(signer, paramsToSign);
        const res = await summonersPFP.unequip(paramsToSign.pfp, paramsToSign.items);
        await res.wait(1);
        const equippedItems = await summonersPFP.getEquippedItems(0);
        const equippedItemsData = equippedItems.filter((item: any) => item.gt(0))
        expect(equippedItemsData.length).to.be.equal(0);
    });

    // it("Get owned items", async function () {
    //     const newItems = await summonersItems.getOwnedItems(senderAddress);
    //     const itemsBalance = newItems.map((item: any) => ({
    //         id: item[0].toNumber(),
    //         amount: item[1].toNumber(),
    //     }));
    //     console.table(itemsBalance);
    // });
});

const signMessage = async (signer: Signer, paramsToSign: any) => {
    const message = ethers.utils.solidityKeccak256(
        ["address", "uint256", "uint256[]", "uint256"],
        [paramsToSign.owner, paramsToSign.pfp, paramsToSign.items, paramsToSign.nonce]
    );
    const signature = await signer.signMessage(ethers.utils.arrayify(message));
    const { r, s, v } = ethers.utils.splitSignature(signature);
    return { r, s, v }
}