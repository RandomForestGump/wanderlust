App = {

    web3Provider: null,
    contracts: {},
    names: new Array(),
    url: 'http://127.0.0.1:7545',
    chairPerson:null,
    currentAccount:null,
    init: function() {
      $.getJSON('../tourAttr.json', function(data) {
        var proposalsRow = $('#proposalsRow');
        var proposalTemplate = $('#proposalTemplate');
  
        for (i = 0; i < data.length; i ++) {
          if (data[i].status){
          proposalTemplate.find('.panel-title').text(data[i].name);
          proposalTemplate.find('img').attr('src', data[i].picture);
          proposalTemplate.find('.btn-buy').attr('data-id', data[i].id);
  
          proposalsRow.append(proposalTemplate.html());
          App.names.push(data[i].name);
          }
          
        }
      });
      return App.initWeb3();
    },
  
    initWeb3: function() {
          // Is there is an injected web3 instance?
      if (typeof web3 !== 'undefined') {
        App.web3Provider = web3.currentProvider;
      } else {
        // If no injected web3 instance is detected, fallback to the TestRPC
        App.web3Provider = new Web3.providers.HttpProvider(App.url);
      }
      web3 = new Web3(App.web3Provider);
      ethereum.enable();
  
      App.populateAddress();
      return App.initContract();
    },
  
  
    initContract: function() {
        $.getJSON('tour.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var voteArtifact = data;
      App.contracts.tour = TruffleContract(voteArtifact);   /////??????
  
      // Set the provider for our contract
      App.contracts.tour.setProvider(App.web3Provider);
      
      // App.getChairperson();/////????????????????
      return App.bindEvents();
    });
    },
  
    bindEvents: function() {
      $(document).on('click', '.btn-buy', App.handleBuyTour);
      $(document).on('click', '#btn-withdraw',App.handleWithdraw);

      $(document).on('click', '#add-item', function(){ 
      
        var price = $('#price').val(); 
        var name = $('#name').val(); 
        var desc = $('#description').val(); 
        App.handleAddTour(name, desc, price);});


       $(document).on('click', '#view-userbalance',App.handleViewUserBalance);
      $(document).on('click', '#view-balance',App.handleViewBalance);
      $(document).on('click', '#register', function(){ 
                      var ad = $('#isSeller').val(); 
                      console.log(ad);
                      console.log(price);
                      var price = $('#escrow').val(); 
                      App.handleRegister(ad, price);});
    },

    populateAddress : function(){
        new Web3(new Web3.providers.HttpProvider(App.url)).eth.getAccounts((err, accounts) => {
          web3.eth.defaultAccount=web3.eth.accounts[0]
          jQuery.each(accounts,function(i){
            if(web3.eth.coinbase != accounts[i]){
              var optionElement = '<option value="'+accounts[i]+'">'+accounts[i]+'</option';
              jQuery('#enter_address').append(optionElement);   ///?
            }
          });
        });
      },

    handleRegister: function(isSeller, price){
    var voteInstance;
    web3.eth.getAccounts(function(error, accounts) {
    var account = accounts[0];
    // let price = prompt("what is your name?");
    console.log(price);
    App.contracts.tour.deployed().then(function(instance) {
        voteInstance = instance;
        console.log("Price registered");
        console.log(price);
        console.log("Seller typr");
        console.log(typeof isSeller);
        var isSellerBool;
        if(isSeller=='true'){
          isSellerBool=0;
        }
        else {
          isSellerBool=1;
        }
    
       // price=App.web3.utils.toWei(price);
      //   $.get("/toWei",{data: price},function(data) {
      //     price = data.price;
      //     console.log(price);
      //  });
        price=parseInt(price*1000000000000000000);
        console.log("Price registered after conversion");
        console.log(price);
        //voteInstance.send(price , {from: account});
        return voteInstance.register(isSellerBool, {from: account, value: price}); //input price
    }).then(function(result, err){
        if(result){
            if(parseInt(result.receipt.status) == 1)
            alert( " registration done successfully")
            else
            alert( " registration not done successfully due to revert")
        } else {
            alert( " registration failed")
        }   
    })
    })
},


handleWithdraw: function(){
  var voteInstance;
  web3.eth.getAccounts(function(error, accounts) {
  var account = accounts[0];
  App.contracts.tour.deployed().then(function(instance) {
      voteInstance = instance;
      console.log("In Withdraw");
      return voteInstance.withdraw(account,{from: account});
  }).then(function(result, err){
      if(result){
          if(parseInt(result.receipt.status) == 1)
          alert( " Withdraw done successfully")
          else
          alert(" Withdraw not done successfully due to revert")
      } else {
          alert( err + " Withdraw failed")
      }   
  })
  })
},

handleAddTour: function(name, description, price){
  var voteInstance;
  //Allocate _id-------------------------
  web3.eth.getAccounts(function(error, accounts) {
  var account = accounts[0];
  var _id = -1;
  //Get Name, description, price
  price=parseInt(price*1000000000000000000);
  $.getJSON('../tourAttr.json', function(data) {
    _id = data.length;
    var obj = {
      "id": _id,
      "name": name,
      "description":description,
      "picture": "images/Radar.png",
      "price": price,
      "status": true
    };
    data.push(obj);

  App.contracts.tour.deployed().then(function(instance) {
      voteInstance = instance;
      return voteInstance.addTour(_id, price, {from: account}); //input price
  }).then(function(result, err){
      if(result){
          if(parseInt(result.receipt.status) == 1)
          alert( " Add Item done successfully")
          else
          alert( " Add Item not done successfully due to revert")
      } else {
          alert( " WAdd Item failed")
      } 
    })  
    $.post("/saveToFile",{data:JSON.stringify(data)});
  })
  
});

  },

handleBuyTour: function(event){
  event.preventDefault();
  var voteInstance;
  var _id = parseInt($(event.target).data('id'));
  $.getJSON('../tourAttr.json', function(data) {
    data[_id].status = false;
    web3.eth.getAccounts(function(error, accounts) {
      var account = accounts[0];
      App.contracts.tour.deployed().then(function(instance) {
          voteInstance = instance;
          console.log(data[_id].price);
          console.log("From account is:");
          console.log(account);
          return voteInstance.buyTour(_id, data[_id].price, {from: account}); //input price
      }).then(function(result, err){
        console.log(result);
          if(result){
              if(parseInt(result.receipt.status) == 1)
              alert( " Buy Tour done successfully")
              else
              alert(" Buy Tour not done successfully due to revert")
          } else {
              alert( " Buy Tour failed")
          }   
      })
      })

      $.post("/saveToFile",{data:JSON.stringify(data)});

  });
  
},


handleViewBalance : function() {
  console.log("To get winner");
  var voteInstance;
  App.contracts.tour.deployed().then(function(instance) {
    voteInstance = instance;
    return voteInstance.viewBalance();
  }).then((r)=>{
    jQuery('#view_balance').text(r)
    alert(r + "  is the balance ! :)");
  }).catch(function(err){
    console.log(err.message);
  })
},

handleViewUserBalance : function() {
  var voteInstance;
  App.contracts.tour.deployed().then(function(instance) {
    voteInstance = instance;
    return voteInstance.viewUserBalance();
  }).then((r)=>{
    jQuery('#view_user_balance').text(r)
    alert(r + "  is the balance ! :)");
  }).catch(function(err){
    console.log(err.message);
  })
}


};

$(function() {
  $(window).load(function() {
    App.init();
  });
});