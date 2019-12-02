App = {
  web3Provider: null,
  contracts: {},

  init: async function() {
    // Load pets.
    $.getJSON('../predios.json', function(data) {
      var petsRow = $('#petsRow');
      var petTemplate = $('#petTemplate');

      for (i = 0; i < data.length; i ++) {
        petTemplate.find('.panel-title').text(data[i].name);
        petTemplate.find('img').attr('src', data[i].picture);
        petTemplate.find('.pet-breed').text(data[i].breed);
        petTemplate.find('.pet-age').text(data[i].age);
        petTemplate.find('.pet-location').text(data[i].location);
        petTemplate.find('.btn-adopt').attr('data-id', data[i].id);

        petsRow.append(petTemplate.html());
      }
    });

    return await App.initWeb3();
  },

  initWeb3: async function() {
    // Modern dapp browsers...
    if (window.ethereum) {
      App.web3Provider = window.ethereum;
      try {
        // Request account access
        await window.ethereum.enable();
      } catch (error) {
        // User denied account access...
        console.error("User denied account access")
      }
    }
    // Legacy dapp browsers...
    else if (window.web3) {
      App.web3Provider = window.web3.currentProvider;
    }
    // If no injected web3 instance is detected, fall back to Ganache
    else {
      App.web3Provider = new Web3.providers.HttpProvider('http://localhost:7545');
    }
    web3 = new Web3(App.web3Provider);

    return App.initContract();
  },

  initContract: function() {
  $.getJSON('Property.json', function(data) {
      // Get the necessary contract artifact file and instantiate it with truffle-contract
      var PropertyArtifact = data;
      App.contracts.Property = TruffleContract(PropertyArtifact);

      // Set the provider for our contract
      App.contracts.Property.setProvider(App.web3Provider);

      // Use our contract to retrieve and mark the adopted pets
      return App.markProperty();
    });

      return App.bindEvents();
  },

  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.tokenize);
  },

  markProperty: function(adopters, account) {
      var propertyInstance;

      App.contracts.Property.deployed().then(function(instance) {
        propertyInstance = instance;

        return propertyInstance.getAdopters.call();
      }).then(function(adopters) {
        for (i = 0; i < adopters.length; i++) {
          if (adopters[i] !== '0x0000000000000000000000000000000000000000') {
            $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
          if (adopters[i] !== null) {
            $('.panel-pet').eq(i).find('button').text('Success').attr('disabled', true);
          }
          }
        }
      }).catch(function(err) {
        console.log(err.message);
      });
  },

  handleBuy: function(event) {
    event.preventDefault();

    var petId = parseInt($(event.target).data('id'));

    var propertyInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];

      App.contracts.Property.deployed().then(function(instance) {
        propertyInstance = instance;

        // Execute adopt as a transaction by sending account
        return propertyInstance.adopt(petId, {from: account});
      }).then(function(result) {
        return App.markProperty();
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  },

  tokenize: function(event) {
    event.preventDefault();
    var petId = parseInt($(event.target).data('id'));

    var propertyInstance;

    web3.eth.getAccounts(function(error, accounts) {
      if (error) {
        console.log(error);
      }

      var account = accounts[0];
      accounts[1] = '0xF438D837b85d84d5F70cA66712947044589EB57A';
      console.log(accounts);

      App.contracts.Property.deployed().then(function(instance) {
        propertyInstance = instance;

        // Execute adopt as a transaction by sending account
        //return propertyInstance.getTokenPrice.call();
        return propertyInstance.transferTokens(account,"0xF438D837b85d84d5F70cA66712947044589EB57A", 1, {from: account});
      }).then(function(result) {
        $('.panel-pet').eq(petId).find('button').text("Comprar: $" + result.toString(10)).attr('disabled', false);
        return
      }).catch(function(err) {
        console.log(err.message);
      });
    });
  }

};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
