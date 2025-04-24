module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Ganache local server
      port: 7545,            // Ganache's default port
      network_id: "*"        // Match any network ID
    }
  },

  mocha: {
    // timeout: 100000
  },

  compilers: {
    solc: {
      version: "0.8.0"      // Match your contract version
    }
  }

  // If you want to use Truffle DB, uncomment the below
  // db: {
  //   enabled: false
  // }
};
