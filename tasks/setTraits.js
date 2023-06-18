
module.exports = async function (taskArgs, hre) {
    const pfp = await ethers.getContract("SummonersPFP")
    let tx = await (await pfp.setTraits(taskArgs.tokenId, [4, 5, 6, 7, 8])).wait(1)
    console.log(`setTraits tx: ${tx.transactionHash}`)
}