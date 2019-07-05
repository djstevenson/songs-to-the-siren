package com.ytfc.blog.testcases.user;

import com.ytfc.blog.forms.FormObject;
import com.ytfc.blog.testcases.TestObject;
import com.ytfc.blog.testobjects.TestUser;

import org.testng.annotations.Test;

public class ForgotNameTest extends TestObject {

    @Test
    public void forgotNameForm() {

        var forgotNamePage = forgotNamePage();
        forgotNamePage.get();
    }

    @Test
    public void badEmails() {

        class BadEmailTestCase {
            String testName;
            String email;
            String emailError;

            BadEmailTestCase(String testName, String email, String emailError) {
                this.testName = testName;
                this.email = email;
                this.emailError = emailError;
            }
        }

        BadEmailTestCase testCases[] = { new BadEmailTestCase("Empty", "", "Required"),
                new BadEmailTestCase("Too short", "y@y", "Invalid email address"),
                new BadEmailTestCase("Not email", "xyzzy", "Invalid email address"), };

        for (BadEmailTestCase test : testCases) {
            var forgotNamePage = forgotNamePage();
            forgotNamePage.submit(test.email);
            FormObject form = forgotNamePage.getForm();
            form.getField("email").assertErrorValue(test.emailError,
                    test.testName + ": Email error (" + test.email + ")");
        }
    }

    @Test
    public void goodEmailExists() {

        // Create test users
        String username1 = "forgotName1";
        String username2 = "forgotname2";
        TestUser user1 = new TestUser(driver, username1);
        TestUser user2 = new TestUser(driver, username2);

        forgotNamePage().submit(username1.toLowerCase() + "@example.com");
        assertNotificationPage();

        var testEmailPage = testEmailPage();
        testEmailPage.get("name_reminder", username1);
        testEmailPage.assertValidEmail(username1, "name_reminder email exists for " + username1);
        testEmailPage.assertData(username1, "name", "Email contains correct username");
        testEmailPage.assertData(user1.getId(), "user", "Email contains correct user id");

        // Rpt with mixed case
        forgotNamePage().submit(username2.toUpperCase() + "@Example.com");
        assertNotificationPage();

        testEmailPage = testEmailPage();
        testEmailPage.get("name_reminder", username2);
        testEmailPage.assertValidEmail(username2, "name_reminder email exists for " + username2);
        testEmailPage.assertData(username2, "name", "Email contains correct username");
        testEmailPage.assertData(user2.getId(), "user", "Email contains correct user id");
    }

    @Test
    public void goodEmailNotExists() {

        // Create test user
        String username1 = "forgotname1x";

        var forgotNamePage = forgotNamePage();
        forgotNamePage.submit(username1 + "@example.com");
        forgotNamePage.getForm();
        assertNotificationPage();

        // Test there is no email for this user
        var testEmailPage = testEmailPage();
        testEmailPage.get("name_reminder", username1);
        testEmailPage.assertNotValidEmail("name_reminder email does not exist for " + username1);
    }

    private void assertNotificationPage() {
        var notificationPage = notificationPage();
        notificationPage.assertNotificationHeader("Name reminder", "Name reminder header");
        notificationPage.assertNotificationMessage("If there is a user with that email address, a login name reminder has been sent by email.", "Notification says we sent a reminder, even if we did not");
    }
}
