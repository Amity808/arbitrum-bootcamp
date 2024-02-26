import { useWriteContract, useSimulateContract, useAccount } from 'wagmi'; 
import NFTABi from "@/utills/contract/nftabi.json";

export const ContractSimulate = (url: any) => {
    const { address } = useAccount()
    if (!address) {
      console.error("Address is undefined");
      return null;
    }

    const { data: simulateMint } = useSimulateContract({
      abi: NFTABi.abi,
      functionName: "safemint",
      args: [address, url]
    });

    return simulateMint;
    
  };