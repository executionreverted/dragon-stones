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

module.exports = async (taskArgs, hre) => {
    const facetName = taskArgs.facet
    console.log(taskArgs.addSelectors);
    console.log(taskArgs.removeSelectors);
    let addSelectors = taskArgs.addSelectors.split('$$$') || []
    let removeSelectors = taskArgs.removeSelectors.split('$$$') || [];
    const deployInit = Boolean(taskArgs.deployInit);
    const { deployer } = await hre.getNamedAccounts()
    //Instantiate the Signer

    const dia = await hre.ethers.getContract(
        "Diamond"
    )

    //Create the cut
    const cut = [];
    let deployedFacet
    try {
        deployedFacet = await ethers.getContract(facetName)

    } catch (error) {
        await hre.run('deploy', {
            'tags': facetName
        })
        deployedFacet = await ethers.getContract(facetName)
    }

    console.log(
        `Current Deployed Facet Address for ${facetName}:`,
        deployedFacet.address
    );

    const newSelectors = getSighashes(addSelectors, hre.ethers);
    console.log('newSelectors');
    console.log(newSelectors);
    removeSelectors = getSighashes(removeSelectors, hre.ethers);
    console.log('removeSelectors');
    console.log(removeSelectors);
    let existingSelectors = getSelectors(deployedFacet);
    existingSelectors = existingSelectors.filter(
        (selector) => !newSelectors.includes(selector)
    );

    await hre.run('deploy', {
        'tags': facetName
    })
    const newDeployedFacet = await ethers.getContract(facetName)
    let existingSelectors$ = getSelectors(newDeployedFacet);

    for (const selector of newSelectors) {
        if (!existingSelectors$.includes(selector)) {
            const index = newSelectors.findIndex((val) => val == selector);
            throw Error(
                `Selector ${selector} (${addSelectors[index]}) not found in new contract`
            );
        }
    }


    console.log('deploying new facet.');
    await hre.run('deploy', {
        'tags': facetName
    })


    if (newSelectors.length > 0) {
        cut.push({
            facetAddress: newDeployedFacet.address,
            action: FacetCutAction.Add,
            functionSelectors: newSelectors,
        });
    }




    console.log(
        `New Deployed Facet Address for ${facetName}:`,
        newDeployedFacet.address
    );


    if (existingSelectors.length > 0) {
        cut.push({
            facetAddress: newDeployedFacet.address,
            action: FacetCutAction.Replace,
            functionSelectors: existingSelectors.filter(s => removeSelectors.indexOf(s) == -1),
        });
    }

    //replace only when not using on newly deplyed diamonds
    console.log('existingSelectors');
    console.log(existingSelectors);
    console.log('newSelectors');
    console.log(addSelectors);
    console.log('removeSelectors');
    console.log(removeSelectors);
    if (removeSelectors.length > 0) {
        console.log("Removing selectors:", removeSelectors);
        cut.push({
            facetAddress: hre.ethers.constants.AddressZero,
            action: FacetCutAction.Remove,
            functionSelectors: removeSelectors
        });
    }
    console.log('cut');
    console.log(cut);
    //Execute the Cut

    const diamondCut = (await hre.ethers.getContractAt(
        "IDiamondCut",
        dia.address
    ));


    let initAddress;
    let functionCall
    if (deployInit) {
        // call to init function
        let diaInit = await hre.deployments.deploy('DiamondDappInit', {
            from: deployer,
            args: [],
            log: true,
            waitConfirmations: 1,
        })
        let diamondInit = await ethers.getContractAt("DiamondDappInit", diaInit.address)
        initAddress = diamondInit.address;
        let functionCall = diamondInit.interface.encodeFunctionData('init', [ethers.constants.AddressZero, "dragonstones.com/api/", DragonStonePieces.address, DragonStoneBlessing.address])
    }
    //Choose to use a multisig or a simple deploy address
    const tx = await diamondCut.diamondCut(
        cut,
        initAddress ? initAddress : hre.ethers.constants.AddressZero,
        functionCall ? functionCall : "0x",
        {
            gasPrice: gasPrice,
        }
    );

    const receipt = await tx.wait();
    if (!receipt.status) {
        throw Error(`Diamond upgrade failed: ${tx.hash}`);
    }
    console.log("Completed diamond cut: ", tx.hash);
}