import { defineConfig } from "cypress";
import createBundler from "@bahmutov/cypress-esbuild-preprocessor";
import { addCucumberPreprocessorPlugin } from "@badeball/cypress-cucumber-preprocessor";
import { createEsbuildPlugin } from "@badeball/cypress-cucumber-preprocessor/esbuild";
import reporterPlugin from "cypress-mochawesome-reporter/plugin";

// Cypress keeps only the last handler registered for an event, so the Mochawesome
// reporter and the Cucumber preprocessor overwrite each other's before:run/after:run
// handlers. This wrapper registers one handler per event that calls all of them.
function shareEventHandlers(on: Cypress.PluginEvents): Cypress.PluginEvents {
  const handlers: Record<string, Array<(...args: any[]) => unknown>> = {};
  return ((event: string, handler: any) => {
    if (event === "task" || event === "file:preprocessor") {
      return (on as any)(event, handler);
    }
    if (!handlers[event]) {
      handlers[event] = [];
      (on as any)(event, async (...args: unknown[]) => {
        let result: unknown;
        for (const registered of handlers[event]) {
          const value = await registered(...args);
          if (value !== undefined) result = value;
        }
        return result;
      });
    }
    handlers[event].push(handler);
  }) as Cypress.PluginEvents;
}

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
    async setupNodeEvents(cypressOn, config) {
      const on = shareEventHandlers(cypressOn);
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
