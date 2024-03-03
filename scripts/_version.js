const p = require("path");
const fs = require("fs-extra");
const { rootDir } = require("./_utils");

const pubspecYamlPath = p.join(rootDir, "pubspec.yaml");
const versionRegex = /version:\s*(\d+\.\d+\.\d+)\+(\d+)/;

/**
 * @returns {Promise<{ name: string, code: number }>}
 */
async function parseVersion() {
    const content = await fs.readFile(pubspecYamlPath, "utf-8");
    const match = content.match(versionRegex);
    return { name: match[1], code: parseInt(match[2]) };
}

/**
 * @param {string} versionName
 * @param {string} versionCode
 */
async function updateVersion(versionName, versionCode) {
    const content = await fs.readFile(pubspecYamlPath, "utf-8");
    const nContent = content.replace(
        versionRegex,
        `version: ${versionName}+${versionCode}`
    );
    await fs.writeFile(pubspecYamlPath, nContent);
}

module.exports = {
    parseVersion,
    updateVersion,
};
