// File: contracts/Chainlink.sol

pragma solidity 0.4.24;

// import "./Buffer.sol";
import "@ensdomains/buffer/contracts/Buffer.sol";
import "solidity-cborutils/contracts/CBOR.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";


/**
 * @title Library for common Chainlink functions
 * @dev Uses imported CBOR library for encoding to buffer
 */
library Chainlink {
    uint256 internal constant DEFAULT_BUFFER_SIZE = 256;

    using CBOR for Buffer.buffer;

    struct Request {
        bytes32 id;
        address callbackAddress;
        bytes4 callbackFunctionId;
        uint256 nonce;
        Buffer.buffer buf;
    }

    /**
    * @notice Initializes a Chainlink request
    * @dev Sets the ID, callback address, and callback function signature on the request
    * @param self The uninitialized request
    * @param _id The Job Specification ID
    * @param _callbackAddress The callback address
    * @param _callbackFunction The callback function signature
    * @return The initialized request
    */
    function initialize(
        Request memory self,
        bytes32 _id,
        address _callbackAddress,
        bytes4 _callbackFunction
    ) internal pure returns (Chainlink.Request memory) {
        Buffer.init(self.buf, DEFAULT_BUFFER_SIZE);
        self.id = _id;
        self.callbackAddress = _callbackAddress;
        self.callbackFunctionId = _callbackFunction;
        return self;
    }

    /**
    * @notice Sets the data for the buffer without encoding CBOR on-chain
    * @dev CBOR can be closed with curly-brackets {} or they can be left off
    * @param self The initialized request
    * @param _data The CBOR data
    */
    function setBuffer(Request memory self, bytes _data)
        internal pure
    {
        Buffer.init(self.buf, _data.length);
        Buffer.append(self.buf, _data);
    }

    /**
    * @notice Adds a string value to the request with a given key name
    * @param self The initialized request
    * @param _key The name of the key
    * @param _value The string value to add
    */
    function add(Request memory self, string _key, string _value)
        internal pure
    {
        self.buf.encodeString(_key);
        self.buf.encodeString(_value);
    }

    /**
    * @notice Adds a bytes value to the request with a given key name
    * @param self The initialized request
    * @param _key The name of the key
    * @param _value The bytes value to add
    */
    function addBytes(Request memory self, string _key, bytes _value)
        internal pure
    {
        self.buf.encodeString(_key);
        self.buf.encodeBytes(_value);
    }

    /**
    * @notice Adds a int256 value to the request with a given key name
    * @param self The initialized request
    * @param _key The name of the key
    * @param _value The int256 value to add
    */
    function addInt(Request memory self, string _key, int256 _value)
        internal pure
    {
        self.buf.encodeString(_key);
        self.buf.encodeInt(_value);
    }

    /**
    * @notice Adds a uint256 value to the request with a given key name
    * @param self The initialized request
    * @param _key The name of the key
    * @param _value The uint256 value to add
    */
    function addUint(Request memory self, string _key, uint256 _value)
        internal pure
    {
        self.buf.encodeString(_key);
        self.buf.encodeUInt(_value);
    }

    /**
    * @notice Adds an array of strings to the request with a given key name
    * @param self The initialized request
    * @param _key The name of the key
    * @param _values The array of string values to add
    */
    function addStringArray(Request memory self, string _key, string[] memory _values)
        internal pure
    {
        self.buf.encodeString(_key);
        self.buf.startArray();
        for (uint256 i = 0; i < _values.length; i++) {
            self.buf.encodeString(_values[i]);
        }
        self.buf.endSequence();
    }
}