export const config: Partial<WebdriverIO.Config> = {
    runner: 'local',
    tsConfigPath: './tsconfig.json',

    specs: [
        './test/specs/**/*.ts'
    ],
    exclude: [],

    maxInstances: 10,
    logLevel: 'info',
    bail: 0,
    baseUrl: 'https://telnyx.com',
    waitforTimeout: 15000,
    connectionRetryTimeout: 180000,
    connectionRetryCount: 3,

    framework: 'mocha',
    reporters: ['spec', ['allure', { outputDir: 'allure-results' }]],

    mochaOpts: {
        ui: 'bdd',
        timeout: 60000
    },

    specFileRetries: 1,

    afterTest: async function (test, _context, { passed }) {
        if (!passed) {
            const safeName = `${test.parent}-${test.title}`
                .replace(/[:"/\\|?*<>]/g, '')
                .replace(/\s+/g, '_');
            await browser.saveScreenshot(`errorShots/${safeName}.png`);
        }
    },
};
