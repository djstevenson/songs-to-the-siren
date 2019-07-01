package com.ytfc.blog.testcases;

import com.ytfc.blog.utility.BrowserFactory;
import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.pages.*;
import com.ytfc.blog.pages.user.*;

import org.testng.annotations.BeforeClass;
import org.testng.annotations.AfterClass;
import org.openqa.selenium.support.PageFactory;

import com.ytfc.blog.SeleniumBase;

public class TestObject extends SeleniumBase {

    @BeforeClass
    public void setup() {
        driver = BrowserFactory.startApplication(driver, Helper.getBrowser());
    }

    @AfterClass
    public void tearDown() {
        BrowserFactory.stopApplication(driver);
    }

    // A bunch of methods to create page objects.
    // Provided as a convenience to wrap calls to the
    // PageFactory and make tests more readable.
    protected LoginPage loginPage() {
        return PageFactory.initElements(driver, LoginPage.class);
    }


}
