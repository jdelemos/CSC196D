let web3;
let contract;
const contractAddress = "PASTE_DEPLOYED_CONTRACT_ADDRESS_HERE";
const abi = [/* ABI FROM COMPILED CONTRACT */];

window.addEventListener('load', async () => {
  if (window.ethereum) {
    web3 = new Web3(window.ethereum);
    await ethereum.request({ method: "eth_requestAccounts" });

    contract = new web3.eth.Contract(abi, contractAddress);

    document.getElementById("allocate").onclick = async () => {
      const accounts = await web3.eth.getAccounts();
      const recipient = document.getElementById("recipient").value;
      await contract.methods.allocateTokens(recipient).send({ from: accounts[0] });
      alert("Tokens allocated!");
    };

    document.getElementById("transfer").onclick = async () => {
      const accounts = await web3.eth.getAccounts();
      const to = document.getElementById("to").value;
      const amount = web3.utils.toWei(document.getElementById("amount").value, 'ether');
      await contract.methods.transfer(to, amount).send({ from: accounts[0] });
      alert("Tokens transferred!");
    };
  }
});