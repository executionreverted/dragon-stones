const chainIds = {
    'bsc-testnet': 97,
    'fantom-testnet': 4002
}
const { getDeploymentAddresses } = require("../utils/readStatic")

module.exports = async function (taskArgs, hre) {
    let signers = await ethers.getSigners()
    const targetChainId = chainIds[taskArgs.targetNetwork];
    const remoteAddress = getDeploymentAddresses(taskArgs.targetNetwork)['HatchyTokenAnycallClient']
    const remoteTokenAddress = getDeploymentAddresses(taskArgs.targetNetwork)['HatchyAnyswap']

    const client = await ethers.getContract('HatchyTokenAnycallClient')
    const token = await ethers.getContract('HatchyAnyswap')

    // function setClientPeers(uint256[] calldata _chainIds, address[] calldata _peers) external onlyAdmin {

    console.log([targetChainId], [remoteAddress]);
    let tx = await client.setClientPeers([targetChainId], [remoteAddress])
    tx = await tx.wait(2)
    console.log('setClientPeers set.');

    // function setTokenPeers(address srcToken, uint256[] calldata chainIds, address[] calldata dstTokens) external onlyAdmin {
    console.log(token.address, [targetChainId], [remoteTokenAddress]);
    tx = await client.setTokenPeers(token.address, [targetChainId], [remoteTokenAddress])
    tx = await tx.wait(1)
    console.log('setTokenPeers set.');
}
