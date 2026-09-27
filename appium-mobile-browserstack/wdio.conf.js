require('dotenv').config({ override: true });

exports.config = {
  user: process.env.BROWSERSTACK_USERNAME,
  key: process.env.BROWSERSTACK_ACCESS_KEY,

  services: [
    [
      'browserstack',
      {
        buildIdentifier: '${BUILD_NUMBER}',
        app: process.env.BROWSERSTACK_APP_ID,
        testObservability: false,
      }
    ]
  ],

  capabilities: [{
    platformName: 'Android',
    'appium:platformVersion': '12.0',
    'appium:deviceName': 'Samsung Galaxy S22 Ultra',
    'bstack:options': {}
  }],

  commonCapabilities: {
    'bstack:options': {
      projectName: 'LuxeQuality task.8',
      buildName: 'Mobile Automation Build - Device 1',
      sessionName: 'task.8 run - Galaxy S22 Ultra',
      debug: true,
    }
  },

  maxInstances: 1,
  updateJob: false,
  specs: ['./e2e/specs/**.specs.js'],
  exclude: [],

  reporters: [
    'spec',
    ['allure', {
      outputDir: 'allure-results',
      disableWebdriverStepsReporting: false,
      disableWebdriverScreenshotsReporting: false,
    }]
  ],

  logLevel: 'info',
  coloredLogs: true,
  screenshotPath: './errorShots/',
  baseUrl: '',
  waitforTimeout: 10000,
  connectionRetryTimeout: 90000,
  connectionRetryCount: 3,

  framework: 'mocha',
  mochaOpts: {
    ui: 'bdd',
    timeout: 40000
  }
};

exports.config.capabilities.forEach(function (caps) {
  if (exports.config.commonCapabilities['bstack:options']) {
    caps['bstack:options'] = { 
      ...caps['bstack:options'], 
      ...exports.config.commonCapabilities['bstack:options'] 
    };
  }
  for (let key in exports.config.commonCapabilities) {
    if (key !== 'bstack:options') {
      caps[key] = { ...caps[key], ...exports.config.commonCapabilities[key] };
    }
  }
});