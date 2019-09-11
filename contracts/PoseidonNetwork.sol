// File: ../examples/testnet/TestnetConsumerBase.sol

pragma solidity 0.4.24;

import "./ChainlinkClient.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "./RegistryInterface.sol";


contract PoseidonNetwork is ChainlinkClient, Ownable {
    uint256 constant private ORACLE_PAYMENT = 1 * LINK; // solium-disable-line zeppelin/no-arithmetic-operations
    RegistryInterface private registry;

    event RequestNetworkStatusFulfilled(
        bytes32 indexed requestId,
        address indexed superNode,
        bytes32 witness,
        uint256 networkPower,
        uint256 nodePower
    );

    constructor(address _tokenAddress) Ownable() public {
        setChainlinkToken(_tokenAddress);
    }

    function setRegistryContract(address _registryContract) public onlyOwner {
        registry = RegistryInterface(_registryContract);
    }

    function requestWithdrawQQQToken(address _oracle, string _jobId)
        public
    {
        Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), this, this.distributeQQQToken.selector);
        string memory apiEndpoint = registry.selectSuperNode();
        req.add("url", apiEndpoint);
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function distributeQQQToken(bytes32 _requestId, address _superNode, bytes32 _witness, uint256 _networkPower, uint256 _nodePower)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestNetworkStatusFulfilled(_requestId, _superNode, _witness, _networkPower, _nodePower);
    }

    function getChainlinkToken() public view returns (address) {
        return chainlinkTokenAddress();
    }

    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(link.transfer(msg.sender, link.balanceOf(address(this))), "Unable to transfer");
    }

    function stringToBytes32(string memory source) private pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
        result := mload(add(source, 32))
        }
    }

}
