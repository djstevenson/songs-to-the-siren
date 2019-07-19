@Focus
Feature: Confirm/Decline Registration

Scenario: A new user does not have their registration confirmed

    Given I open the registration page
    When I register a user named confreg1
    Then The user confreg1 is not confirmed

# Scenario: A new user confirms their registration
    # Given I open the registration page
    # When I register a user named confreg2
    # And I click on the confirm link in the registration email for confreg2
    # Then The user is logged out
    # And I see the registration confirmation page
    # And The user confreg2 is confirmed

# Scenario: Confirm with wrong key
# Scenario: Decline with wrong key
# Scenario: Decline user registration
# Scenario: Decline then confirm user registration
# Scenario: Decline then decline user registration
# Scenario: Confirm then confirm user registration
# Scenario: Confirm then decline user registration
