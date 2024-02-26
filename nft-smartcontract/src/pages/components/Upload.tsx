import React, { useState } from 'react';
import { NFTStorage } from 'nft.storage';
import NFTABi from "@/utills/contract/nftabi.json";
import { useWriteContract, useSimulateContract, useAccount } from 'wagmi'; 
import {config} from "@/utills/config"
type Props = {};

const client = new NFTStorage({ token: process.env.NEXT_PUBLIC_NFT_KEY ?? "" });
const Upload = (props: Props) => {
  const { address } = useAccount();
  const { writeContractAsync, error: writeError } = useWriteContract({
    config
  });

  const [URlData, setURlData] = useState('')
  const [formData, setFormData] = useState<{ image: BlobPart | null; name: string; description: string }>({
    name: '',
    description: '',
    image: null,
  });

  // function to update the form data
  const updateFormField = (field: keyof typeof formData, value: any) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  // const useContractSimulate = (url: any) => {
  //   const { data: simulateMint } = useSimulateContract({
  //     abi: NFTABi.abi,
  //     functionName: "safemint",
  //     args: ["0x9dBa18e9b96b905919cC828C399d313EfD55D800", "https://ipfs.io/ipfs/bafyreieop4h3lj4n5rjufl6zhrecr2yrscc2iqs7eptlzd3qvbpomtdlsi/metadata.json"]
  //   });
  //   console.log(address)
  //   return simulateMint;
  // };

  const uploadToNFtStorage = async () => {
    if (!formData.image || !formData.description || !formData.name) {
      return;
    }

    try {
      const imageFile = new File([formData.image], 'metadata-image', { type: 'image/png' });
      const metadata = await client.store({
        name: formData.name,
        description: formData.description,
        image: imageFile
      });

      console.log(metadata.ipnft);
      const ipfsurl = await metadata.ipnft;
      // IPFS url for upload metadata
      const url = `https://ipfs.io/ipfs/${ipfsurl}/metadata.json`;
      setURlData(url)
      return url;
    } catch (error) {
      console.log(error);
    }
  };
  // const simulateMint = useContractSimulate(URlData);
  console.log(URlData);

  const { data: simulateMint, error: simulateError } = useSimulateContract({
    abi: NFTABi.abi,
    functionName: "safeMint",
    address: NFTABi.address as `0x${string}`,
    args: ["0x9dBa18e9b96b905919cC828C399d313EfD55D800", "https://ipfs.io/ipfs/bafyreieop4h3lj4n5rjufl6zhrecr2yrscc2iqs7eptlzd3qvbpomtdlsi/metadata.json"]
  });
  console.log(simulateError)
  
  

  const mintnfttab = async () => {
    if (!simulateMint?.request) {
      return alert("error from the simulator");
    }   
    // const result = await uploadToNFtStorage();
    // console.log(result);
 
    console.log(address)
    // return simulateMint;
    
    // if (simulateMint) {
      try {
        // if(simulateMint!.request){
          const sendMint = await writeContractAsync(simulateMint!.request);
          console.log(sendMint);
        // }
      } catch (error) {
        console.log(error);
        
      }
    // }
  };


  const mintnft = async (e: any) => {
    e.preventDefault();
    await mintnfttab()
    
  };

  return  (
    <div>
      <form action="" onSubmit={mintnft}>
      <input
        type="file"
        accept="image/png, image/jpeg"
        onChange={(event) => {
          updateFormField('image', event.target.files?.[0]);
        }}
      />
      <div>
        <input
          type="text"
          className="text-black"
          placeholder="Enter name"
          value={formData.name}
          onChange={(event) => {
            updateFormField('name', event.target.value);
          }}
        />
      </div>
      <div className="my-4">
        <input
          placeholder="Enter Description"
          type="text"
          className="text-black"
          value={formData.description}
          onChange={(event) => {
            updateFormField('description', event.target.value);
          }}
        />
      </div>
      <div>
        <button className="bg-blue-400" type='submit'>
          Upload file
        </button>
      </div>

      </form>
        <button onClick={mintnfttab} className="bg-blue-400" type='submit'>
          Mint
        </button>
    </div>
  )
};

export default Upload;
