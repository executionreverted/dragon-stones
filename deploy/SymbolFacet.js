const { ethers, network } = require('hardhat')
const { FacetCutAction, } = require('./helpers')
const LZEndpoints = require('../constants/layerzeroEndpoints.json')

module.exports = async function ({ deployments, getNamedAccounts }) {
    const { deploy, taskArgs } = deployments
    const { deployer } = await getNamedAccounts()
    console.log(`>>> your address: ${deployer}`)

    console.log('deploy facets..');
    await deploy("SymbolFacet", {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: 1,
    })
}

module.exports.tags = ["SymbolFacet"]
// module.exports.dependencies = FacetNames
