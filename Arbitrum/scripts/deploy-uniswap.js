const hre = require("hardhat");

async function main() {

  const ContractFactory = await hre.ethers.getContractFactory("UniswapV2Swap");

  const contract = await ContractFactory.deploy("0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D");


  console.log("Contract deployed to:", contract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
