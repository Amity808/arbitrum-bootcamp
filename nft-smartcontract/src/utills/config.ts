import { http, createConfig } from 'wagmi'
import { mainnet, arbitrumGoerli } from 'wagmi/chains'

export const config = createConfig({
  chains: [arbitrumGoerli],
  transports: {
    // [mainnet.id]: http(),
    [arbitrumGoerli.id]: http(),
  },
})