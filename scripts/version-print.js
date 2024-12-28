const { parseVersion } = require("./_version");

const start = async () => {
    const version = await parseVersion();
    console.log(version.toString());
};

start();
