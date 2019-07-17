Feature: Registration

Scenario: Registration page looks right

    Given I open the registration page
    Then The title is: Register

Scenario: Empty registration shows the right errors

    Given I open the registration page
    When I click on the register button
    Then The username registration field has error: Required
    And The email registration field has error: Required
    And  The password registration field has error: Required

Scenario: Registration with short name shows right error

    Given I open the registration page
    When I enter "x" into the username registration field
    And I click on the register button
    Then The username registration field has error: Minimum length 3

Scenario: Registration with invalid email shows right error

    Given I open the registration page
    When I enter "x@x" into the email registration field
    And I click on the register button
    Then The email registration field has error: Invalid email address

Scenario: Registration with short password shows right error

    Given I open the registration page
    When I enter "x" into the password registration field
    And I click on the register button
    Then The password registration field has error: Minimum length 5

Scenario: Existing usernames rejected

    Given There is a user named: regtest1
    And I open the registration page
    When I enter "regtest1" into the username registration field
    And I enter "regtest1@new.example.com" into the email registration field
    And I enter "PW regtest1" into the password registration field
    And I click on the register button
    Then The username registration field has error: Name already in use

Scenario: Existing emails rejected

    Given There is a user named: regtest2
    And I open the registration page
    When I enter "regtest2new" into the username registration field
    And I enter "regtest2@example.com" into the email registration field
    And I enter "PW regtest2" into the password registration field
    And I click on the register button
    Then The email registration field has error: Email already registered

Scenario: Good new user registers ok and gets confirmation email

    When I open the registration page
    And I enter "regtest3" into the username registration field
    And I enter "regtest3@example.com" into the email registration field
    And I enter "PW for reg test 3" into the password registration field
    And I click on the register button
    Then The registration-accepted page is showing
    And A flash message says: Registered - watch out for confirmation email
    And The user is logged out
    And The user "regtest3x" has a registration email
