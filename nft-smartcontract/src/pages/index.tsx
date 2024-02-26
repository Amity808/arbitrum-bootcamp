import { Inter } from 'next/font/google';
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount } from 'wagmi'
import { NFTStorage, File } from 'nft.storage'
import NFTAbi from "@/utills/contract/nftabi.json";
import Upload from './components/Upload';


type Params = {
	token: String,
	data: String,
	name: String

}

const nftStorage = new NFTStorage({ token: process.env.NEXT_PUBLIC_NFTSTORAGE_API_KEY ?? "" })

const inter = Inter({ subsets: ['latin'] });

export default function Home() {

	const converObjectToFile = (data: Params) => {
		const blob = new Blob([JSON.stringify(data)], {type: "application/json"})
		const files = [new File([blob], `${data.name}.json`)];
		return files;
	}


const { isConnected } = useAccount()
	return (
		<main className={`flex min-h-screen flex-col items-center justify-between p-24 ${inter.className}`}>
			<ConnectButton />
			<Upload />
			{/* {isConnected ?  */}
			<h2>Connected to Arbitrum Goerli</h2> :
			<h2> Click Connect Wallet to Connect to Arbitrum Goerli</h2>
			
		{/* } */}
		</main>
	);
}
