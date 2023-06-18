module.exports = async function (taskArgs, hre) {
    const AnyswapMPC = {
        "shimmer-testnet": "",
        "fuji": "",
        "bsc-testnet": "0xD2b88BA56891d43fB7c108F23FE6f92FEbD32045",
        "fantom-testnet": "0xc629d02732EE932db1fa83E1fcF93aE34aBFc96B"
    }

    let signers = await ethers.getSigners()
    let owner = signers[0]
    let toAddress = owner.address;
    let qty = ethers.utils.parseEther(taskArgs.qty)

    const remoteChainId = taskArgs.chainId

    // get local contract
    const HatchyAnyswap = await ethers.getContract('HatchyAnyswap')
    const localContractInstance = await ethers.getContract('HatchyTokenAnycallClient')
    /* bytes memory data = abi.encode(msg.sender, amount);
            return IAnyCallProxy(anyCallProxy).calcSrcFees("", chainId, data.length); */

    const data = await ethers.utils.solidityPack(['address', 'uint'], [owner.address, 42])
    const anyCallProxy = await ethers.getContractAt('IAnyCallProxy', AnyswapMPC[hre.network.name])
    let fees = await anyCallProxy.calcSrcFees("", remoteChainId, data.length)
    console.log(`Fees: ${fees}`);


    let tx
    //swapout(address token, uint256 amount, address receiver, uint256 toChainId, uint256 flags) external payable whenNotPaused(PAUSE_SWAPOUT_ROLE) {
    // enable if u need tokens
    // tx = await (await HatchyAnyswap.mint(owner.address, ethers.utils.parseEther('42'))).wait(2)
    tx = await (
        await localContractInstance.swapout(
            HatchyAnyswap.address,         // 'from' address to send tokens
            qty,
            owner.address,                     // 'to' address to send tokens
            remoteChainId,
            2,
            { value: fees.mul(5) }
        )
    ).wait(1)
    console.log(`✅ Message Sent [${hre.network.name}] swapout() chainId[${remoteChainId}] token:[${toAddress}]`)
    console.log(` tx: ${tx.transactionHash}`)
    console.log(`* check your address [${owner.address}] on the destination chain, in the ERC20 transaction tab !"`)
}
