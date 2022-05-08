// //SPDX-License-Identifier: UNLICENSED
// pragma solidity >=0.4.2 <=0.6.0;

// import "./ERC20MYN.sol";

// contract tour is ERC20MYN {


//     struct Tour{ 
//         uint id; // local consortium escrow
//         uint price;
//         address seller;
//         // uint hashOfDetails;
//     }

//     struct User{
//         uint escrow;
//         bool status;
//         uint[] tours;
//         uint isBuyer;

//     }
//     // ERC20MYN public tokenContract;
//     address owner;
//     Tour[] tourInfo;
//     mapping (address=>User) userMap;
//     // mapping (address=>seller) public sellerMap;
//     mapping (uint=>address) metaId;

    
//     // modifiers or rules
//     modifier onlyBuyer{ 
//         require(userMap[msg.sender].status==true && userMap[msg.sender].isBuyer==1);
//         _;
//     }
//     modifier onlySeller{ 
//         require(userMap[msg.sender].status==true && userMap[msg.sender].isBuyer==0);
//         _;
//     }
//     modifier onlyUser{ 
//         require(userMap[msg.sender].status==true);
//         _;
//     }
    
//     // constructor function
//     constructor (_tokenContract) public   { 
//         owner= msg.sender;
//         tokenContract =_tokenContract;  
//     }
    
//     function register(uint price, uint isBuyer) public payable{ 
        
//         userMap[msg.sender].status = true;
//         if(isBuyer==1){
//             userMap[msg.sender].isBuyer = 1;
//         }
//         else{
//             userMap[msg.sender].isBuyer = 0;
            
//         }

         
//          tokenContract.Registration(owner,msg.sender, price);
        
//     }

//     // function withdraw (address payable  ) onlyUser public{

//     //     userMap[msg.sender].status=false;
//     //     msg.sender.transfer(userMap[msg.sender].escrow);
//     //     userMap[msg.sender].escrow = 0;
        
//     // }


//     function addTour (uint id) onlySeller public {
//         metaId[id] = msg.sender;

//     }

//     function buyTour (uint id, uint price, address marketplace) onlyBuyer public {
//         //Get seller
//         address seller = metaId[id];
//         assert(price!=0);
//         // //Get buyer balance
//         assert(balanceOf(msg.sender)  - price >= 0);
//         //Deduct buyer balance
//         // userMap[msg.sender].escrow = userMap[msg.sender].escrow - price;
//         //Add seller balance
        
        
//         // price=price * 90;
//         // price=price/100;
//         // userMap[seller].escrow = userMap[seller].escrow + price;
//         approve(marketplace, price);
//         Registration(msg.sender,seller, price);
//         //Remove tour
//         // userMap[msg.sender].tours.push(id);
//         // delete metaId[id];
   
//     }

//     function viewUserBalance () public view returns(uint ){
        
//         //return userMap[msg.sender].escrow;
//         return balanceOf(msg.sender);
        
//     }
//     function viewBalance () public view returns(uint ){
        
//         //return address(this).balance;
//         return balanceOf(owner);
        
//     }
// }

// //SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.2 <=0.6.0;

import "./ERC20MYN.sol";
contract tour  {



    struct Tour{ 
        uint id; // local consortium escrow
        uint price;
        address seller;
        // uint hashOfDetails;
    }

    struct User{
        uint escrow;
        bool status;
        uint[] tours;
        uint isBuyer;

    }
    ERC20MYN public tokenContract;
    address owner;
    Tour[] tourInfo;
    mapping (address=>User) userMap;
    // mapping (address=>seller) public sellerMap;
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
    constructor (ERC20MYN _tokenContract) public   { 
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

         tokenContract.Registration(owner,msg.sender, 100000);
        
    }

    // function withdraw (address payable  ) onlyUser public{

    //     userMap[msg.sender].status=false;
    //     msg.sender.transfer(userMap[msg.sender].escrow);
    //     userMap[msg.sender].escrow = 0;
        
    // }


    function addTour (uint id) onlySeller public {
        metaId[id] = msg.sender;

    }

    function buyTour (uint id, uint price) onlyBuyer public {
        //Get seller
        address seller = metaId[id];
        assert(price!=0);
        // //Get buyer balance
        assert(tokenContract.balanceOf(msg.sender)  - price >= 0);
        //Deduct buyer balance
        // userMap[msg.sender].escrow = userMap[msg.sender].escrow - price;
        //Add seller balance
        
        
        // price=price * 90;
        // price=price/100;
        // userMap[seller].escrow = userMap[seller].escrow + price;
        // tokenContract.approve(marketplace, price);
        tokenContract.Registration(msg.sender,seller, price);
        //Remove tour
        // userMap[msg.sender].tours.push(id);
        // delete metaId[id];
   
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