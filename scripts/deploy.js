// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.

const hre = require("hardhat");
const { PUBLIC_KEY_OWNER } = require("../constants");

async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

async function main() {
  const initial_owner = PUBLIC_KEY_OWNER;
  const nftContract = await hre.ethers.deployContract("FlappyBird", [
    initial_owner,
  ]);

  // wait for the contract to deploy
  await nftContract.waitForDeployment();

  // print the address of the deployed contract
  console.log("NFT Contract Address:", nftContract.target);

  // Sleep for 30 seconds while Etherscan indexes the new contract deployment
  await sleep(30 * 1000); // 30s = 30 * 1000 milliseconds

  // Verify the contract on etherscan
  await hre.run("verify:verify", {
    address: nftContract.target,
    constructorArguments: [initial_owner],
  });
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
// const hre = require("hardhat");
// require("dotenv").config({ path: ".env" });
// const { PUBLIC_KEY_OWNER } = require("../constants");

// async function main() {
//   const initial_owner = PUBLIC_KEY_OWNER;
//   const cryptoDevsContract = await ethers.getContractFactory("FlappyBird");

//   // deploy the contract
//   const deployedCryptoDevsContract = await cryptoDevsContract.deploy(
//     initial_owner
//   );

//   // Wait for it to finish deploying
//   await deployedCryptoDevsContract.deployed();

//   // print the address of the deployed contract
//   console.log(
//     "NFT Contract Address:",
//     deployedCryptoDevsContract.address
//   );
// }

// // We recommend this pattern to be able to use async/await everywhere
// // and properly handle errors.
// main().catch((error) => {
//   console.error(error);
//   process.exitCode = 1;
// });
