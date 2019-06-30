package com.ytfc.blog.utility;

import java.util.concurrent.TimeUnit;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;

// TODO Docs

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;
import org.testng.Assert;

import com.ytfc.blog.utility.ConfigDataProvider;

public class Helper {
    protected static ConfigDataProvider config = new ConfigDataProvider();

    public static String getCurrentDateTime() {
        DateFormat format = new SimpleDateFormat("yyyy_MM_dd_HH_mm_ss");
        Date date = new Date();
        return format.format(date);
    }

    public static void get(WebDriver driver, String path) {
        String url;
        if (path.startsWith("/")) {
            url = config.getTestURI() + path;
        } else {
            url = config.getTestURI() + "/" + path;
        }

        driver.get(url);
        driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS);
    }

    public static String getBrowser() {
        return config.getBrowser();
    }

    // public static void assertErrorPage(WebDriver driver, String message) {
    //     PageFactory.initElements(driver, ServerErrorPage.class)
    //         .assertException("message");
    // }

    // Asserts link present, or not.
    public static void assertLink(WebDriver driver, String linkText, boolean expected, String message) {
        driver.manage().timeouts().implicitlyWait(1, TimeUnit.SECONDS);
        boolean actual = driver.findElements(By.linkText(linkText)).size() > 0;
        driver.manage().timeouts().implicitlyWait(15, TimeUnit.SECONDS);
        Assert.assertEquals(actual, expected, message);
    }
    
}
