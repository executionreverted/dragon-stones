const CHAIN_ID = require("../constants/chainIds.json")

module.exports = async function (taskArgs, hre) {
    const signers = await ethers.getSigners()
    const owner = signers[0]
    const toAddress = owner.address;
    const tokenIds = JSON.parse(taskArgs.tokenIds)
    // get remote chain id
    const remoteChainId = CHAIN_ID[taskArgs.targetNetwork]

    // get local contract
    const onft = await ethers.getContract(taskArgs.contract)

    // quote fee with default adapterParams
    const adapterParams = ethers.utils.solidityPack(["uint16", "uint256"], [1, Math.max(300000 * tokenIds.length + 1, 300000)]) // default adapterParams example

    const fees = await onft.estimateSendBatchFee(remoteChainId, toAddress, tokenIds, false, adapterParams)
    const nativeFee = fees[0]
    console.log(`native fees (wei): ${nativeFee}`)

    const tx = await onft.sendBatchFrom(
        owner.address,                  // 'from' address to send tokens
        remoteChainId,                  // remote LayerZero chainId
        toAddress,                      // 'to' address to send tokens
        tokenIds,                        // tokenId to send
        owner.address,                  // refund address (if too much message fee is sent, it gets refunded)
        ethers.constants.AddressZero,   // address(0x0) if not paying in ZRO (LayerZero Token)
        adapterParams,                  // flexible bytes array to indicate messaging adapter services
        { value: nativeFee.mul(5).div(4) }
    )
    console.log(`✅ [${hre.network.name}] sendFrom tx: ${tx.hash}`)
    await tx.wait()
}
