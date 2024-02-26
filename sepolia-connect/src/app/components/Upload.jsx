"use client"
import React, { useState } from 'react';
import { NFTStorage } from 'nft.storage';
import NFTABi from "@/app/utils/nftabi.json";
import { useWriteContract, useSimulateContract, useAccount } from 'wagmi'; 

// type Props = {};

const client = new NFTStorage({ token: process.env.NEXT_PUBLIC_NFT_KEY ?? "" });
const Upload = (props) => {
  const { address } = useAccount();
  const { writeContractAsync } = useWriteContract();

  const [URlData, setURlData] = useState('')
  const [formData, setFormData] = useState<{ image: BlobPart, name, description}>({
    name: '',
    description: '',
    image: null,
  });

  // function to update the form data
  const updateFormField = (field, value) => {
    setFormData((prev) => ({ ...prev, [field]: value }));
  };

  const useContractSimulate = async () => {
    const { data: simulateMint } = await useSimulateContract({
      abi: NFTABi.abi,
      functionName: "safemint",
      args: [address, "https://ipfs.io/ipfs/bafyreieop4h3lj4n5rjufl6zhrecr2yrscc2iqs7eptlzd3qvbpomtdlsi/metadata.json"]
    });
    console.log(address)
    return simulateMint;
  };

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
  const simulateMint = useContractSimulate(URlData);
  console.log(URlData);
  

  const mintnfttab = async () => {
    
    // const result = await uploadToNFtStorage();
    // console.log(result);
    
    // if (result) {
      const sendMint =  writeContractAsync(simulateMint?.request);
      console.log(sendMint);
    // }
  };


  const mintnft = async (e) => {
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
        <button onClick={mintnfttab} className="bg-blue-400" type='submit'>
          Mint
        </button>
      </div>

      </form>
    </div>
  )
};

export default Upload;
