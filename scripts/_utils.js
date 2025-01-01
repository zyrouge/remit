const p = require("path");
const fs = require("fs-extra");
const archiver = require("archiver");
const { spawn } = require("cross-spawn");

const rootDir = p.resolve(__dirname, "..");
const outputArtifactsDir = p.join(rootDir, "output-artifacts");

/**
 * @type {Record<"info" | "success" | "error", (string, string) => void>}
 */
const log = {
    info: (tag, text) => console.log(`[info] ${tag}: ${text}`),
    success: (tag, text) => console.log(`[success] ${tag}: ${text}`),
    error: (tag, text) => console.log(`[error] ${tag}: ${text}`),
};

/**
 * @param  {Parameters<typeof spawn>} args
 * @returns {Promise<number | null>}
 */
function asyncSpawn(...args) {
    const child = spawn(...args);
    return new Promise((resolve, reject) => {
        child.once("close", (code) => {
            if (code === 0) {
                return resolve(code);
            }
            return reject(`Spawned process exited with ${code} exit code`);
        });
    });
}

/**
 * @param {string} input
 * @param {string} output
 * @returns {Promise<void>}
 */
function createTarGz(input, output) {
    const outputStream = fs.createWriteStream(output);
    const archive = archiver("tar", {
        gzip: true,
    });
    archive.pipe(outputStream);
    archive.directory(input, false);
    return archive.finalize();
}

/**
 * @param {string} input
 * @param {string} output
 * @returns {Promise<void>}
 */
function createZip(input, output) {
    const outputStream = fs.createWriteStream(output);
    const archive = archiver("zip");
    archive.pipe(outputStream);
    archive.directory(input, false);
    return archive.finalize();
}

module.exports = {
    rootDir,
    outputArtifactsDir,
    log,
    asyncSpawn,
    createTarGz,
    createZip,
};
