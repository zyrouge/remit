const { parseVersion, stringifyVersion } = require("./_version");

const start = async () => {
    const version = await parseVersion();
    console.log(stringifyVersion(version.name, version.code));
};

start();
