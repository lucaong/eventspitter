config = module.exports;

config["Browser tests"] = {
  env: "browser",
  rootPath: "../",
  sources: ["lib/eventspitter.js"],
  tests: ["spec/**/*.spec.{coffee,js}"],
  extensions: [require("buster-coffee")]
}
