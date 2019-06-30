package com.ytfc.blog.testcases;

import com.ytfc.blog.utility.BrowserFactory;
import com.ytfc.blog.utility.Helper;

import com.ytfc.blog.SeleniumBase;

import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;


public class TestObject extends SeleniumBase {

    @BeforeClass
    public void setup() {
        driver = BrowserFactory.startApplication(driver, Helper.getBrowser());
    }

    @AfterClass
    public void tearDown() {
        BrowserFactory.stopApplication(driver);
    }

}
