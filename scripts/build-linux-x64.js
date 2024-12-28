const p = require("path");
const fs = require("fs-extra");
const {
    rootDir,
    asyncSpawn,
    createTarGz,
    outputArtifactsDir,
    createZip,
    log,
} = require("./_utils");
const { stringifyVersion, parseVersion } = require("./_version");

const __script = "build-linux-x64";

const start = async () => {
    await asyncSpawn("flutter", ["build", "linux", "--release"], {
        cwd: rootDir,
        stdio: "inherit",
    });
    log.success(__script, "build finished");
    const inputDir = p.join(rootDir, "build/linux/x64/release/bundle");
    const version = (await parseVersion()).name;
    const outputTarPath = p.join(
        outputArtifactsDir,
        `remit-v${version}-linux-x64.tar.gz`
    );
    await fs.ensureDir(outputArtifactsDir);
    await createTarGz(inputDir, outputTarPath);
    log.success(__script, `packed into ${outputTarPath}`);
    const outputZipPath = p.join(
        outputArtifactsDir,
        `remit-v${version}-linux-x64.zip`
    );
    await createZip(inputDir, outputZipPath);
    log.success(__script, `packed into ${outputZipPath}`);
};

start();
