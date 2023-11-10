const Web3 = require('web3');

// Connect to a local Ethereum node (you can replace this URL with your own Ethereum node)
const web3 = new Web3('http://localhost:8545');

// Replace with your contract address and ABI
const contractAddress = 'YOUR_CONTRACT_ADDRESS';
const contractABI = [
  // Replace with your contract's ABI (Application Binary Interface)
  // ...

  // Example ABI for some common ERC20 functions
  {
    "constant": true,
    "inputs": [{"name": "_owner", "type": "address"}, {"name": "_spender", "type": "address"}],
    "name": "allowanceOf",
    "outputs": [{"name": "remaining", "type": "uint256"}],
    "type": "function"
  },
  {
    "constant": false,
    "inputs": [{"name": "_to", "type": "address"}, {"name": "_value", "type": "uint256"}],
    "name": "transfer",
    "outputs": [{"name": "success", "type": "bool"}],
    "type": "function"
  },
  // ...
];

const contract = new web3.eth.Contract(contractABI, contractAddress);

// Example: Get the balance of an address
async function getBalance(address) {
  const balance = await contract.methods.balanceOf(address).call();
  console.log(`Balance of ${address}: ${balance}`);
}

// Example: Transfer tokens
async function transferTokens(to, value) {
  const accounts = await web3.eth.getAccounts();
  const result = await contract.methods.transfer(to, value).send({ from: accounts[0] });
  console.log('Transfer result:', result);
}

// Call the functions as needed
getBalance('0x1234567890123456789012345678901234567890');
transferTokens('0x9876543210987654321098765432109876543210', 100);
