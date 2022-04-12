App = {
    web3Provider: null,
    contracts: {},
    names: new Array(),
    url: 'http://127.0.0.1:7545',
    chairPerson:null,
    currentAccount:null,
    init: function() {
      $.getJSON('../tour.json', function(data) {
        var proposalsRow = $('#proposalsRow');
        var proposalTemplate = $('#proposalTemplate');
  
        for (i = 0; i < data.length; i ++) {
          proposalTemplate.find('.panel-title').text(data[i].name);
          proposalTemplate.find('img').attr('src', data[i].picture);
          proposalTemplate.find('.btn-buy').attr('data-id', data[i].id);
  
          proposalsRow.append(proposalTemplate.html());
          App.names.push(data[i].name);
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
        $.getJSON('LocalLens.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var voteArtifact = data;
      App.contracts.tour = TruffleContract(voteArtifact);   /////??????
  
      // Set the provider for our contract
      App.contracts.vote.setProvider(App.web3Provider);
      
      // App.getChairperson();/////????????????????
      return App.bindEvents();
    });
    },
  
    bindEvents: function() {
      $(document).on('click', '.btn-buy', function(){App.handleBuyTour();} );
      $(document).on('click', '#btn-withdraw', App.handleWithdraw);
      $(document).on('click', '#add-item', App.handleAddTour);
      $(document).on('click', '#view-balance', App.handleViewBalance);
      $(document).on('click', '#register', function(){ var ad = $('#isSeller').val(); var price = $('#price').val(); App.handleRegister(ad, price);});
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
    App.contracts.tour.deployed().then(function(instance) {
        voteInstance = instance;
        return voteInstance.register(!isSeller, {from: this.state.account, value: price}); //input price
    }).then(function(result, err){
        if(result){
            if(parseInt(result.receipt.status) == 1)
            alert(addr + " registration done successfully")
            else
            alert(addr + " registration not done successfully due to revert")
        } else {
            alert(addr + " registration failed")
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
      return voteInstance.withdraw({from: this.state.account}); //input price
  }).then(function(result, err){
      if(result){
          if(parseInt(result.receipt.status) == 1)
          alert(addr + " Withdraw done successfully")
          else
          alert(addr + " Withdraw not done successfully due to revert")
      } else {
          alert(addr + " Withdraw failed")
      }   
  })
  })
},

handleAddTour: function(price){
  var voteInstance;
  //Allocate _id-------------------------
  web3.eth.getAccounts(function(error, accounts) {
  var account = accounts[0];
  App.contracts.tour.deployed().then(function(instance) {
      voteInstance = instance;
      return voteInstance.addTour(_id, price, {from: this.state.account}); //input price
  }).then(function(result, err){
      if(result){
          if(parseInt(result.receipt.status) == 1)
          alert(addr + " Withdraw done successfully")
          else
          alert(addr + " Withdraw not done successfully due to revert")
      } else {
          alert(addr + " Withdraw failed")
      }   
  })
  })
},

handleBuyTour: function(event){
  event.preventDefault();
  var voteInstance;
  //Allocate _id-------------------------
  var _id = parseInt($(event.target).data('id'));
  web3.eth.getAccounts(function(error, accounts) {
  var account = accounts[0];
  App.contracts.tour.deployed().then(function(instance) {
      voteInstance = instance;
      return voteInstance.buyTour(_id, {from: this.state.account}); //input price
  }).then(function(result, err){
      if(result){
          if(parseInt(result.receipt.status) == 1)
          alert(addr + " Buy Tour done successfully")
          else
          alert(addr + " Buy Tour not done successfully due to revert")
      } else {
          alert(addr + " Buy Tour failed")
      }   
  })
  })
},


handleViewBalance : function() {
  console.log("To get winner");
  var voteInstance;
  App.contracts.tour.deployed().then(function(instance) {
    voteInstance = instance;
    return voteInstance.viewBalance({from: this.state.account});
  }).then((r)=>{
    jQuery('#counter_value').text(r)
    alert(res + "  is the balance ! :)");
  }).catch(function(err){
    console.log(err.message);
  })
},

handleviewUserBalance : function() {
  console.log("To get winner");
  var voteInstance;
  App.contracts.tour.deployed().then(function(instance) {
    voteInstance = instance;
    return voteInstance.viewUserBalance({from: this.state.account});
  }).then((r)=>{
    jQuery('#counter_value').text(r)
    alert(res + "  is the balance ! :)");
  }).catch(function(err){
    console.log(err.message);
  })
}


}