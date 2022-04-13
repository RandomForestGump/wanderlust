pragma solidity >=0.4.2 <=0.6.0;
// pragma solidity ^0.6.2;

contract LocalLens  {
   
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
        Tour[] tours;
        bool isBuyer;

    }
    Tour[] tourInfo;
    mapping (address=>User) userMap;
    // mapping (address=>seller) public sellerMap;
    mapping (uint=>Tour) metaId;

    
    // modifiers or rules
    modifier onlyBuyer{ 
        require(userMap[msg.sender].status==true && userMap[msg.sender].isBuyer);
        _;
    }
    modifier onlySeller{ 
        require(userMap[msg.sender].status==true && !userMap[msg.sender].isBuyer);
        _;
    }
    modifier onlyUser{ 
        require(userMap[msg.sender].status==true);
        _;
    }
    
    // constructor function
    constructor () public   { 

        
    }
    
    function register (bool isBuyer) public payable{ 
        userMap[msg.sender].escrow = msg.value;
        userMap[msg.sender].status = true;
        if(isBuyer){
            userMap[msg.sender].isBuyer = true;
        }
        else{
            userMap[msg.sender].isBuyer = false;
            
        }
        
    }
        
   function withdraw (address payable toPay ) onlyUser public{

       assert(msg.sender == toPay);
        userMap[toPay].status=false;
        toPay.transfer(userMap[toPay].escrow);
        userMap[toPay].escrow = 0;
        
    }


    function addTour (uint id, uint price) onlySeller public {
   
        Tour memory new_tour;
        new_tour.id = id;
        new_tour.price=price;
        new_tour.seller = msg.sender;
        userMap[msg.sender].tours.push(new_tour);
        metaId[id] = new_tour;

    }

    function buyTour (uint id) onlyBuyer public {
        //Get seller
        address seller = metaId[id].seller;
        uint price = metaId[id].price;
        //Get buyer balance
        assert(userMap[msg.sender].escrow - price >= 0);
        //Deduct buyer balance
        userMap[msg.sender].escrow = userMap[msg.sender].escrow - price;
        //Add seller balance
        userMap[seller].escrow = userMap[seller].escrow + price;
        //Remove tour
        userMap[msg.sender].tours.push(metaId[id]);
        delete metaId[id];
   
    }

    function viewUserBalance () public view returns(uint balance){
        
        balance = userMap[msg.sender].escrow;
        
    }
    function viewBalance () public view returns(uint balance){
        
        balance = address(this).balance;
        
    }
}

