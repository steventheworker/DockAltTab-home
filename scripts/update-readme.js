const fs = require("fs");
const vm = require("vm");

// load version.js
const code = fs.readFileSync("version.js", "utf8");

// sandbox so window.latest works
const sandbox = { window: {} };
vm.createContext(sandbox);
vm.runInContext(code, sandbox);

const latest = sandbox.window.latest;

if (!latest) {
	console.error("Could not read window.latest");
	process.exit(1);
}

let readme = fs.readFileSync("README.md", "utf8");

readme = readme
	.replaceAll("{{DockAltTab}}", latest.DockAltTab)
	.replaceAll("{{AltTab}}", latest.AltTab);

fs.writeFileSync("README.md", readme);

console.log("README updated:");
console.log("DockAltTab:", latest.DockAltTab);
console.log("AltTab:", latest.AltTab);
