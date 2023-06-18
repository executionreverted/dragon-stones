
const CHAIN_ID = require("../constants/chainIds.json")

module.exports = async function (taskArgs, hre) {
    const signers = await ethers.getSigners()
    const owner = signers[0]
    const erc20 = await ethers.getContractAt("ERC20", taskArgs.contract)
    let tx = await erc20.increaseAllowance(taskArgs.operator, taskArgs.amount)
    await tx.wait(1)
}
