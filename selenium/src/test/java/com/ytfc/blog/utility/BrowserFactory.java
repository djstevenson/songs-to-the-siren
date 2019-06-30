package com.ytfc.blog.utility;

import java.util.concurrent.TimeUnit;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.safari.SafariDriver;

public class BrowserFactory {
    public static WebDriver startApplication(WebDriver driver, String browserName) {
        if (browserName.equals("Chrome")) {
            driver = new ChromeDriver();
        }
        else if (browserName.equals("Firefox")) {
            driver = new FirefoxDriver();
        }
        else if (browserName.equals("Safari")) {
            driver = new SafariDriver();
        }
        else {
            // TODO IE and/or Edge
            System.out.println("Browser not supported");
        }

        driver.manage().timeouts().pageLoadTimeout(15, TimeUnit.SECONDS);

        return driver;
    }

    public static void stopApplication(WebDriver driver) {
        driver.quit();
    }

}
