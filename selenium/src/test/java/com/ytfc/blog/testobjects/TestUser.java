package com.ytfc.blog.testobjects;

import com.ytfc.blog.pages.user.LoginPage;
import com.ytfc.blog.utility.Helper;

import org.openqa.selenium.WebDriver;
import org.openqa.selenium.support.PageFactory;

public class TestUser {
    protected WebDriver driver;
    protected int id;
    protected String userName;
    protected String email;
    protected String plainPassword;

    public TestUser(WebDriver driver, String userName) {
        this.driver = driver;
        this.userName = userName;

        // This is duping code in the test perl controller :(
        String lcUserName = userName.toLowerCase().replaceAll("\\s+", "-");      
        this.email = lcUserName + "@example.com";
        this.plainPassword = "PW "   + lcUserName;

        this.id = Helper.createTestUser(driver, userName);
    }

    public TestUser quickLogin() {
        PageFactory.initElements(driver, LoginPage.class)
            .login(userName, plainPassword);
        return this; // Chainable
    }

    public int getId() {
        return id;
    }

    public String getUserName() {
        return userName;
    }

    public String getEmail() {
        return email;
    }

    public String getPlainPassword() {
        return plainPassword;
    }

}
