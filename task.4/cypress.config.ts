import { defineConfig } from "cypress";
import createBundler from "@bahmutov/cypress-esbuild-preprocessor";
import { addCucumberPreprocessorPlugin } from "@badeball/cypress-cucumber-preprocessor";
import { createEsbuildPlugin } from "@badeball/cypress-cucumber-preprocessor/esbuild";
import reporterPlugin from "cypress-mochawesome-reporter/plugin";

export default defineConfig({
  reporter: 'cypress-mochawesome-reporter',
  reporterOptions: {
    reportDir: 'cypress/reports',
    reportFilename: 'index',
    overwrite: true,
    html: true,
    json: false
  },
  e2e: {
    baseUrl: "https://telnyx.com",
    viewportWidth: 1920,  
    viewportHeight: 1080,
    specPattern: "cypress/e2e/**/*.feature", 
    async setupNodeEvents(on, config) {
      reporterPlugin(on);
      
      await addCucumberPreprocessorPlugin(on, config);
      on(
        "file:preprocessor",
        createBundler({
          plugins: [createEsbuildPlugin(config)],
        })
      );

      return config;
    },
  },
});