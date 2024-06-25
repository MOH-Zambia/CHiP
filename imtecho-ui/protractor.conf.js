const HtmlScreenshotReporter = require('protractor-jasmine2-screenshot-reporter');
const path = require('path');
const Helper = require('./test/protractor-helper');
const seleniumJar = require('selenium-server-standalone-jar');

const defaultDirectory = path.normalize(path.resolve(__dirname, './test/download'));
const dateString = Helper.getDateString();
const reporter = new HtmlScreenshotReporter({
    dest: 'test/reports/' + dateString,
    filename: 'e2e-test-report.html',
    reportTitle: 'Test Report - ' + dateString
});

exports.config = {
    chromeDriver: Helper.getChromeDriverPath(),
    seleniumServerJar: seleniumJar.path,
    specs: Helper.getSpecs(),
    suites: Helper.getSuites(),
    jasmineNodeOpts: {
        defaultTimeoutInterval: 240000,
        realtimeFailure: true
    },
    multiCapabilities: [Helper.getChromeOptions(defaultDirectory)],
    framework: 'jasmine',

    // Setup the report before any tests start
    beforeLaunch: function () {
        return new Promise(function (resolve) {
            reporter.beforeLaunch(resolve);
        });
    },

    // Assign the test reporter to each running instance
    onPrepare: function () {
        if (browser.params.TEST_TARGET) {
            process.env.TEST_TARGET = browser.params.TEST_TARGET;
        }
        console.log('process.env.TEST_TARGET >>>>>>', process.env.TEST_TARGET);

        jasmine.getEnv().addReporter(reporter);
        browser.driver.manage().window().maximize();
        browser.manage().window().maximize();

        // For non Angular pages
        browser.ignoreSynchronization = true;

        // Custom locators
        Helper.addCustomLocators(protractor);
    },

    // Close the report after all tests finish
    afterLaunch: function (exitCode) {
        return new Promise(function (resolve) {
            reporter.afterLaunch(resolve.bind(this, exitCode));
        });
    }
};
