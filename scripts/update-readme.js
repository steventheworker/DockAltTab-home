#!/usr/bin/env node
const fs = require("fs");
const path = require("path");
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

// map of repo -> README
const readmes = [
	{
		name: "DockAltTab",
		file: path.resolve(__dirname, "../../../obj-c/DockAltTab/README.md"),
		dockAltTab: true,
		altTab: true,
	},
	{
		name: "AltTab",
		file: path.resolve(__dirname, "../../../swift/alt-tab-macos/README.md"),
		dockAltTab: false,
		altTab: true,
	},
	{
		name: "Web",
		file: path.resolve(__dirname, "../README.md"),
		dockAltTab: true,
		altTab: true,
	},
];

readmes.forEach((r) => {
	let readme = fs.readFileSync(r.file, "utf8");

	// DockAltTab links
	if (r.dockAltTab) {
		// version text
		readme = readme.replace(
			/v\d+\.\d+\.\d+(?= download link)/g,
			`v${latest.DockAltTab}`,
		);
		// zip URLs
		readme = readme.replace(
			/https:\/\/github\.com\/steventheworker\/DockAltTab\/releases\/download\/v\d+\.\d+\.\d+\/DockAltTab-v\d+\.\d+\.\d+\.zip/g,
			`https://github.com/steventheworker/DockAltTab/releases/download/v${latest.DockAltTab}/DockAltTab-v${latest.DockAltTab}.zip`,
		);
	}

	// AltTab links
	if (r.altTab) {
		// versioned zip links
		readme = readme.replace(
			/https:\/\/github\.com\/steventheworker\/alt-tab-macos\/releases\/download\/[0-9]+\.[0-9]+\.[0-9]+\/AltTab-scriptable-[0-9]+\.[0-9]+\.[0-9]+\.zip/g,
			`https://github.com/steventheworker/alt-tab-macos/releases/download/${latest.AltTab}/AltTab-scriptable-${latest.AltTab}.zip`,
		);
		// optional text versions like "**Latest scriptable AltTab**: ..."
		readme = readme.replace(
			/(AltTab-scriptable-)(\d+\.\d+\.\d+)/g,
			`$1${latest.AltTab}`,
		);
	}

	fs.writeFileSync(r.file, readme);
	console.log(`Updated README for ${r.name}:`);
	if (r.dockAltTab) console.log(" - DockAltTab:", latest.DockAltTab);
	if (r.altTab) console.log(" - AltTab:", latest.AltTab);
});
