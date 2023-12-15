import { expect } from "chai";
import hre, { ethers } from "hardhat"
const deployments = hre.deployments


let owner, owner2, owner3, CombineFacet, DragonStonePieces, DragonStoneBlessing, NonFungibleFacet, DragonStoneFacet, MinterFacet, UpgradeFacet, PolishFacet, SettingsFacet, RegisterFacet, SymbolFacet;
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
        RegisterFacet = await RegisterFacet.connect(owner2)
        SymbolFacet = await ethers.getContractAt('SymbolFacet', deployed.Diamond.address);
        NonFungibleFacet = await ethers.getContractAt('NonFungibleFacet', deployed.Diamond.address);
        DragonStonePieces = await ethers.getContract('DragonStonePieces');
        DragonStoneBlessing = await ethers.getContract('DragonStoneBlessing');
    })

    it("account should be disabled", async function () {
        const activePage = await SymbolFacet.activePageId(owner2.address);
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("0", "Not right")
    })

    it("account should be enabled and page set to 1", async function () {
        await RegisterFacet.registerAccount(1,1);
        const activePage = await SymbolFacet.activePageId(owner2.address);
        console.log('Account created');
        console.log(`ActivePage: ${activePage}`);
        expect(`${activePage}`).is.eq("1", "Not right")
    })

    it("account2 has payment splitter", async function () {
        const paymentSplitterOf = await RegisterFacet.paymentSplitter(owner2.address);
        console.log('Payment splitter of account 2: ');
        console.log(paymentSplitterOf);
        console.log(` Balance of account 2 before tx: ${await owner2.getBalance() / 1e18}`)
    })

    it("account2 receives eth payments", async function () {
        const paymentSplitterOf2 = await RegisterFacet.paymentSplitter(owner2.address);
        let PaymentSplitter = (await ethers.getContractAt('PaymentSplitter', paymentSplitterOf2));
        PaymentSplitter = await PaymentSplitter.connect(owner2);
        await owner.sendTransaction({ value: ethers.utils.parseEther('10'), to: paymentSplitterOf2 })
        console.log(`Releasing payment of ${owner2.address}`);
        await PaymentSplitter['release(address)']?.(owner2.address);
        console.log(` Balance of account 2 after release tx: ${await owner2.getBalance() / 1e18}`)
    })

    it("account2 receives erc20 payments", async function () {
        await MinterFacet.mintPiece();
        const paymentSplitterOf2 = await RegisterFacet.paymentSplitter(owner2.address);
        let PaymentSplitter = (await ethers.getContractAt('PaymentSplitter', paymentSplitterOf2));
        PaymentSplitter = await PaymentSplitter.connect(owner2);
        console.log(`Balance of account 2 before release tx: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`)
        await DragonStonePieces.transfer(paymentSplitterOf2, ethers.utils.parseEther('10'))
        console.log(`PaymentSplitter has ${await DragonStonePieces.balanceOf(paymentSplitterOf2) / 1e18} piece`);
        console.log(`PaymentSplitter has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner2.address) / 1e18} pieces available to release for owner 2`)
        console.log(`Releasing ERC20 payment of ${owner2.address}`);
        await PaymentSplitter['release(address,address)']?.(DragonStonePieces.address, owner2.address);
        console.log(`Balance of account 2 after release tx: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`)
        console.log(`Owner2 has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner2.address) / 1e18} pieces left to release`)
    })

    it("account2 receives erc20 payments again", async function () {
        const paymentSplitterOf2 = await RegisterFacet.paymentSplitter(owner2.address);
        let PaymentSplitter = (await ethers.getContractAt('PaymentSplitter', paymentSplitterOf2));
        PaymentSplitter = await PaymentSplitter.connect(owner2);
        console.log(` Balance of account 2 before release tx: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`)
        await DragonStonePieces.transfer(paymentSplitterOf2, ethers.utils.parseEther('10'))
        console.log(`PaymentSplitter has ${await DragonStonePieces.balanceOf(paymentSplitterOf2) / 1e18} piece`);
        console.log(`PaymentSplitter has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner2.address) / 1e18} pieces available to release for owner2`)
        console.log(`Releasing ERC20 payment of ${owner2.address}`);
        await PaymentSplitter['release(address,address)']?.(DragonStonePieces.address, owner2.address);
        console.log(`Balance of account 2 after release tx: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`)
        console.log(`Owner2 has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner2.address) / 1e18} pieces left to release`)
    })

    it("account1 receives erc20 payments too! amazing", async function () {
        const paymentSplitterOf2 = await RegisterFacet.paymentSplitter(owner2.address);
        let PaymentSplitter = (await ethers.getContractAt('PaymentSplitter', paymentSplitterOf2));
        PaymentSplitter = await PaymentSplitter.connect(owner);
        console.log(`PaymentSplitter has ${await DragonStonePieces.balanceOf(paymentSplitterOf2) / 1e18} piece`);
        console.log(`PaymentSplitter has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner.address) / 1e18} pieces available to release for owner1`)
        console.log(`Releasing ERC20 payment of ${owner.address}`);
        await PaymentSplitter['release(address,address)']?.(DragonStonePieces.address, owner.address);
        console.log(`Balance of account 2 after release tx: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`)
        console.log(`Owner has ${await PaymentSplitter['releasable(address,address)']?.(DragonStonePieces.address, owner.address) / 1e18} pieces left to release`)
        console.log(`PaymentSplitter has final balance of ${await DragonStonePieces.balanceOf(paymentSplitterOf2) / 1e18} piece`);
        console.log(`Balance of account1 after release tx: ${await DragonStonePieces.balanceOf(owner.address) / 1e18}`)
        console.log(`Balance of account2 after release tx: ${await DragonStonePieces.balanceOf(owner2.address) / 1e18}`)
    })
})
