const CHAIN_IDS = require("../constants/chainIds.json")
const ENDPOINTS = require("../constants/layerzeroEndpoints.json")

module.exports = async function (taskArgs, hre) {
    const signers = await ethers.getSigners()
    const owner = signers[0]
    const onft1155 = await ethers.getContract(taskArgs.contract)
    const dstChainId = CHAIN_IDS[taskArgs.targetNetwork]

    const tokenIds = taskArgs.tokenIds.split(",")
    const quantities = taskArgs.quantities.split(",")
    console.log(tokenIds)
    console.log(quantities)

    const payload =
        "0x000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000014f39fd6e51aad88f6f4ce6ab8827279cfffb92266000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000001"
    const endpoint = await ethers.getContractAt("ILayerZeroEndpoint", ENDPOINTS[hre.network.name])
    // let fees = await endpoint.estimateFees(dstChainId, onft1155.address, payload, false, "0x")
    // (uint16 _dstChainId, bytes memory _toAddress, uint[] memory _tokenIds, uint[] memory _amounts, bool _useZro, bytes memory _adapterParams) public view virtual override returns (uint nativeFee, uint zroFee) {
    let fees = await onft1155.estimateSendBatchFee(dstChainId, owner.address, tokenIds, quantities, false, "0x")
    console.log(`fees[0] (wei): ${fees[0]}`)
    const adapterCost = tokenIds.length * 55000
    const adapterParams = ethers.utils.solidityPack(["uint16", "uint256"], [1, adapterCost]) // default adapterParams example

    let tx = await (
        await onft1155.sendBatchFrom(
            owner.address,
            dstChainId,
            owner.address,
            tokenIds, quantities, owner.address, ethers.constants.AddressZero, adapterParams, {
            value: fees[0].mul(5).div(4) + adapterCost,
        })
    ).wait()
    console.log(`send tx: ${tx.transactionHash}`)
}
