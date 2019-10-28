Feature: Create a new Account in salesforce

  Scenario: Login to salesforce create and edit the account and logout
    Given I open a browser
    And I login to salesforce.com
    Then I go to the url "http://www.salesforce.com"
    Then I maximize the browser window
    Then I click the button with id "button-login"
    And I wait 2 seconds
    And I wait to see the text "Forgot your password?"
    Then I read the data from the spreadsheet
    Then I enter value of "username" in the id field
    And I enter value of "password" in the id field
    Then I click the button Log in to Salesforce with id "Login"
    Then I wait 5 seconds

    And I enter value of "Description" in the id field
    When I click " Save " button
    Then I should see "Walmart"

   #Edit the account name
    Then I click "the name of the new account" to edit
    Then I click " Edit " button
    And I enter value of "Account Name2" in the id field
    When I click " Save " button
    Then I should see "Walmart Labs"

   #Delete the account
    Then I click "the name of the edited account" to edit
    Then I click "Delete" button
    And I click "Ok" in the browser alert

    Then I logout of salesforce
 # When I click the login name on top
 # Then I wait 2 seconds
 # Then I click on the "Logout" link
    # Then I wait 2 seconds
 #And I wait to see the text "Forgot your password?"
 # And I close the browser