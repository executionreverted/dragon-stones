// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import {AppStorage} from "./libraries/LibAppStorage.sol";
import {LibMeta} from "../shared/libraries/LibMeta.sol";
import {LibDiamond} from "../shared/libraries/LibDiamond.sol";
import {IDiamondCut} from "../shared/interfaces/IDiamondCut.sol";
import {IDiamondLoupe} from "../shared/interfaces/IDiamondLoupe.sol";
import {IERC165} from "../shared/interfaces/IERC165.sol";
import {IERC721} from "../shared/interfaces/IERC721.sol";
import {IERC173} from "../shared/interfaces/IERC173.sol";
import {ILayerZeroEndpointUpgradeable} from "../contracts-upgradable/interfaces/ILayerZeroEndpointUpgradeable.sol";

contract DiamondDappInit {
    AppStorage internal s;

    function init(uint _minGasToTransferAndStore, address _endpoint) external {
        s.domainSeparator = LibMeta.domainSeparator("DiamondApp", "V1");
        LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
        // adding ERC165 data
        ds.supportedInterfaces[type(IERC721).interfaceId] = true;
        ds.supportedInterfaces[type(IERC165).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondCut).interfaceId] = true;
        ds.supportedInterfaces[type(IDiamondLoupe).interfaceId] = true;
        ds.supportedInterfaces[type(IERC173).interfaceId] = true;
        s.FUNCTION_TYPE_SEND = 1;
        s.minGasToTransferAndStore = _minGasToTransferAndStore;
        s.lzEndpoint = ILayerZeroEndpointUpgradeable(_endpoint);
    }
}
