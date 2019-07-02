package com.ytfc.blog.testcases.user;

import com.ytfc.blog.testcases.TestObject;
import com.ytfc.blog.testobjects.TestUser;
import com.ytfc.blog.pages.LoggedInPage;

import org.testng.annotations.Test;

public class LoginTest extends TestObject {


    @Test
    public void loginForm() {
        loginPage()
            .get()
            .assertPageTitle("Login", "Got 'Login' page title");
    }

    @Test
    public void loginBad() {


        // Create some test users
        new TestUser(driver, "logintest1");       // No spaces
        new TestUser(driver, "logintest%202");    // One space "logintest 2"
        new TestUser(driver, "logintest%20%203"); // Two spaces, should be collapsed "logintest  3" to "logintest 3"

        class LoginTestCase {
            String testName;
            String name;
            String password;
            String nameError;
            String passwordError;

            LoginTestCase(String testName, String name, String password, String nameError, String passwordError) {
                this.testName      = testName;
                this.name          = name;
                this.password      = password;
                this.nameError     = nameError;
                this.passwordError = passwordError;
            }
        }

        LoginTestCase testCases[] = {
            new LoginTestCase("Both empty",                        "",            "",                 "Required",                       "Required"),
            new LoginTestCase("Name too short",                    "x",           "",                 "Minimum length 3",               "Required"),
            new LoginTestCase("Name and password too short",       "x",           "y",                "Minimum length 3",               "Minimum length 5"),
            new LoginTestCase("Name and password incorrect",       "abc",         "abcde",            "Name and/or password incorrect",	""),
            new LoginTestCase("Name incorrect",                    "log1ntest1",  "PW logintest1",    "Name and/or password incorrect", ""),
            new LoginTestCase("Password incorrect",                "logintest1",  "PW log1ntest1",    "Name and/or password incorrect", ""),
            new LoginTestCase("Multi-space pswds not collapsed",   "logintest 2", "PW logintest  2",  "Name and/or password incorrect", ""),
            new LoginTestCase("Leading passwd space not ignored",  "logintest1",  " PW logintest1",   "Name and/or password incorrect", ""),
            new LoginTestCase("Trailing passwd space not ignored", "logintest1",  "PW logintest1 ",   "Name and/or password incorrect", ""),
        };


        for (var test : testCases) {
            var form = loginPage()
                .login(test.name, test.password)
                .getForm();

            form.getField("name").assertErrorValue(test.nameError, test.testName + ": Name error");
            form.getField("password").assertErrorValue(test.passwordError, test.testName + ": Password error");
        }
    }

    @Test
    public void loginGood() {

        new TestUser(driver, "logintest4");

        loginPage().login("logintest4", "PW logintest4");

        loggedInPage().assertLoggedInAs("logintest4", "User logintest4 is logged-in");

    }

}
