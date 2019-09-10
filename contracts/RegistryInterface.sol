pragma solidity 0.4.24;

interface RegistryInterface {
  function registerSuperNode(string _apiEndpoint, uint8 _v, bytes32 _r, bytes32 _s) external returns (bool success);
  function selectSuperNode() external view returns (string apiEndpoint);
}
