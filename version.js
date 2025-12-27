window.latest = {
	DockAltTab: "3.00.5",
	AltTab: "1.94.2",
};

window.onload = () => {
	Array.from(document.querySelectorAll(".loadanchor")).forEach((el, i) => {
		el.href = `https://github.com/steventheworker/DockAltTab/releases/download/v${window.latest.DockAltTab}/DockAltTab-v${window.latest.DockAltTab}.zip`;
	});
	Array.from(document.querySelectorAll(".loadanchor2")).forEach((el, i) => {
		el.href = `https://github.com/steventheworker/alt-tab-macos/releases/download/${window.latest.AltTab}/AltTab-scriptable-${window.latest.AltTab}.zip`;
	});
	Array.from(document.querySelectorAll(".loadanchorv")).forEach((el, i) => {
		el.textContent = "DockAltTab-v" + window.latest.DockAltTab;
	});
	Array.from(document.querySelectorAll(".loadv")).forEach((el, i) => {
		el.textContent = "v" + window.latest.DockAltTab;
	});

	const style = document.createElement("style");
	style.textContent = `div.loadv {display: inline-block;}`;
	document.body.appendChild(style);
};
