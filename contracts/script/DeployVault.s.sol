// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Script, console } from "forge-std/Script.sol";
import { Vault } from "../src/Vault.sol";

contract DeployVault is Script {
    // ============ Configuration ============
    // These can be overridden via environment variables
    
    // Default values (for testing)
    address public constant DEFAULT_ASSET = address(0); // Must be set per chain
    uint256 public constant DEFAULT_BASE_RATE = 200; // 2% base APY
    uint256 public constant DEFAULT_SLOPE = 2000; // 20% max slope
    uint256 public constant DEFAULT_OPTIMAL_DEPOSITS = 1_000_000 * 1e18; // 1M tokens

    function run() external returns (Vault vault) {
        // Get deployer private key from env
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        // Get config from env or use defaults
        address asset = vm.envOr("ASSET_ADDRESS", DEFAULT_ASSET);
        uint256 baseRate = vm.envOr("BASE_RATE", DEFAULT_BASE_RATE);
        uint256 slope = vm.envOr("SLOPE", DEFAULT_SLOPE);
        uint256 optimalDeposits = vm.envOr("OPTIMAL_DEPOSITS", DEFAULT_OPTIMAL_DEPOSITS);

        require(asset != address(0), "DeployVault: Asset address not set");

        console.log("============ Deploying Vault ============");
        console.log("Deployer:", deployer);
        console.log("Asset:", asset);
        console.log("Base Rate (BPS):", baseRate);
        console.log("Slope (BPS):", slope);
        console.log("Optimal Deposits:", optimalDeposits);

        vm.startBroadcast(deployerPrivateKey);

        vault = new Vault(
            deployer,      // initialOwner
            asset,         // _asset
            baseRate,      // _baseRate
            slope,         // _slope
            optimalDeposits // _optimalDeposits
        );

        vm.stopBroadcast();

        console.log("============ Deployment Complete ============");
        console.log("Vault deployed at:", address(vault));

        return vault;
    }

    /**
     * @notice Deploy to specific chain with predefined config
     * @dev Use: forge script script/DeployVault.s.sol:DeployVault --sig "deployToSepolia()" --rpc-url $SEPOLIA_RPC --broadcast
     */
    function deployToSepolia() external returns (Vault) {
        // Sepolia USDC (or your test token)
        vm.setEnv("ASSET_ADDRESS", vm.toString(address(0x1c7D4B196Cb0C7B01d743Fbc6116a902379C7238))); // Circle USDC on Sepolia
        return this.run();
    }

    function deployToBaseSepolia() external returns (Vault) {
        // Base Sepolia USDC
        vm.setEnv("ASSET_ADDRESS", vm.toString(address(0x036CbD53842c5426634e7929541eC2318f3dCF7e))); // USDC on Base Sepolia
        return this.run();
    }

    function deployToArbitrumSepolia() external returns (Vault) {
        // Arbitrum Sepolia USDC
        vm.setEnv("ASSET_ADDRESS", vm.toString(address(0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d))); // USDC on Arb Sepolia
        return this.run();
    }

    function deployToHederaTestnet() external returns (Vault) {
        // Hedera Testnet - you'll need to set correct token address
        vm.setEnv("ASSET_ADDRESS", vm.toString(address(0x0000000000000000000000000000000000000000))); // Update with Hedera token
        return this.run();
    }
}
