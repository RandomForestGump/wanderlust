const tour = artifacts.require("tour");
const token = artifacts.require("ERC20MYN");

module.exports = function (deployer) {
  deployer.deploy(token);
  if (token.address) {
    console.log(token.address);
    deployer.deploy(tour, token.address);
    // use deployedContract here
}
  

  // deployer.deploy(token).then(function() {deployer.deploy(tour, token.deployed().address)});
  };
