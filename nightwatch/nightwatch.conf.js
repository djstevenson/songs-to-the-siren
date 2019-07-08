const chromedriver = require('chromedriver');

module.exports = {
    page_objects_path: "./pages",

    test_settings: {
        default: {
            launch_url: "http://localhost:3000",
            webdriver: {
                start_process: true,
                server_path: chromedriver.path,
                port: 4444,
                cli_args: ['--port=4444']
            },
            desiredCapabilities: {
                browserName: 'chrome',
                javascriptEnabled: true,
                acceptSslCerts: true,
                chromeOptions: {
                    args: ['disable-gpu']
                }
            },
            screenshots: {
                enabled: true,
                path: 'screenshots'
            }
        },

        headless: {
            desiredCapabilities: {
                browserName: 'chrome',
                chromeOptions: {
                    args: ['headless', 'disable-gpu']
                }
            }
        }
    }
};
