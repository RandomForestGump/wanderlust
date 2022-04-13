const tour = artifacts.require("./tour.sol");

module.exports = function (deployer) {
  deployer.deploy(tour);
};
