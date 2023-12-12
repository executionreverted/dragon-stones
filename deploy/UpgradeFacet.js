const { ethers, network } = require('hardhat')
const { FacetCutAction, } = require('./helpers')
const LZEndpoints = require('../constants/layerzeroEndpoints.json')

module.exports = async function ({ deployments, getNamedAccounts }) {
    const { deploy, taskArgs } = deployments
    const { deployer } = await getNamedAccounts()
    console.log(`>>> your address: ${deployer}`)
    console.log('deploy facets..');
    console.log(taskArgs);
}

module.exports.tags = ["UpgradeFacet"]
// module.exports.dependencies = FacetNames
