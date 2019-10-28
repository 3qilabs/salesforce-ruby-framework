Feature: Create an account, update the account and delete the account

  Background:
    Then I read the data from the spreadsheet

  Scenario: Login to salesforce create and edit the account and logout
    Given I open a browser

    #Login to Salesforce
    And I login to salesforce website

    #Create a new account
    Then I click on "App Launcher"
    Then I click on "Service Option"
    When I click on the "Accounts" link
    Then I wait 2 seconds
    Then I click on "New Button"
    Then I enter value of "Account Name" in the "new_account_input_field" field
    And I enter value of "Phone" in the "new_account_input_field" field
    And I enter value of "Account Site" in the "new_account_input_field" field
    Then I click on "Type"
    Then I select "Installation Partner" from "dropdown_list"
    And I enter "Description"
    When I click on "Save Button"
    Then I should see text "Tilak Divakar"

   #Edit the account name
    Then I click on "More Actions"
    Then I click on "Edit"
    And I enter value of "Account Name2" in the "new_account_input_field" field
    When I click on "Save Button"

   #Delete the account
    Then I click on "More Actions"
    Then I click on "Delete"
    Then I click on "Delete Button"

    #Logout of Salesforce
    Then I logout of salesforce
