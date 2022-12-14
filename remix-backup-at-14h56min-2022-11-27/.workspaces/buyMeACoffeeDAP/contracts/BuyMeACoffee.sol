// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// Deployed to Goerli at 0xa2825A11C2b4508540D13DC4C23cfd709f971C38

contract BuyMeACoffee {
    event newMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received
    Memo[] memos;

    // Address of contract deployer
    address payable public owner;
    uint256 public contractVault;

    // Run only when contract is deployed
    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev buy me a coffee for contract owner
     * @param _name name of the coffee buyer
     * @param _message a nice message from the coffee buyer
     */
    function buyCoffee(string memory _name, string memory _message)
        public
        payable
    {
        require(msg.value > 0, "Cannot buy a coffee with 0 eth");

        // Add memo to strorage
        memos.push(Memo(msg.sender, block.timestamp, _name, _message));

        emit newMemo(msg.sender, block.timestamp, _name, _message);

        contractVault += msg.value;
    }

    /**
     * @dev withdraw all the eth in the contract
     */
    function withdrawTips() public {
        require(msg.sender == owner, "Only the owner can withdraw the tips");
        owner.transfer(address(this).balance);
        contractVault = 0;
    }

    /**
     * @dev retrie e all memos from the blockchain
     */
    function getMemos() public view returns (Memo[] memory) {
        return memos;
    }

    function changeOwner(address newOwner) public {
        require(
            msg.sender == owner,
            "Only the owner can change the contract address !"
        );
        owner = payable(newOwner);
    }
}
