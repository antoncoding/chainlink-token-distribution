pragma solidity 0.4.24;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Mintable.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";


contract PoseidonToken is ERC20Mintable, ERC20Detailed {
    uint8 public constant DECIMALS = 8;

    constructor (uint256 initialSupply)
        ERC20Detailed("Poseidon Network Token", "QQQ", DECIMALS)
        public {
        mint(msg.sender, initialSupply);
    }

}