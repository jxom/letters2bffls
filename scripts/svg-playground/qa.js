const fs = require("fs");
const os = require("os");
const path = require("path");
const boot = require("./boot");
const call = require("./call");
const compile = require("./compile");
const deploy = require("./deploy");
const { DOMParser } = require("xmldom");

const SOURCE = path.join(__dirname, "..", "contracts", "Renderer.sol");

async function main() {
  const { vm, pk } = await boot();
  const { abi, bytecode } = compile(SOURCE);
  const address = await deploy(vm, pk, bytecode);

  const tempFolder = fs.mkdtempSync(os.tmpdir());
  console.log("Saving to", tempFolder);

  for (let i = 1; i < 256; i++) {
    const fileName = path.join(tempFolder, i + ".svg");
    console.log("Rendering", fileName);
    const svg = await call(vm, address, abi, "render", [
      i,
      "0xa5cc3c03994DB5b0d9A5eEdD10CabaB0813678AC",
      "asdasd asdnas kjndaskj ndanjksndkjasnd jkasnd kjasnd ajksnd kjasnd ajksnd akjsn djkasnd ajksnd jkasnd jkasn dajksnd kajns dkjansd kjasnd akn",
      "black",
      "white",
    ]);
    fs.writeFileSync(fileName, svg);

    // Throws on invalid XML
    new DOMParser().parseFromString(svg);
  }
}

main().catch((error) => {
  console.error(error);
  process.exit(1);
});
