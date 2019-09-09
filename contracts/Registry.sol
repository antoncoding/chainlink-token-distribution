pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/ownership/Ownable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/IERC20.sol";


contract PoseidonRegistry is Ownable {

    IERC20 private qqqToken;

    mapping(address => string) private apiEndpoints;

    constructor (address _tokenAddress) public {
        qqqToken = IERC20(_tokenAddress);
    }

    function registerSuperNode (
        string _apiEndpoint,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
    public
    {
        bytes32 messageHash = keccak256(abi.encodePacked(msg.sender, _apiEndpoint));
        require(ecrecover(messageHash, v, r, s) == owner(), "Witness validation failed.");
        apiEndpoints[msg.sender] = _apiEndpoint;
    }
}