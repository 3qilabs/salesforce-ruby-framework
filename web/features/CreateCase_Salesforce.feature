Feature: Create a new Case in salesforce

  Background:
    Then I read the data from the spreadsheet

  Scenario: Login to salesforce create a new case edit and delete the case
    Given I open a browser

    #Login to Salesforce
    And I login to salesforce website

    #Create a new case
    Then I click on "App Launcher"
    Then I click on "Service Option"
    When I click on the "Cases" link
    Then I click on "New Button"
    Then I click on "Search Contacts"
    Then I click on "New Contact"
    Then I enter value of "First Name" in the "new_contact_input_field" field
    Then I enter value of "Last Name" in the "new_contact_input_field" field
    Then I enter "Phone"
    When I click on "Save Button"
    Then I click on "Status"
    Then I select "Working" from "dropdown_list"
    Then I click on "Case Origin"
    Then I select "Phone" from "dropdown_list"
    When I click on "Save Button"
    Then I should see text "unique_account_name"

    #Delete the account
    Then I click on "More Actions"
    Then I click on "Delete"
    Then I click on "Delete Button"

    #Logout of Salesforce
    Then I logout of salesforce