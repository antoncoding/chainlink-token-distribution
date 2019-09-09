// File: ../examples/testnet/TestnetConsumerBase.sol

pragma solidity 0.4.24;

import "./ChainlinkClient.sol";
import "openzeppelin-solidity/contracts/ownership/Ownable.sol";


contract PoseidonNetwork is ChainlinkClient, Ownable {
    uint256 constant private ORACLE_PAYMENT = 1 * LINK; // solium-disable-line zeppelin/no-arithmetic-operations

    uint256 public currentPrice;

    event RequestNodeStatusFulfilled(
        bytes32 indexed requestId,
        address indexed superNode,
        bytes32 witness,
        uint256 networkPower,
        uint256 nodePower
    );

    event RequestEthereumPriceFulfilled(
        bytes32 indexed requestId,
        uint256 indexed price
    );

    constructor(address _tokenAddress) Ownable() public {
        setChainlinkToken(_tokenAddress);
    }

    function requestWithdrawQQQToken(address _oracle, string _jobId)
        public
    {
        Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), this, this.distributeQQQToken.selector);
        req.add("url", "https://api.poseidonnetwork.com/status");
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function distributeQQQToken(bytes32 _requestId, address _superNode, bytes32 _witness, uint256 _networkPower, uint256 _nodePower)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestNodeStatusFulfilled(_requestId, _superNode, _witness, _networkPower, _nodePower);
    }

    function requestEthereumPrice(address _oracle, string _jobId)
        public
        onlyOwner
    {
        Chainlink.Request memory req = buildChainlinkRequest(stringToBytes32(_jobId), this, this.fulfillEthereumPrice.selector);
        req.add("url", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD");
        req.add("path", "USD");
        req.addInt("times", 100);
        sendChainlinkRequestTo(_oracle, req, ORACLE_PAYMENT);
    }

    function fulfillEthereumPrice(bytes32 _requestId, uint256 _price)
        public
        recordChainlinkFulfillment(_requestId)
    {
        emit RequestEthereumPriceFulfilled(_requestId, _price);
        currentPrice = _price;
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
