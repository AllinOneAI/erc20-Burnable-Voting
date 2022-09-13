
const HDWalletProvider = require('@truffle/hdwallet-provider');    
const Mnemonic = process.env.WALLET_MNEMONIC;
module.exports = {

  networks: {
     development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 7545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
     },
    
     goerli: {
      network_id: "5",
      gasPrice: 10,
      provider: new HDWalletProvider({
        mnemonic: Mnemonic,
        providerOrUrl: "https://goerli.infura.io/v3/67d27f10fa6d4dcdb7575f9ee8df4f5c",
      })
    } 
      
  },

  mocha: {
  },

  compilers: {
    solc: {
      version: "0.8.16",      // Fetch exact version from solc-bin (default: truffle's version)
    }
  },

};
