package com.ytfc.blog.testcases.user;

import com.ytfc.blog.pages.user.TestEmailPage;
import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.testcases.TestObject;
import com.ytfc.blog.testobjects.TestUser;

import org.testng.annotations.Test;

public class ConfirmPasswordResetTest extends TestObject {

    @Test
    public void doResetThenLogin() {
        // Do a good confirm, then attempt to re-use
        // the link, which should 404

        String username1 = "resetpw1";
        String prefix = "Dbl reset - ";

        // Register, then request a reset email
        new TestUser(driver, username1);
        var forgotPasswordPage = forgotPasswordPage();
        forgotPasswordPage.submit(username1.toLowerCase() + "@example.com");

        // Click the reset URL in the "email", and set a new password

        var testEmailPage = loadEmailPage("password_reset", username1);

        String goodResetURL = testEmailPage.getGoodResetURL();
        Helper.get(driver, goodResetURL);

        // Should now be on the reset page, so can enter a new p/w
        var resetPage = passwordResetPage();
        String newPassword = "2nd password!";
        resetPage.reset(newPassword);

        // Check reset notification
        var notificationPage = notificationPage();
        notificationPage.assertNotificationHeader("Password reset", prefix + "Confirmed reset header");
        notificationPage.assertNotificationMessage("Your password has been reset.", prefix + "Confirmed reset msg");

        // Should now be able to login with new p/w
        assertUserLogin(prefix, username1, newPassword);

        // Should NOT now be able to login with old p/w
        assertUserNoLogin(prefix, username1, "PW " + username1);

        // Re-fetch reset page. Should 404 this time
        Helper.get(driver, goodResetURL);
        notificationPage.assert404(prefix + "Re-using reset link returns 404");
    }

    @Test
    public void badResetURLs() {
        String username2 = "resetpw2";
        String prefix = "Bad reset - ";

        // Register, then request a reset email
        new TestUser(driver, username2);
        var forgotPasswordPage = forgotPasswordPage();
        forgotPasswordPage.submit(username2.toLowerCase() + "@example.com");

        // Click the confirm URL in the "email"
        TestEmailPage testEmailPage = loadEmailPage("password_reset", username2);

        String badResetURL1 = testEmailPage.getBadResetURL("id");
        String badResetURL2 = testEmailPage.getBadResetURL("key");

        Helper.get(driver, badResetURL1);
        testEmailPage.assert404(prefix + "Bad url (id) returns 404");
        Helper.get(driver, badResetURL2);
        testEmailPage.assert404(prefix + "Bad url (key) returns 404");

        // Can still login with old credentials
        assertUserLogin(prefix, username2, "PW " + username2);
    }

    
}
