module.exports = async function (taskArgs, hre) {
    const ERC721 = await ethers.getContract("HatchyPocketMock")
    const HatchyPocketONFTProxy = await ethers.getContract("HatchyPocketONFTProxy")
    let tx = await (await ERC721.setApprovalForAll(HatchyPocketONFTProxy.address, true)).wait()
    console.log(`setApprovalForAll tx: ${tx.transactionHash}`)
}