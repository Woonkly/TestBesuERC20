// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Burnable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/token/ERC20/ERC20Pausable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/access/Roles.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v2.5.0/contracts/ownership/Ownable.sol";




contract WOP is ERC20Mintable,ERC20Burnable, ERC20Detailed,ERC20Pausable,Ownable  {
    
    using Roles for Roles.Role;

    Roles.Role private _minters;
    Roles.Role private _burners;

    
    constructor(
        uint256 initialSupply,
        address[] memory minters, 
        address[] memory burners        
        ) ERC20Detailed("Woonkly Power", "WOP", 18) public {  
        _mint(msg.sender, initialSupply);

        
        for (uint256 i = 0; i < minters.length; ++i) {
            _minters.add(minters[i]);
        }

        for (uint256 i = 0; i < burners.length; ++i) {
            _burners.add(burners[i]);
        }        
        
    }    
    
    function burnWOP(address account, uint256 amount) public onlyOwner returns(bool) {
        _burn(account, amount) ;   
        return true;
    }


    function addBurner(address burner) public onlyOwner {
        _burners.add(burner);
    }

    function burn(address from, uint256 amount) public returns (bool) {
        // Only burners can burn
        require(_burners.has(msg.sender), "DOES_NOT_HAVE_BURNER_ROLE");

       _burn(from, amount);
       return true;
    }

    function isBurner(address account) public view returns (bool) {
        return _burners.has(account);
    }
    
    function()  external payable { }
    
    function getMyether() public view returns(uint256){
            address payable self = address(this);
            uint256 bal =  self.balance;    
            
            return bal;
            
    }

    event WithdrawedForEth(address indexed beneficiary, uint256 amount);
    
    function exchangeForEth(address account, uint256 amount) public onlyOwner returns(bool) {
        _burn(account, amount) ;   
        emit WithdrawedForEth(account, amount);
        return true;
    }
    
    function exchangeForEthUser( uint256 tkAmount) public  returns(bool) {
        
        require(tkAmount != 0, "exchangeForEthUser: tkAmount is 0");
        
        address vendor =address(msg.sender);
        
        require(tkAmount <= balanceOf(vendor), "exchangeForEthUser: insuficient balance tkAmount");
        
        _burn(vendor, tkAmount) ;   
        
        emit WithdrawedForEth(vendor, tkAmount);
        
        return true;
    }



    event WithdrawedForBNB(address indexed beneficiary, uint256 amount);
    
    function exchangeForBNB(address account, uint256 amount) public onlyOwner returns(bool) {
        _burn(account, amount) ;   
        emit WithdrawedForBNB(account, amount);
        return true;
    }


    function exchangeForBNBUser( uint256 tkAmount) public  returns(bool) {
        require(tkAmount != 0, "exchangeForBNBUser: tkAmount is 0");
        
        address vendor =address(msg.sender);
        
        require(tkAmount <= balanceOf(vendor), "exchangeForBNBUser: insuficient balance tkAmount");
        
        _burn(vendor, tkAmount) ;   
        emit WithdrawedForBNB(vendor, tkAmount);
        return true;
    }

}
