const {
    gasPrice,
    getSelectors,
    getSelector
} = require("../deploy/helpers");

const FacetCutAction = { Add: 0, Replace: 1, Remove: 2 };

function getSighashes(selectors, ethers) {
    if (selectors.length === 0) return [];
    const sighashes = [];
    selectors.forEach((selector) => {
        if (selector !== "") sighashes.push(getSelector(selector, ethers));
    });
    return sighashes;
}

module.exports = async (taskArgs, { deployments, getNamedAccounts }) => {
    //Instantiate the Signer
    const { facet } = taskArgs
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()

    // uncomment for testing on local to deploy first
    if (network.name == 'hardhat') {
        let deployed = await deployments.run(['DiamondApp'])
    }
    
    const dia = await hre.ethers.getContract(
        "Diamond"
    )

    //Create the cut
    const cut = [];
    await deploy(facet, {
        from: deployer,
        args: [],
        log: true,
        waitConfirmations: 1,
    })
    const newDeployedFacet = await ethers.getContract(facet)


    console.log('newSelectors');
    let selectors = getSelectors(newDeployedFacet);


    console.log('deploying new facet.');


    console.log(
        `New Deployed Facet Address for ${facet}:`,
        newDeployedFacet.address
    );


    //Execute the Cut

    const diamondCut = (await hre.ethers.getContractAt(
        "IDiamondCut",
        dia.address
    ));

    if (selectors.length > 0) {
        cut.push({
            facetAddress: newDeployedFacet.address,
            action: FacetCutAction.Add,
            functionSelectors: selectors,
        });
    }

    //Choose to use a multisig or a simple deploy address
    const tx = await diamondCut.diamondCut(
        cut,
        hre.ethers.constants.AddressZero,
        "0x",
        {
            gasPrice: gasPrice,
        }
    );



    //replace only when not using on newly deplyed diamonds

    console.log('cut');
    console.log(cut);
    
    const receipt = await tx.wait();
    if (!receipt.status) {
        throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    // console.log("Completed diamond cut: ", tx.hash);
    // // console.log('_______________');
    // const TestFacetV3 = await ethers.getContractAt(facet, dia.address)
    // console.log('pre');
    // console.log(`${await TestFacetV3.test3(123)}`);
    // console.log('post');
    // console.log(`${await TestFacetV2.test2(1, "testing.")}`);
}