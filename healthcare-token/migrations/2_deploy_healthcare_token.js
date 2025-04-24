const HealthcareStableCoin = artifacts.require("HealthcareStableCoin");

module.exports = function (deployer) {
  deployer.deploy(HealthcareStableCoin);
};
