const p = require("path");
const fs = require("fs-extra");

const rootDir = p.resolve(__dirname, "../..");
const appTranslationsDir = p.join(rootDir, "lib/services/translations");

/**
 * @type {import("phrasey").PhraseyHooksHandler}
 */
const hook = {
    onSchemaParsed: async ({ phrasey, state, log }) => {
        if (!needsSync(phrasey.options.source)) {
            log.info("Skipping post-build due to non-build source");
            return;
        }
        await createTranslationDart(phrasey, state, log);
    },
    onTranslationsBuildFinished: async ({ phrasey, state, log }) => {
        if (!needsSync(phrasey.options.source)) {
            log.info("Skipping post-build due to non-build source");
            return;
        }
        await createTranslationsDart(phrasey, state, log);
    },
};

module.exports = hook;

/**
 *
 * @param {string} source
 * @returns {bool}
 */
function needsSync(source) {
    return ["build", "watch"].includes(source);
}

/**
 *
 * @param {import("phrasey").Phrasey} phrasey
 * @param {import("phrasey").PhraseyState} state
 * @param {import("phrasey").PhraseyLogger} log
 */
async function createTranslationsDart(phrasey, state, log) {
    const translations = [...state.getTranslations().values()];
    const sortedTranslations = translations.sort((a, b) =>
        a.locale.display.localeCompare(b.locale.display)
    );
    const content = `
// ignore_for_file: eol_at_end_of_file

part of 'translations.dart';

abstract class RuiTranslations {
    static final List<String> localeCodes = <String>[
${sortedTranslations.map((x) => `        '${x.locale.code}',`).join("\n")}
    ];
    static final Map<String, String> localeDisplayNames = <String, String>{
${sortedTranslations
    .map((x) => `        '${x.locale.code}': '${x.locale.display}',`)
    .join("\n")}
    };
    static final Map<String, String> localeNativeNames = <String, String>{
${sortedTranslations
    .map((x) => `        '${x.locale.code}': '${x.locale.native}',`)
    .join("\n")}
    };

    static Future<RuiTranslation> resolve(final String locale) async =>
        _resolveTranslation(locale);

    static Future<RuiTranslation> resolveOrDefault([
        final String? locale,
    ]) async =>
        _resolveTranslationOrDefault(locale);
}
    `;
    const path = p.join(appTranslationsDir, "translations_part.dart");
    await fs.writeFile(path, content);
    log.success(`Generated "${p.relative(rootDir, path)}".`);
}

/**
 *
 * @param {import("phrasey").Phrasey} phrasey
 * @param {import("phrasey").PhraseyState} state
 * @param {import("phrasey").PhraseyLogger} log
 */
async function createTranslationDart(phrasey, state, log) {
    /**
     * @type {string[]}
     */
    const staticKeys = [];
    /**
     * @type {string[]}
     */
    const dynamicKeys = [];

    for (const x of state.getSchema().z.keys) {
        const varName = `${x.name[0].toLowerCase()}${x.name.slice(1)}`;
        if (x.parameters && x.parameters.length > 0) {
            const params = x.parameters
                .map((x) => `final String ${x}`)
                .join(", ");
            const callArgs = x.parameters.join(", ");
            dynamicKeys.push(
                `    String ${varName}(${params}) => _stringFormat(_keysJson['${x.name}']!, <String>[${callArgs}]);`
            );
        } else {
            staticKeys.push(
                `    String get ${varName} => _keysJson['${x.name}']!;`
            );
        }
    }

    const content = `
// ignore_for_file: eol_at_end_of_file

part of 'translation.dart';

class RuiTranslation {
    RuiTranslation(final Map<String, dynamic> json) :
        _localeJson = (json['locale'] as Map<dynamic, dynamic>).cast(),
        _keysJson = (json['keys'] as Map<dynamic, dynamic>).cast();

    final Map<String, String> _localeJson;
    final Map<String, String> _keysJson;

    String get localeDisplayName => _localeJson['display']!;
    String get localeNativeName => _localeJson['native']!;
    String get localeCode => _localeJson['code']!;
    String get localeDirection => _localeJson['direction']!;

${staticKeys.join("\n")}

${dynamicKeys.join("\n")}
}
    `;
    const path = p.join(appTranslationsDir, "translation_part.dart");
    await fs.writeFile(path, content);
    log.success(`Generated "${p.relative(rootDir, path)}".`);
}
