Feature: Registration

Scenario: Registration page looks right

    Given I open the registration page
    Then The title is "Register"

Scenario: Empty registration shows the right errors

    Given I open the registration page
    When I click on the register button
    Then The "username" registration field has error: "Required"
    And The "email" registration field has error: "Required"
    And  The "password" registration field has error: "Required"

Scenario: Registration with short name shows right error

    Given I open the registration page
    When I enter "x" as "username" registration field
    And I click on the register button
    Then The "username" registration field has error: "Minimum length 3"

Scenario: Registration with invalid email shows right error

    Given I open the registration page
    When I enter "x@x" as "email" registration field
    And I click on the register button
    Then The "email" registration field has error: "Invalid email address"

Scenario: Registration with short password shows right error

    Given I open the registration page
    When I enter "x" as "password" registration field
    And I click on the register button
    Then The "password" registration field has error: "Minimum length 5"

# Scenario: Good login works ok

#     Given I create a user named "logintest1"
#     And I open the login page
#     When I enter "logintest1" as "username" registration field
#     And I enter "PW logintest1" as "password" registration field
#     And I click on the login button
#     Then The user is logged in

# Scenario: Bad username fails login

#     Given I create a user named "logintest2"
#     And I open the login page
#     When I enter "logintest2x" as "username" registration field
#     And I enter "PW logintest2" as "password" registration field
#     And I click on the login button
#     Then The "username" registration field has error: "Name and/or password incorrect"


# Scenario: Good username with bad password fails login, in same way as bad username

#     Given I create a user named "logintest3"
#     And I open the login page
#     When I enter "logintest3" as "username" registration field
#     And I enter "PW logintest2" as "password" registration field
#     And I click on the login button
#     Then The "username" registration field has error: "Name and/or password incorrect"

# Scenario: Bad username AND password shows same error as bad username

#     Given I open the login page
#     When I enter "abc" as "username" registration field
#     And I enter "abcde" as "password" registration field
#     And I click on the login button
#     Then The "username" registration field has error: "Name and/or password incorrect"

