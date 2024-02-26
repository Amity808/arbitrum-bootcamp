const hre = require("hardhat");

async function main() {

  const ContractFactory = await hre.ethers.getContractFactory("Uniswap");
const secondToken = '0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2' //WETh
const firstToken = '0x6B175474E89094C44Da98b954EedeAC495271d0F' //DAI
const swapRouter = '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45'
  const contract = await ContractFactory.deploy(swapRouter, firstToken, secondToken);


  console.log("Contract deployed to:", contract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
