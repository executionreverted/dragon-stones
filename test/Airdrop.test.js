import { expect } from "chai";
import hre, { ethers } from "hardhat"
import { time } from "@nomicfoundation/hardhat-network-helpers"
import MerkleTree from "merkletreejs";
import keccak256 from "keccak256";

const deployments = hre.deployments

let merkleTree, airdropToAdd, owner, owner2, owner3, AirdropFacet, AirdropFacet2, AirdropFacet3, BossFacet, PremiumFacet, AdventureFacet, MerchantFacet, DailyFacet, TestFacet, CombineFacet, DragonStonePieces, DragonStoneGold, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
describe("Airdrop", function () {
    before(async function () {
        let accounts = await hre.ethers.getSigners()
        console.log(accounts);
        owner = accounts[0]
        owner2 = accounts[1]
        owner3 = accounts[2]
        airdropToAdd = [
            [owner2.address, "0", ethers.utils.parseUnits("100", 18).toString(), ethers.utils.parseUnits("555", 18).toString(), "0"],
            [owner3.address, "0", ethers.utils.parseUnits("10", 18).toString(), "0", "1"],
            [owner.address, "0", ethers.utils.parseUnits("12", 18).toString(), "0", "0"]
        ];
        merkleTree = generateMerkleTree(airdropToAdd);
        let deployed = await deployments.run(['DiamondApp'])
        console.log(`Diamond deployed to ${deployed.Diamond.address}`);
        CombineFacet = await ethers.getContractAt('CombineFacet', deployed.Diamond.address);
        DailyFacet = await ethers.getContractAt('DailyFacet', deployed.Diamond.address);
        TestFacet = await ethers.getContractAt('TestFacet', deployed.Diamond.address);
        MinterFacet = await ethers.getContractAt('MinterFacet', deployed.Diamond.address);
        UpgradeFacet = await ethers.getContractAt('UpgradeFacet', deployed.Diamond.address);
        PolishFacet = await ethers.getContractAt('PolishFacet', deployed.Diamond.address);
        DragonStoneFacet = await ethers.getContractAt('DragonStoneFacet', deployed.Diamond.address);
        SettingsFacet = await ethers.getContractAt('SettingsFacet', deployed.Diamond.address);
        RegisterFacet = await ethers.getContractAt('RegisterFacet', deployed.Diamond.address);
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
        MerchantFacet = await ethers.getContractAt('MerchantFacet', deployed.Diamond.address);
        AdventureFacet = await ethers.getContractAt('AdventureFacet', deployed.Diamond.address);
        BossFacet = await ethers.getContractAt('BossFacet', deployed.Diamond.address);
        PremiumFacet = await ethers.getContractAt('PremiumFacet', deployed.Diamond.address);
        AirdropFacet = await ethers.getContractAt('AirdropFacet', deployed.Diamond.address);
        AirdropFacet2 = await (await ethers.getContractAt('AirdropFacet', deployed.Diamond.address)).connect(owner2);
        AirdropFacet3 = await (await ethers.getContractAt('AirdropFacet', deployed.Diamond.address)).connect(owner3);
        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
        DragonStoneGold = await ethers.getContract('DragonStoneGold');
    })

    it("account should be disabled", async function () {
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log(`ActivePage: ${activePage}`);
        await expect(`${activePage}`).is.eq("0", "Not right")
    })

    it("account should be enabled and page set to 1", async function () {
        await RegisterFacet.registerAccount();
        const activePage = await SymbolFacet.activePageId(owner.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        await expect(`${activePage}`).is.eq("1", "Not right")
    })


    it("should create airdrop for 100 piece for 1 user", async function () {

        console.log(airdropToAdd.length);

        const initialState = 0; // coming soon
        const maxClaims = 1;
        const root = merkleTree.getHexRoot();

        let tx = await AirdropFacet.addAirdrop(root, initialState, maxClaims);
        await tx.wait(1);
        const airdrop = await AirdropFacet.getAirdrop(0)
        console.log('airdrop added');
        console.log(airdrop);
        await logBalance()
    })

    it("should not let claim because of state", async function () {
        const myRewards = [owner2.address, "0", ethers.utils.parseUnits("100", 18).toString(), "0", "0"];
        const amounts = myRewards.slice(1);
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        await expect(AirdropFacet2.claimAirdrop(owner2.address, amounts, 0, proof)).to.revertedWith('AirdropFacet: paused')
        await logBalance()
    })

    it("should not let claim because of non-whitelist", async function () {
        await AirdropFacet.setAirdropState(0, 1);
        const myRewards = [owner3.address, "0", ethers.utils.parseUnits("100", 18).toString(), "0", "0"];
        const amounts = ["0", ethers.utils.parseUnits("100", 18).toString(), "0", "0"]
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        await expect(AirdropFacet2.claimAirdrop(owner3.address, amounts, 0, proof)).to.revertedWith('AirdropFacet: not in list or altered leaf')
        await logBalance()
    })

    it("should not let claim because of altered rewards", async function () {
        const myRewards = [owner2.address, "0", ethers.utils.parseUnits("100", 18).toString(), ethers.utils.parseUnits("200", 18).toString(), "0"];
        const amounts = ["0", ethers.utils.parseUnits("100", 18).toString(), ethers.utils.parseUnits("200", 18).toString(), "0"]
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        await expect(AirdropFacet2.claimAirdrop(owner2.address, amounts, 0, proof)).to.revertedWith('AirdropFacet: not in list or altered leaf')
        // await expect(AirdropFacet2.claimAirdrop(owner2.address, myRewards, 0, proof)).to.be.revertedWith('AirdropFacet: not in list')
        await logBalance()
    })

    it("should let claim with valid leaf", async function () {
        const myRewards = airdropToAdd[0];
        console.log({ me: myRewards });
        const amounts = myRewards.slice(1);
        console.log({ amounts });
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        console.log({ proof });
        await AirdropFacet2.claimAirdrop(myRewards[0], amounts, 0, proof)
        await logBalance()
    })


    it("should not let claim user 3 with valid leaf, due to overclaim", async function () {
        const myRewards = airdropToAdd[1];
        const amounts = myRewards.slice(1);
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        await logBalance2()
        await expect(AirdropFacet3.claimAirdrop(myRewards[0], amounts, 0, proof)).to.be.revertedWith('AirdropFacet: max. claims reached')
    })


    // function updateAirdrop(
    //     uint airdropId,
    //     bytes32 _merkleRoot,
    //     uint8 _state,
    //     uint _maxClaims
    // ) 
    it("should  update airdrop", async function () {
        const airdrop = await AirdropFacet.getAirdrop(0)
        await AirdropFacet.updateAirdrop(0, airdrop.merkleRoot, 1, 2);
    })

    it("should not let claim user 3 with valid leaf, after update", async function () {
        const myRewards = airdropToAdd[1];
        const amounts = myRewards.slice(1);
        const leaf = generateLeaf(...myRewards)
        const proof = await merkleTree.getHexProof(leaf);
        await AirdropFacet3.claimAirdrop(myRewards[0], amounts, 0, proof);
        await logBalance2()
    })

    it("should not let update airdrop by random", async function () {
        const airdrop = await AirdropFacet.getAirdrop(0)
        await expect(AirdropFacet2.updateAirdrop(0, airdrop.merkleRoot, 1, 2)).to.revertedWith('Only admin can call this function')
    })
    it("should make owner2 admin", async function () {
        const airdrop = await AirdropFacet.getAirdrop(0)
        await AirdropFacet.setAirdropAdmin(owner2.address, true);
        await AirdropFacet2.updateAirdrop(0, airdrop.merkleRoot, 1, 2)
        // await expect(AirdropFacet2.updateAirdrop(0, airdrop.merkleRoot, 1, 2)).to.be.revertedWith('Only admin can call this function')
    })

    it("should not let owner2 call add admin", async function () {
        await expect(AirdropFacet2.setAirdropAdmin(owner3.address, true)).to.be.revertedWith('Only admin can call this function')
    })



    async function logBalance() {
        console.log(`balance piece: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`);
        console.log(`balance blessing: ${await DragonStoneBlessing.balanceOf(owner2.address) / 1e18}`);
        console.log(`balance gold: ${await DragonStoneGold.balanceOf(owner2.address) / 1e18}`);
    }

    async function logBalance2() {
        console.log(`balance2 piece: ${await DragonStonePieces.balanceOf(owner3.address) / 1e18}`);
        console.log(`balance2 blessing: ${await DragonStoneBlessing.balanceOf(owner3.address) / 1e18}`);
        console.log(`balance2 gold: ${await DragonStoneGold.balanceOf(owner3.address) / 1e18}`);
        const stonebal = await NonFungibleFacet.balanceOf(owner3.address);
        console.log(`balance2 stones: ${stonebal}`);
        if (stonebal.gt(0)) {
            console.log(await DragonStoneFacet.getRawDragonStone(1));
        }
    }

})


function generateLeaf(
    address,
    gold,
    piece,
    blessing,
    stone
) {
    return Buffer.from(
        // Hash in appropriate Merkle format
        ethers.utils
            .solidityKeccak256(
                ["address", "uint256", "uint256", "uint256", "uint256"],
                [address, gold, piece, blessing, stone]
            )
            .slice(2),
        "hex"
    );
}

const generateMerkleTree = (airdropData) => {
    console.log({ airdropData });

    const merkleTree = new MerkleTree(
        // Generate leafs
        airdropData.map(([address, gold, piece, blessing, stone]) =>
            generateLeaf(
                ethers.utils.getAddress(address),
                gold,
                piece, blessing, stone
            )
        ),
        // Hashing function
        keccak256,
        { sortPairs: true }
    );
    return merkleTree;
}
