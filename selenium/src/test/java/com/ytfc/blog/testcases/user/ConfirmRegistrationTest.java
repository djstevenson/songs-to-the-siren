package com.ytfc.blog.testcases.user;

import com.ytfc.blog.pages.NotificationPage;
import com.ytfc.blog.utility.Helper;
import com.ytfc.blog.testcases.TestObject;

import org.testng.annotations.Test;

public class ConfirmRegistrationTest extends TestObject {


    @Test
    public void registrationConfirm() {

        testUserRegistration("refconfuser1", "Single reg");
    }

    private void testUserRegistration(String name, String prefix) {

        var registerPage = registerPage();
        registerPage.registerQuick(name);

        testConfirmUser(name, prefix);
    }

    @Test
    public void registrationConfirmThenConfirm() {
        // The second confirm should return a 404

        String username = "regconfuser2";
        String prefix = "Dbl reg";

        testUserRegistration(username, prefix);

        // Repeat confirmation
        testReconfirmUser(username, prefix);
    }

    private void testConfirmUser(String name, String prefix) {
        var testEmailPage = loadEmailPage("registration", name);

        String goodConfirmURL = testEmailPage.getGoodConfirmURL();
        Helper.get(driver, goodConfirmURL);

        // Test we get the registration-confirmed page
        NotificationPage notificationPage = notificationPage();
        notificationPage.assertNotificationHeader("Registration confirmed", prefix + " - confirmed header");
        notificationPage.assertNotificationMessage("You have confirmed registration of this account.", prefix + " - confirmed msg");

        // Test the user settings
        testUserPage()
            .get(name)
            .assertName(name, prefix)
            .assertConfirmed("yes", prefix);
    }

    private void testReconfirmUser(String name, String prefix) {
        var testEmailPage = loadEmailPage("registration", name);

        String goodConfirmURL = testEmailPage.getGoodConfirmURL();
        Helper.get(driver, goodConfirmURL);

        // Test we get a 404 page
        testEmailPage.assert404("Re-use of confirmation links produces a 404");
    }

    @Test
    public void registerDecline() {

        String username = "regdeclineuser1";

        var registerPage = registerPage();
        registerPage.registerQuick(username);

        var testEmailPage = testEmailPage();
        testEmailPage.get("registration", username);

        String goodDeclineURL = testEmailPage.getGoodDeclineURL();
        Helper.get(driver, goodDeclineURL);

        // Test we get the registration-declined page
        var notificationPage = notificationPage();
        notificationPage.assertNotificationHeader("Registration declined", "Registration declined header");
        notificationPage.assertNotificationMessage("You have declined registration of this account.", "Registered - confirmed msg");

        // Test the user was deleted
        testUserPage()
            .get(username)
            .assert404("Test user not found");
    }
    
    @Test
    public void registerConfirmThenDecline() {

        String username = "regdeclineuser2";

        var registerPage = registerPage();
        registerPage.registerQuick(username);

        var testEmailPage = testEmailPage();
        testEmailPage.get("registration", username);


        // Confirm registration, then try declining it
        String goodConfirmURL = testEmailPage.getGoodConfirmURL();
        String goodDeclineURL = testEmailPage.getGoodDeclineURL();
        Helper.get(driver, goodConfirmURL);
        Helper.get(driver, goodDeclineURL);

        testEmailPage.assert404("Re-use of confirmation links produces a 404");
    }

    @Test
    public void registerDeclineThenConfirm() {

        String username = "regdeclineuser3";

        var registerPage = registerPage();
        registerPage.registerQuick(username);

        var testEmailPage = testEmailPage();
        testEmailPage.get("registration", username);

        // Decline then try to confirm
        String goodDeclineURL = testEmailPage.getGoodDeclineURL();
        String goodConfirmURL = testEmailPage.getGoodConfirmURL();
        Helper.get(driver, goodDeclineURL);
        Helper.get(driver, goodConfirmURL);

        // 404 cos user not found
        testEmailPage.assert404("DtC: 404 if attempt to confirm already-declined user");
    }


    @Test
    public void registerDeclineThenDecline() {

        String username = "regdeclineuser4";

        var registerPage = registerPage();
        registerPage.registerQuick(username);

        var testEmailPage = testEmailPage();
        testEmailPage.get("registration", username);

        // Try to decline twice
        String goodDeclineURL = testEmailPage.getGoodDeclineURL();
        Helper.get(driver, goodDeclineURL);
        Helper.get(driver, goodDeclineURL);

        // 404 cos user not found
        testEmailPage.assert404("DtD: 404 if attempt to confirm already-declined user");
    }

    @Test
    public void registerBadConfirmationLinks() {

        // Register two users, and mangle the key on the first,
        // then the id on the second.
        String username1 = "regdeclineuser5";
        String username2 = "regdeclineuser6";

        var registerPage = registerPage();
        registerPage.registerQuick(username1);

        registerPage = registerPage();
        registerPage.registerQuick(username2);

        // URL with bad key
        var testEmailPage = testEmailPage();
        testEmailPage.get("registration", username1);
        String badDeclineUrlKey = testEmailPage.getBadConfirmURL("key");

        // URL with bad id
        testEmailPage.get("registration", username2);
        String badDeclineUrlId = testEmailPage.getBadConfirmURL("id");

        // We return a 404 if the user key is bad
        Helper.get(driver, badDeclineUrlKey);
        testEmailPage.assert404("Bad confirmation user key returns 404");

        // We return a 404 if the user id is bad
        Helper.get(driver, badDeclineUrlId);
        testEmailPage.assert404("Bad confirmation user id returns 404");
    }

    
}
