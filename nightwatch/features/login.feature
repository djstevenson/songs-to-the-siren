Feature: Login

Scenario: Login page looks right

    Given I open the login page
    Then The title is "Login"

Scenario: Empty login shows the right errors

    Given I open the login page
    When I click on the login button
    Then The "username" login field has error: "Required"
    And  The "password" login field has error: "Required"

Scenario: Login with short name shows right error

    Given I open the login page
    When I enter "x" as "username" login field
    And I click on the login button
    Then The "username" login field has error: "Minimum length 3"
    And  The "password" login field has error: "Required"

Scenario: Login with short name and password shows right errors

    Given I open the login page
    When I enter "x" as "username" login field
    And I enter "x" as "password" login field
    And I click on the login button
    Then The "username" login field has error: "Minimum length 3"
    And  The "password" login field has error: "Minimum length 5"

Scenario: Good login works ok

    Given I create a user named "logintest1"
    And I open the login page
    When I enter "logintest1" as "username" login field
    And I enter "PW logintest1" as "password" login field
    And I click on the login button
    Then The user is logged in

Scenario: Bad username fails login

    Given I create a user named "logintest2"
    And I open the login page
    When I enter "logintest2x" as "username" login field
    And I enter "PW logintest2" as "password" login field
    And I click on the login button
    Then The "username" login field has error: "Name and/or password incorrect"


Scenario: Good username with bad password fails login, in same way as bad username

    Given I create a user named "logintest3"
    And I open the login page
    When I enter "logintest3" as "username" login field
    And I enter "PW logintest2" as "password" login field
    And I click on the login button
    Then The "username" login field has error: "Name and/or password incorrect"

Scenario: Bad username AND password shows same error as bad username

    Given I open the login page
    When I enter "abc" as "username" login field
    And I enter "abcde" as "password" login field
    And I click on the login button
    Then The "username" login field has error: "Name and/or password incorrect"

