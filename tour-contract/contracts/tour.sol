pragma solidity >=0.4.2 <=0.6.0;
// pragma solidity ^0.6.2;

contract tour  {
   
    // address chairperson;

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
    constructor () public   { 

        
    }
    
    function register (uint isBuyer) public payable { 
        
        userMap[msg.sender].escrow = msg.value;
        userMap[msg.sender].status = true;
        if(isBuyer==1){
            userMap[msg.sender].isBuyer = 1;
        }
        else{
            userMap[msg.sender].isBuyer = 0;
            
        }
        
    }
        
//    function withdraw (address payable toPay ) onlyUser public{

//        assert(msg.sender == toPay);
//         userMap[toPay].status=false;
//         toPay.transfer(userMap[toPay].escrow);
//         userMap[toPay].escrow = 0;
        
//     }
    function withdraw (address payable  ) onlyUser public{

        userMap[msg.sender].status=false;
        msg.sender.transfer(userMap[msg.sender].escrow);
        userMap[msg.sender].escrow = 0;
        
    }


    function addTour (uint id) onlySeller public {
   
        // Tour memory new_tour;
        // new_tour.id = id;
        // new_tour.price=price;
        // new_tour.seller = msg.sender;
        // userMap[msg.sender].tours.push(new_tour);
        metaId[id] = msg.sender;

    }

    function buyTour (uint id, uint price) onlyBuyer public {
        //Get seller
        address seller = metaId[id];
        assert(price!=0);
        // //Get buyer balance
        assert(userMap[msg.sender].escrow - price >= 0);
        //Deduct buyer balance
        userMap[msg.sender].escrow = userMap[msg.sender].escrow - price;
        //Add seller balance
        price=price * 90;
        price=price/100;
        userMap[seller].escrow = userMap[seller].escrow + price;
        //Remove tour
        userMap[msg.sender].tours.push(id);
        // delete metaId[id];
   
    }

    function viewUserBalance () onlyUser public view returns(uint ){
        
        return userMap[msg.sender].escrow;
        
    }
    function viewBalance () public view returns(uint ){
        
        return address(this).balance;
        
    }
}

