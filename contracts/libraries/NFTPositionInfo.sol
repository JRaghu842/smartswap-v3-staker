// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity =0.7.6;

import 'smartswap-v3-periphery/contracts/interfaces/INonfungiblePositionManager.sol';
import 'smartswap-v3-core/contracts/interfaces/ISmartSwapFactory.sol';
import 'smartswap-v3-core/contracts/interfaces/ISmartSwapPool.sol';

import 'smartswap-v3-periphery/contracts/libraries/PoolAddress.sol';

/// @notice Encapsulates the logic for getting info about a NFT token ID
library NFTPositionInfo {
    /// @param factory The address of the SmartSwap Factory used in computing the pool address
    /// @param nonfungiblePositionManager The address of the nonfungible position manager to query
    /// @param tokenId The unique identifier of an SmartSwap LP token
    /// @return pool The address of the SmartSwap pool
    /// @return tickLower The lower tick of the SmartSwap position
    /// @return tickUpper The upper tick of the SmartSwap position
    /// @return liquidity The amount of liquidity staked
    function getPositionInfo(
        ISmartSwapFactory factory,
        INonfungiblePositionManager nonfungiblePositionManager,
        uint256 tokenId
    )
        internal
        view
        returns (
            ISmartSwapPool pool,
            int24 tickLower,
            int24 tickUpper,
            uint128 liquidity
        )
    {
        address token0;
        address token1;
        uint24 fee;
        (, , token0, token1, fee, tickLower, tickUpper, liquidity, , , , ) = nonfungiblePositionManager.positions(
            tokenId
        );

        pool = ISmartSwapPool(
            PoolAddress.computeAddress(
                address(factory),
                PoolAddress.PoolKey({token0: token0, token1: token1, fee: fee})
            )
        );
    }
}
