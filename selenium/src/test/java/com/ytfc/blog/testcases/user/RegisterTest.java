package com.ytfc.blog.testcases.user;

import com.ytfc.blog.testcases.TestObject;
import com.ytfc.blog.testobjects.TestUser;

import org.testng.annotations.Test;

public class RegisterTest extends TestObject {


    @Test
    public void registerForm() {

        // get() checks page title etc.
        registerPage().get();
    }
    

    @Test
    public void registerBad() {

        // Create test users
        new TestUser(driver, "registertest1");
        new TestUser(driver, "register tst2");

        class RegisterTestCase {
            String testName;
            String name;
            String email;
            String password;
            String nameError;
            String emailError;
            String passwordError;

            RegisterTestCase(String testName, String name, String email, String password, String nameError, String emailError, String passwordError) {
                this.testName      = testName;
                this.name          = name;
                this.email         = email;
                this.password      = password;
                this.nameError     = nameError;
                this.emailError    = emailError;
                this.passwordError = passwordError;
            }
        }

        RegisterTestCase testCases[] = {
            new RegisterTestCase("All empty",                  "",                 "",                           "",                       "Required",                               "Required",                 "Required"),
            new RegisterTestCase("Name too short",             "x",                "",                           "",                       "Minimum length 3",                       "Required",                 "Required"),
            new RegisterTestCase("All too short",              "x",                "y@y",                        "z",                      "Minimum length 3",                       "Invalid email address",    "Minimum length 5"),
            new RegisterTestCase("User exists",                "registertest1",    "rt@example.com",             "PW reg1",                "Name already in use",	                 "",                         ""),
            new RegisterTestCase("Email exists",               "registertest2",    "registertest1@example.com",  "PW reg1",                "",	                                     "Email already registered", ""),
            new RegisterTestCase("User and Email exist",       "registertest1",    "registertest1@example.com",  "PW reg1",                "Name already in use",	                 "Email already registered", ""),
            new RegisterTestCase("Name exists after trim",     " registertest1 ",  "registertest2@example.com",  "PW reg1",                "Name already in use",                    "",                         ""),
            new RegisterTestCase("Name exists after collapse", "register   tst2",  "registertest2@example.com",  "PW reg1",                "Name already in use",                    "",                         ""),
            new RegisterTestCase("Reject password w/ name",    "register pw name", "registerpwname@example.com", "PW register pw name xx", "",                                       "",                         "Password must not contain user name"),
        };

        for (var test : testCases) {
            var form = registerPage()
                .register(test.name, test.email, test.password)
                .getForm();

            form.getField("name").assertErrorValue(test.nameError, test.testName + ": Name error");
            form.getField("email").assertErrorValue(test.emailError, test.testName + ": Email error");
            form.getField("password").assertErrorValue(test.passwordError, test.testName + ": Password error");
        }
    }

    @Test
    public void registerGood() {

        registerPage().register("regtestgood1", "regtestgood1@example.com", "PW my good password");

        // Redirects to a 'registered' notificationpage
        notificationPage()
            .assertFlashMessage("Registered - watch out for confirmation email", "Registered - flash")
            .assertNotificationHeader("Registered", "Registered - page header")
            .assertNotificationMessage("Thank you for your registration request.", "Registered - page msg");

        // Test the user settings
        testUserPage()
            .get("regtestgood1")
            .assertName       ("regtestgood1",             "Registered user - name")
            .assertEmail      ("regtestgood1@example.com", "Registered user - email")
            .assertConfirmed  ("no",                       "Registered user - new user not confirmed");

    }

}
