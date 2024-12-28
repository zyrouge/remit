const p = require("path");
const fs = require("fs-extra");
const { ZemVer } = require("@zyrouge/zemver");
const { rootDir } = require("./_utils");

const pubspecYamlPath = p.join(rootDir, "pubspec.yaml");
const versionRegex = /version:\s*(.+)/;

/**
 * @returns {Promise<ZemVer>}
 */
async function parseVersion() {
    const content = await fs.readFile(pubspecYamlPath, "utf-8");
    const match = content.match(versionRegex);
    return ZemVer.parse(match[1]);
}

/**
 * @param {ZemVer} version
 */
async function updateVersion(version) {
    const content = await fs.readFile(pubspecYamlPath, "utf-8");
    const nContent = content.replace(versionRegex, `version: ${version}`);
    await fs.writeFile(pubspecYamlPath, nContent);
}

module.exports = {
    parseVersion,
    updateVersion,
};
