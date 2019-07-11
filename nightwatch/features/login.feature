Feature: Login

Scenario: Login page looks right

    Given I open the login page
    Then The title is "Login"

Scenario: Empty login shows the right errors

    Given I open the login page
    When I click on the login button
    Then The "username" field has error: "Required"
    And  The "password" field has error: "Required"

Scenario: Login with short name shows right error

    Given I open the login page
    When I enter "x" as "username" field
    And I click on the login button
    Then The "username" field has error: "Minimum length 3"
    And  The "password" field has error: "Required"

Scenario: Login with short name and password shows right errors

    Given I open the login page
    When I enter "x" as "username" field
    And I enter "x" as "password" field
    And I click on the login button
    Then The "username" field has error: "Minimum length 3"
    And  The "password" field has error: "Minimum length 5"

Scenario: Login with made-up name/password shows right errors

    Given I open the login page
    When I enter "abc" as "username" field
    And I enter "abcde" as "password" field
    And I click on the login button
    Then The "username" field has error: "Name and/or password incorrect"

Scenario: Good login works ok

    Given I create a user named "logintest1"
    And I open the login page
    When I enter "logintest1" as "username" field
    And I enter "PW logintest1" as "password" field
    And I click on the login button
    Then The user is logged in

