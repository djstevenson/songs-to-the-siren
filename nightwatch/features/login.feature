Feature: Login

Scenario: Login page looks right

    When I open the login page
    Then The title is: Login

Scenario: Empty login shows the right errors

    When I open the login page
    And I click on the login button
    Then The username login field has error: Required
    And  The password login field has error: Required

Scenario: Login with short name shows right error

    When I open the login page
    And I enter "x" into the username login field
    And I click on the login button
    Then The username login field has error: Minimum length 3
    And  The password login field has error: Required

Scenario: Login with short name and password shows right errors

    When I open the login page
    And I enter "x" into the username login field
    And I enter "x" into the password login field
    And I click on the login button
    Then The username login field has error: Minimum length 3
    And  The password login field has error: Minimum length 5

Scenario: Good login works ok

    Given There is a user named logintest1
    And I open the login page
    When I enter "logintest1" into the username login field
    And I enter "PW logintest1" into the password login field
    And I click on the login button
    Then The user is logged in

Scenario: Bad username fails login

    Given There is a user named logintest2
    And I open the login page
    When I enter "logintest2x" into the username login field
    And I enter "PW logintest2" into the password login field
    And I click on the login button
    Then The username login field has error: Name and/or password incorrect


Scenario: Good username with bad password fails login, in same way as bad username

    Given There is a user named logintest3
    And I open the login page
    When I enter "logintest3" into the username login field
    And I enter "PW logintest2" into the password login field
    And I click on the login button
    Then The username login field has error: Name and/or password incorrect

Scenario: Bad username AND password shows same error as bad username

    Given I open the login page
    When I enter "abc" into the username login field
    And I enter "abcde" into the password login field
    And I click on the login button
    Then The username login field has error: Name and/or password incorrect

