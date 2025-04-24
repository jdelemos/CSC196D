// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract HealthcareStableCoin is ERC20, Ownable {
    struct MedicalTransaction {
        address patient;
        address provider;
        uint256 amount;
        string serviceType;
        uint256 timestamp;
    }

    mapping(address => bool) public approvedProviders;
    mapping(address => bool) public eligibleCitizens;
    mapping(address => MedicalTransaction[]) private _transactions;

    uint256 public annualAllowance = 1000 * 10 ** 18;

    constructor() ERC20("Healthcare Stable Coin", "HSC") {
        _mint(msg.sender, 1_000_000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
    _mint(to, amount);
}


    function addProvider(address provider) external onlyOwner {
        approvedProviders[provider] = true;
    }

    function removeProvider(address provider) external onlyOwner {
        approvedProviders[provider] = false;
    }

    function registerCitizen(address citizen) external onlyOwner {
        eligibleCitizens[citizen] = true;
    }

    function grantAllowance(address citizen) external onlyOwner {
        require(eligibleCitizens[citizen], "Not eligible");
        _mint(citizen, annualAllowance);
    }

    function viewWallet() public view returns (uint256) {
    return balanceOf(msg.sender);
}


    function emergencyGrant(address citizen, uint256 amount) external onlyOwner {
        _mint(citizen, amount);
    }

    function deductTokensFrom(address patient, uint256 amount, string memory serviceType) external {
        require(approvedProviders[msg.sender], "Unauthorized provider");
        _transfer(patient, msg.sender, amount);
        _recordTransaction(patient, msg.sender, amount, serviceType);
    }

    function _recordTransaction(address patient, address provider, uint256 amount, string memory serviceType) internal {
        _transactions[patient].push(MedicalTransaction({
            patient: patient,
            provider: provider,
            amount: amount,
            serviceType: serviceType,
            timestamp: block.timestamp
        }));
    }

    function getTransactions(address patient) external view returns (MedicalTransaction[] memory) {
        return _transactions[patient];
    }

    function averageCost(address patient) external view returns (uint256) {
        MedicalTransaction[] memory txs = _transactions[patient];
        if (txs.length == 0) return 0;
        uint256 total;
        for (uint i = 0; i < txs.length; i++) {
            total += txs[i].amount;
        }
        return total / txs.length;
    }

    function compareCost(string memory serviceType) external view returns (uint256 average) {
        uint256 total;
        uint256 count;
        for (uint i = 0; i < holders.length; i++) {
            MedicalTransaction[] memory txs = _transactions[holders[i]];
            for (uint j = 0; j < txs.length; j++) {
                if (keccak256(bytes(txs[j].serviceType)) == keccak256(bytes(serviceType))) {
                    total += txs[j].amount;
                    count++;
                }
            }
        }
        return count == 0 ? 0 : total / count;
    }

    address[] private holders;

    function _afterTokenTransfer(address from, address to, uint256) internal override {
        if (!_existsInHolders(to)) {
            holders.push(to);
        }
    }

    function _existsInHolders(address user) private view returns (bool) {
        for (uint i = 0; i < holders.length; i++) {
            if (holders[i] == user) return true;
        }
        return false;
    }
}