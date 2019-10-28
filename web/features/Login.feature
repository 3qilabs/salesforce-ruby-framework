Feature: Simple Login and Logout in salesforce

  Background:
    Then I read the data from the spreadsheet

  Scenario: Login to salesforce and Logout
    Given I open a browser
#    And I login to salesforce website
    Then I navigate to the environment url
    Then I maximize the browser window
    Then I click on "Login Button"
    And I wait 2 seconds
    Then I enter "username"
    And I enter "password"
    Then I click the button Log in to Salesforce with id "Login"
    Then I wait 5 seconds
#    Then I logout of salesforce
    When I click on "User Logo"
    Then I wait 2 seconds
    Then I click on "Log Out"
    Then I wait 2 seconds
    And I close the browser