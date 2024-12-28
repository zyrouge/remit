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

const __script = "build-windows-x64";

const start = async () => {
    await asyncSpawn("flutter", ["build", "windows", "--release"], {
        cwd: rootDir,
        stdio: "inherit",
    });
    log.success(__script, "build finished");
    const inputDir = p.join(rootDir, "build/windows/x64/runner/Release");
    const version = stringifyVersion(await parseVersion());
    const outputTarPath = p.join(
        outputArtifactsDir,
        `remit-v${version}-windows-x64.tar.gz`
    );
    await fs.ensureDir(outputArtifactsDir);
    await createTarGz(inputDir, outputTarPath);
    log.success(__script, `packed into ${outputTarPath}`);
    const outputZipPath = p.join(
        outputArtifactsDir,
        `remit-v${version}-windows-x64.zip`
    );
    await createZip(inputDir, outputZipPath);
    log.success(__script, `packed into ${outputZipPath}`);
};

start();
