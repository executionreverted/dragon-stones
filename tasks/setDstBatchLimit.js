const CHAIN_ID = require("../constants/chainIds.json")

module.exports = async function (taskArgs, hre) {
	const contract = await ethers.getContract(taskArgs.contract)
	const dstChainId = CHAIN_ID[taskArgs.targetNetwork]
	let tx = await contract.setDstChainIdToBatchLimit(dstChainId, taskArgs.limit)

	console.log(`[${hre.network.name}] setDstChainIdToBatchLimit tx hash ${tx.hash}`)
	await tx.wait(1)

}