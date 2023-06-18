
const CHAIN_ID = require("../constants/chainIds.json")

module.exports = async function (taskArgs, hre) {
    const contract = await ethers.getContract(taskArgs.contract)
    let tx
    tx = await contract.setMinGasToTransferAndStore(taskArgs.minGas)
    console.log(`[${hre.network.name}] setMinDstGas tx hash ${tx.hash}`)
    await tx.wait(1)
}