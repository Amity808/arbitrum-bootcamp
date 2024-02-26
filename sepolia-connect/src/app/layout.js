import { Inter } from "next/font/google";
import "./globals.css";
import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider } from '@rainbow-me/rainbowkit';
import { WagmiProvider } from 'wagmi';
import { arbitrumSepolia, arbitrumGoerli } from 'wagmi/chains';
import { getDefaultConfig } from '@rainbow-me/rainbowkit';
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';


const inter = Inter({ subsets: ["latin"] });

export const metadata = {
  title: "Create Next App",
  description: "Generated by create next app",
};



export default function RootLayout({ children }) {
  const config = getDefaultConfig({
    appName: 'My RainbowKit App',
    projectId: 'YOUR_PROJECT_ID',
    chains: [arbitrumSepolia],
    // ssr: true,  If your dApp uses server side rendering (SSR)
  })
  
  const queryClient = new QueryClient();

  return (
    <html lang="en">
      <body className={inter.className}>
      <WagmiProvider config={config}>
			<QueryClientProvider client={queryClient}>
				<RainbowKitProvider>	
        {children}
				</RainbowKitProvider>
			</QueryClientProvider>
		</WagmiProvider>
      </body>
    </html>
  );
}