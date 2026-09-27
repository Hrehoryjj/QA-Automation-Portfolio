import { config as sharedConfig } from './wdio.shared.conf';

export const config = {
    ...sharedConfig,
    capabilities: [{
        browserName: 'chrome',
        'goog:chromeOptions': {
            args: ['--headless=new', '--window-size=1920,1080', '--disable-gpu']
        }
    }],
} as WebdriverIO.Config;
