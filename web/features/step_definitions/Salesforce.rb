require 'date'
$time = Time.now.strftime("%m%d%Y%H%M")
$manifest_file ||= File.join(File.dirname(__FILE__), '..', 'manifest.json')
$params ||= JSON.parse(File.open($manifest_file).read)['params']

And (/^I login to salesforce website$/) do
  step "I navigate to the environment url"
  step "I maximize the browser window"
  step "I click on \"Login Button\""
  step "I wait 2 seconds"
  # step "I wait to see the text \"Forgot your password?\""
  # step "I read the data from the spreadsheet"
  step "I enter \"username\""
  step "I enter \"password\""
  step "I click the button Log in to Salesforce with id \"Login\""
  step "I wait 5 seconds"
end

Then(/^I logout of salesforce$/) do
  step "I click on \"User Logo\""
  step "I wait 2 seconds"
  step "I click on \"Log Out\""
  step "I wait 2 seconds"
  step "I close the browser"
end

Then(/^I maximize the browser window$/) do
  @browser.driver.manage.window.maximize
  @browser.cookies.clear
  sleep 2
end

Then(/^I click the button with id "(.*?)"$/) do |arg1|
  @browser.div(:id => "header-nav").link(:id => arg1).when_present.flash.click
end

Then(/^I click on "(.*?)"$/) do |arg1|
  id_value = @obj_repo_row[arg1]
  @browser.element(id_value[0].to_sym, id_value[1]).when_present.flash.click rescue @browser.element(id_value[0].to_sym, id_value[1]).when_present.flash.fire_event("click")
end

# Then(/^I wait to see the text (.*?)"$/) do |arg1|
#   @browser.link(:text, arg1).wait_until_present
# end

Then(/^I clear text in "(.*?)" field$/) do |arg1|
  @browser.text_field(:id => "MasterLabel").clear
  sleep 5
  #@browser.text_field(:id => "DeveloperName").clear
end

Then(/^I click the button Log in to Salesforce with id "(.*?)"$/) do |arg1|
  @browser.form(:name => "login").button(:name => "Login").when_present.flash.click
end

When(/^I click on the "(.*?)" link$/) do |arg1|
  @browser.link(:text, arg1).visible?
  element = @browser.link(:text, arg1).when_present.flash
  begin
    element.click
  rescue Exception
    element.fire_event "onclick"
  end
end

Then /^I click "(.*?)" button$/ do |arg1|
  @browser.button(:value, arg1).when_present.flash.click
  sleep 3
end

Then(/^I read the data from the spreadsheet$/) do
  require 'spreadsheet'
  require 'roo'
  # Spreadsheet.client_encoding = 'UTF-8'
  @myRoot = File.join(File.dirname(__FILE__), '/')
  book = Roo::Spreadsheet.open "#{@myRoot}Config_repo_API.xlsx"
  #book = Spreadsheet.open 'SF_Accounts.xls'
  # book.sheets
  obj_repo = book.sheet 'obj_repo'

  @obj_repo_row = {}
  obj_repo.each do |row|
    row.each do |x|
      @obj_repo_row[row[0]] = row[1..3]
    end
  end

  user_data = book.sheet 'user_data'
  @user_data_row = {}
  user_data.each do |row|
    row.each do |x|
      @user_data_row[row[0]] = row[1]
    end
  end
end


Then(/^I enter value of "(.*?)" in the "(.*?)" field$/) do |data, locator|
  begin
    new_data = data.tr("0-9", "")
  rescue Exception
    new_data = data
  end

  obj_info = @obj_repo_row[locator]
  identifier = obj_info[1].gsub("LABEL_TEXT", new_data)
  object_type = obj_info[0]

  # This case is an option to make everything (phone, email, etc,.,) auto-generated in future
      user_info = rand_string_alpha(5)
  case new_data
    when "Account Name", "First Name"
      @account_name = user_info if @account_name.nil?
    when "Last Name"
      @account_name = @account_name + " " + user_info
    else
      user_info = @user_data_row["#{data}"]
  end

  el = @browser.element(object_type.to_sym, identifier)
  el.to_subtype.clear
  el.flash.send_keys(user_info)

end

Then(/^I enter "(.*?)"$/) do |data|
  case data
    when "username"
      data = $params['variables']['Salesforce']['username']
      @browser.text_field(:id, "username").flash.set("#{data}")
    when "password"
      data = $params['variables']['Salesforce']['password']
      @browser.text_field(:id, "password").flash.set("#{data}")
    else
      obj_repo = @obj_repo_row[data]
      user_info = @user_data_row["#{data}"]
      @browser.element(obj_repo[0].to_sym, obj_repo[1]).flash.send_keys(user_info)
  end
end

Then(/^I select "(.*?)" from "(.*?)"$/) do |arg1, arg2|
  select_value = @obj_repo_row[arg2]
  identifier = select_value[1].gsub("FIELD", arg1)
  @browser.element(select_value[0].to_sym, identifier).click
end

Then(/^I click "(.*?)" to edit$/) do |arg1|
  @browser.span(:class, "mruText").when_present.flash.click
  sleep 2
end

When /^I click the login name on top$/ do
  @browser.element(:xpath, "//img[@title='User']/parent::span").fire_event("click")
end

Then(/^I click the "(.*?)" checkbox$/) do |arg1|
  @browser.checkbox(:value => "1").when_present.flash.click
end

Then(/^I enter date in the "(.*?)" field$/) do |arg1|
  obj_info = @obj_repo_row["#{arg1}"]
  Current_Date1 = Date.today

  if arg1 == "Contract Start Date"
    Cdate = Current_Date1
    Csdate = Cdate.strftime("%m/%d/%Y").to_s
    @browser.text_field(:id, "#{obj_info[1].to_s}").set "#{Csdate}"

  elsif arg1 == "Start Date"
    Startdate = Current_Date1
    # Current_Date1 = Date.today
    date = Startdate.strftime("%m/%d/%Y").to_s
    @browser.text_field(:id, "#{obj_info[1].to_s}").set "#{date}"

  elsif arg1 == "End Date"
    Enddate = Current_Date1 + 15
    End_date = Enddate.strftime("%m/%d/%Y").to_s
    # Current_Date1.strftime("%m/%d/%Y").to_s
    # margin = Current_Date1>30
    @browser.text_field(:id, "#{obj_info[1].to_s}").set "#{End_date}"

  elsif arg1 == "Close Date"
    Closedate = Current_Date1 + 15
    Close_date = Closedate.strftime("%m/%d/%Y").to_s
    @browser.text_field(:id, "#{obj_info[1].to_s}").set "#{Close_date}"
  end
end

Then(/^I click  on the "(.*?)" tab$/) do |arg1|
  @browser.a(:class => "optionItem efpDetailsView ").when_present.flash.click
end

# Then(/^I click "(.*?)" link$/) do |arg1|
#   @browser.a(:title => "Edit - Record 1 - Phone_Number__c").flash.click
# end

Then /^I click "(.*?)" under Campaign Custom Fields & Relationships$/ do |arg1|
  @a = Thread.new {
    @browser.a(:title => "Del (New Window)").when_present.flash.click
  }
  sleep 5
end

Then(/^I click setup on top$/) do
  @browser.a(:id => "setupLink").when_present.flash.click
end

Then(/^I select "(.*?)" radio button$/) do |arg1|
  @browser.radio(:id => "dtypeH").flash.set
end

Then(/^I click the confirm checkbox$/) do
  @browser.checkbox(:id => "confirmed").flash.click
end

Then(/^I interact with the window having title "(.*?)"$/) do |arg1|
  sleep 60
  counter = 0
  if arg1 == "Parent_window"
    @browser.driver.switch_to.window(@browser.driver.window_handles[0])
  else
    @browser.windows.each do |win|
      if win.title == arg1
        @browser.driver.switch_to.window(@browser.driver.window_handles[counter])
      else
        counter = counter + 1
      end
    end
  end
end

Then(/^I confirm that the "([^"]*)" was created$/) do |arg|
  step "I click on the \"Accounts\" link"
  step "I wait 2 seconds"
  step "I should see \"#{arg}\""
end

And(/^if browser alert appears click "(.*?)"$/) do |arg1|
  if @browser.alert.present?
    case arg1
      when /ok/i, /yes/i, /submit/i
        @browser.alert.ok
      when /cancel/i, /close/i
        @browser.alert.close
    end
  end
end

Then(/^I click on "(.*?)" link$/) do |arg1|
  @browser.a(:href => "/p/setup/layout/DeletedFieldList?type=Campaign&setupid=CampaignFields").flash.click
end



