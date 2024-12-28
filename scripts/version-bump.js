const { parseVersion, updateVersion } = require("./_version");

const start = async () => {
    const oldVersion = await parseVersion();
    const version = oldVersion.bump();
    await updateVersion(version);
    console.log(version.toString());
};

start();
