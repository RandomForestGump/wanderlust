//SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.2 <=0.6.0;

import "./ERC20SHC.sol";
contract tour  {

    struct Tour{ 
        uint id; 
        uint price;
        address seller;
    }

    struct User{
        bool status;
        uint[] tours;
        uint isBuyer;

    }

    ERC20SHC public tokenContract;
    address owner;
    Tour[] tourInfo;
    mapping (address=>User) userMap;
    mapping (uint=>address) metaId;

    // modifiers or rules
    modifier onlyBuyer{ 
        require(userMap[msg.sender].status==true && userMap[msg.sender].isBuyer==1);
        _;
    }
    modifier onlySeller{ 
        require(userMap[msg.sender].status==true && userMap[msg.sender].isBuyer==0);
        _;
    }
    modifier onlyUser{ 
        require(userMap[msg.sender].status==true);
        _;
    }
    
    // constructor function
    constructor (ERC20SHC _tokenContract) public   { 
        owner= msg.sender;
        tokenContract =_tokenContract;  
    }
    
    function register(uint isBuyer) public payable{ 
        
        userMap[msg.sender].status = true;
        if(isBuyer==1){
            userMap[msg.sender].isBuyer = 1;
        }
        else{
            userMap[msg.sender].isBuyer = 0;
            
        }

         tokenContract.transferSHC(owner,msg.sender, 1000);
        
    }

    function addTour (uint id) onlySeller public {
        metaId[id] = msg.sender;

    }

    function buyTour (uint id, uint price) onlyBuyer public {
        address seller = metaId[id];
        assert(price!=0);
        assert(tokenContract.balanceOf(msg.sender)  - price >= 0);
        tokenContract.transferSHC(msg.sender,seller,price);
        //Remove tour
        userMap[msg.sender].tours.push(id);
        delete metaId[id];
   
    }

    function viewUserBalance () public view returns(uint ){
        
        //return userMap[msg.sender].escrow;
        return tokenContract.balanceOf(msg.sender);
        
    }
    function viewBalance () public view returns(uint ){
        
        //return address(this).balance;
        return tokenContract.balanceOf(owner);
        
    }
}