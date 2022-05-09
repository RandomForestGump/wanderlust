const tour = artifacts.require("tour");
const token = artifacts.require("ERC20SHC");

// module.exports = function (deployer) {
//   deployer.deploy(token);
//   if (token.address) {
//     console.log(token.address);
//     deployer.deploy(tour, token.address);
// }
//     };


    module.exports = function (deployer) {
      
      deployer.then(async () => {
        await deployer.deploy(token);
        await deployer.deploy(tour, token.address);
      });
        };

  
