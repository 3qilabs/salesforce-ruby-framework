Feature: Create an account, update the account and delete the account

  Background:
    * I read the data from the "Config_repo_API.xlsx" and "Smoke_test" tab
    Then I read the data from the spreadsheet

  Scenario: Creating an Account
    * execute "createAccount"

    #Checking if the account is visible on UI
    Given I open a browser

    #Login to Salesforce
    And I login to salesforce website

    #Search for the account
    Then I click on "App Launcher"
    Then I click on "Service Option"
    When I click on the "Accounts" link
    Then I wait 2 seconds
    Then I confirm that the "New Account" was created

    #Delete the account
    Then I click "unique_account_name" link to edit
    Then I click on "More Actions"
    Then I click on "Delete"
    Then I click on "Delete Button"

    #Logout of Salesforce
    Then I logout of salesforce