pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


contract PoseidonRegistry is Ownable {
    using SafeMath for uint256;

    address[] superNodes;
    mapping(address => string) private apiEndpoints;
    IERC20 private qqqToken;

    constructor (address _tokenAddress) public {
        qqqToken = IERC20(_tokenAddress);
    }

    /**
     * @param _apiEndpoint the API endpoint want to register as super node.
     * @param _v signature v value from contract owner.
     * @param _r signature r value from contract owner.
     * @param _s signature s value from contract owner.
     */
    function registerSuperNode(string _apiEndpoint, uint8 _v, bytes32 _r, bytes32 _s) public {
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, _apiEndpoint));
        require(ecrecover(messageHash, _v, _r, _s) == owner(), "Witness validation failed.");
        superNodes.push(msg.sender);
        apiEndpoints[msg.sender] = _apiEndpoint;
    }

    /**
     * @dev return a random api endpoint.
     */
    function selectSuperNode() public view returns (string apiEndpoint) {
        bytes32 blockHash = blockhash(block.number);
        uint256 superNodexIndex = uint256(blockHash).mod(superNodes.length);
        apiEndpoint = apiEndpoints[superNodes[superNodexIndex]];
    }
}