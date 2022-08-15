// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract DevRewards is ERC20, ERC20Burnable, Ownable {
  using SafeMath for uint256;

  mapping(address => uint256) private _balances;
  mapping(address => bool) controllers;

  uint256 private _totalSupply; //total supply of the token
  uint256 private MAXSUP;     // Maximum supply of the token
  uint256 constant MAXIMUMSUPPLY=10000*10**18; //The default value of {decimals} is 18

  /**
  *constructior function
  **/

  constructor() ERC20("DevToken", "DEV") { 
      _mint(msg.sender, 10000 * 10 ** 18);  // Mint 10000 tokens to msg.sender

  }

  /**
  *Mint Function only msg.sender mint the tokens
  */

  function mint(address to, uint256 amount) external {
    require(controllers[msg.sender], "Only controllers can mint");
    require((MAXSUP+amount)<=MAXIMUMSUPPLY,"Maximum supply has been reached");
    _totalSupply = _totalSupply.add(amount);
    MAXSUP=MAXSUP.add(amount);
    _balances[to] = _balances[to].add(amount);
    _mint(to, amount);
  }


  /**
   * only msg.sender burn the tokens
   */

   function burnFrom(address account, uint256 amount) public override {
      if (controllers[msg.sender]) {
          _burn(account, amount);
      }
      else {
          super.burnFrom(account, amount);
      }
  }

  /**
   * @dev addController of tokens 
     * Only contract Owner access this function
     */
    

  function addController(address controller) external onlyOwner {
    controllers[controller] = true;
  }


  /**
    * @dev removeController of tokens 
     * Only contract Owner access this function
     */
    
     function removeController(address controller) external onlyOwner {
      controllers[controller] = false;
  }

    /**
     * @dev totalSupply of tokens 
     */
  
  function totalSupply() public override view returns (uint256) {
    return _totalSupply;
  }

   
    /**
     * @dev maxSupply of tokens 
     */

  function maxSupply() public  pure returns (uint256) {
    return MAXIMUMSUPPLY;
  }

}