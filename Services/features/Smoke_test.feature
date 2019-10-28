Feature: Create an account, update the account and delete the account

  Background:
    * I read the data from the "Config_repo_API.xlsx" and "Smoke_test" tab

  Scenario: Creating an Account
    * execute "createAccount"

  Scenario: Fetching an Account
    * execute "getAccount"

  Scenario: Deleting an Account
    * execute "deleteAccount"

  Scenario: Validating that the Account is Deleted
    * execute "validateDeletedAccount"

  Scenario: Creating a new Account
    * execute "createNewAccount"

  Scenario: Updating an Account
    * execute "updateAccount"