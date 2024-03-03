const { parseVersion, updateVersion, stringifyVersion } = require("./_version");

const start = async () => {
    const oldVersion = await parseVersion();
    const now = new Date();
    const year = now.getFullYear();
    const month = now.getMonth() + 1;
    const date = now.getDate();
    const versionName = `${year}.${month}.${date}`;
    const versionCode =
        oldVersion.name === versionName ? oldVersion.code + 1 : 0;
    await updateVersion(versionName, versionCode);
    console.log(stringifyVersion(versionName, versionCode));
};

start();
