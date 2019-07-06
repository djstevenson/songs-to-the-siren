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

    protected void assertUserLogin(String prefix, String name, String password) {
        loginPage().login(name, password);
        loggedInPage().assertLoggedInAs(name, prefix + "Login with new password");
    }
    
    protected void assertUserNoLogin(String prefix, String name, String password) {
        loginPage().login(name, password);
        loggedInPage().assertLoggedOut(prefix + "No login with old password");
    }

    // A bunch of methods to create page objects.
    // Provided as a convenience to wrap calls to the
    // PageFactory and make tests more readable.
    protected TestEmailPage loadEmailPage(String type, String name) {
        return testEmailPage()
            .get(type, name);
    }

    protected LoginPage loginPage() {
        return PageFactory.initElements(driver, LoginPage.class);
    }

    protected LoggedInPage loggedInPage() {
        return PageFactory.initElements(driver, LoggedInPage.class);
    }

    protected ForgotPasswordPage forgotPasswordPage() {
        return PageFactory.initElements(driver, ForgotPasswordPage.class);
    }

    protected ForgotNamePage forgotNamePage() {
        return PageFactory.initElements(driver, ForgotNamePage.class);
    }

    protected PasswordResetPage passwordResetPage() {
        return PageFactory.initElements(driver, PasswordResetPage.class);
    }

    protected NotificationPage notificationPage() {
        return PageFactory.initElements(driver, NotificationPage.class);
    }

    protected RegisterPage registerPage() {
        return PageFactory.initElements(driver, RegisterPage.class);
    }

    protected TestEmailPage testEmailPage() {
        return PageFactory.initElements(driver, TestEmailPage.class);
    }

    protected TestUserPage testUserPage() {
        return PageFactory.initElements(driver, TestUserPage.class);
    }

}
