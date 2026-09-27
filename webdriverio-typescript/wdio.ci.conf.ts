import { config as sharedConfig } from './wdio.shared.conf';

export const config = {
    ...sharedConfig,
    capabilities: [{
        browserName: 'chrome',
        'goog:chromeOptions': {
            args: [
                '--headless=new',
                '--window-size=1920,1080',
                '--disable-gpu',
                '--no-sandbox',
                '--disable-dev-shm-usage',
                '--disable-setuid-sandbox'
            ]
        }
    }],
    before: async () => {
        await browser.setWindowSize(1920, 1080);
    }
} as WebdriverIO.Config;
