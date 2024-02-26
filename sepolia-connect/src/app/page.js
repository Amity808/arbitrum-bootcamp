import Image from "next/image";
import { NFTStorage, File } from 'nft.storage'
import { ConnectButton } from '@rainbow-me/rainbowkit';
import Upload from "./components/Upload";

export default function Home() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-between p-24">
      <Upload />
    </main>
  );
}
