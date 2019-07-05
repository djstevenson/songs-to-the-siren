package com.ytfc.blog.testcases.user;

import com.ytfc.blog.pages.user.ForgotPasswordPage;
import com.ytfc.blog.forms.FormObject;
import com.ytfc.blog.testcases.TestObject;
import com.ytfc.blog.testobjects.TestUser;

import org.testng.annotations.Test;

public class ForgotPasswordTest extends TestObject {


    @Test
    public void forgotPasswordForm() {

        ForgotPasswordPage forgotPasswordPage = forgotPasswordPage();
        forgotPasswordPage.get();
    }

    @Test
    public void badEmails() {

        class BadEmailTestCase {
            String testName;
            String email;
            String emailError;

            BadEmailTestCase(String testName, String email, String emailError) {
                this.testName      = testName;
                this.email         = email;
                this.emailError    = emailError;
            }
        }

        BadEmailTestCase testCases[] = {
            new BadEmailTestCase("Empty",     "",      "Required"),
            new BadEmailTestCase("Too short", "y@y",   "Invalid email address"),
            new BadEmailTestCase("Not email", "xyzzy", "Invalid email address"),
        };

        for (var test : testCases) {
            var forgotPasswordPage = forgotPasswordPage();
            forgotPasswordPage.submit(test.email);
            FormObject form = forgotPasswordPage.getForm();
            form.getField("email").assertErrorValue(test.emailError, test.testName + ": Email error (" + test.email + ")");
        }
    }

    @Test
    public void goodEmailExists() {

        // Create test users
        String username1 = "forgotPassword1";
        String username2 = "forgotPassword2";
        TestUser user1 = new TestUser(driver, username1);
        TestUser user2 = new TestUser(driver, username2);

        forgotPasswordPage().submit(username1.toLowerCase() + "@example.com");
        assertNotificationPage();

        var testEmailPage = testEmailPage();
        testEmailPage.get("password_reset", username1);
        testEmailPage.assertValidEmail(username1, "password_reset email exists for " + username1);
        testEmailPage.assertDataExists("key", "Email contains a user key");
        testEmailPage.assertData(user1.getId(), "user", "Email contains correct user id");

        // Rpt with mixed case
        forgotPasswordPage().submit(username2.toUpperCase() + "@Example.com");
        assertNotificationPage();

        testEmailPage = testEmailPage();
        testEmailPage.get("password_reset", username2);
        testEmailPage.assertValidEmail(username2, "password_reset email exists for " + username2);
        testEmailPage.assertDataExists("key", "Email contains a user key");
        testEmailPage.assertData(user2.getId(), "user", "Email contains correct user id");
    }

    @Test
    public void goodEmailNotExists() {

        // Create test user
        String username1 = "forgotPassword1x";

        var forgotPasswordPage = forgotPasswordPage();
        forgotPasswordPage.submit(username1 + "@example.com");
        forgotPasswordPage.getForm();
        assertNotificationPage();

        // Test there is no email for this user
        var testEmailPage = testEmailPage();
        testEmailPage.get("password_reset", username1);
        testEmailPage.assertNotValidEmail("password_reset email does not exist for " + username1);
    }

    private void assertNotificationPage() {
        var notificationPage = notificationPage();
        notificationPage.assertNotificationHeader("Password reset", "Password reset header");
        notificationPage.assertNotificationMessage("If there is a user with that email address, a link has been sent by email which will allow resetting the password.", "Notification says we sent a reset, even if we did not");
    }
}
