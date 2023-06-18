const CHAIN_IDS = require("../constants/chainIds.json")
const ENDPOINTS = require("../constants/layerzeroEndpoints.json")

module.exports = async function (taskArgs, hre) {
    const signers = await ethers.getSigners()
    const owner = signers[0]
    const onft1155 = await ethers.getContract(taskArgs.contract)
    let tx = await (await onft1155.setUseCustomAdapterParams(Boolean(taskArgs.val))).wait(1)
    console.log(`send tx: ${tx.transactionHash}`)
}
