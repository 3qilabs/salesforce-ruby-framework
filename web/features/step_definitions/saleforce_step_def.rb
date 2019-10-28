Then(/^I close the popup if it shows up$/) do
	if @browser.div(:id, "it-choice").exists?
		@browser.div(:id, "it-choice").click
		sleep 2
	end
	if @browser.div(:id, "walkthrough-callout-close").exists?
		@browser.div(:id, "walkthrough-callout-close").click
		sleep 2
	end
end

Then /^I click the button to login$/ do
	@browser.driver.manage.window.maximize
	sleep 3
	@browser.button(text: "Log In").click
end

Then /^I fill value "(.*?)" in field with id "(.*?)"$/ do |arg1, arg2|
	@browser.text_field(:id, arg2).set(arg1)
end

Then /^I fill value "(.*?)" in the "(.*?)" field$/ do |arg1, arg2|
	case arg2
	when "name"
		arg3 = "acc2"
		time = Time.new
		arg1 = "acc_name_#{time.strftime("%Y%m%d%H%M%S")}"
		@account = arg1
	when "description"
		arg3 = "acc20"
	when "Website"
		arg3 = "acc12"
	when "Account Name"
		arg3 = "con4"
		arg1 = @account
	when "Title"
		arg3 = "con5"
	when "Email"
		arg3 = "con15"
	when "Phone"
		arg3 = "con10"
	else
		arg3 = arg2
	end
	@browser.text_field(:id, arg3).set(arg1)
end

And /^I open the file to read data$/ do
	@myRoot = File.join(File.dirname(__FILE__),'/')
	file = File.open("#{@myRoot}lead_wb.csv", "rb")
	abc = file.read
	@h = {}
		abc.split("\r").each do |x|
		   k,v = x.split(',')
		   @h[k] ||= []
		   @h[k].push(v)
	end
end

Then /^I fill a value "(.*?)" in the "(.*?)" field$/ do |arg1, arg2|

	arg3 = @h["#{arg2}"].to_s

	@browser.text_field(:id, arg3).set(arg1)
end


Then /^I click the button Log in to Salesforce$/ do
	@browser.button(text: "Log In").click
end

When /^I click "(.*?)" link$/ do |arg1|
	@browser.link(:text, arg1).visible?
	@browser.link(:text, arg1).click
end

Then /^I should see text "(.*?)"$/ do |arg1|
	if arg1 == "unique_account_name"
		puts "#{@account_name} is present on the page" if @browser.text.include?(@account_name)
	else
    fail "#{arg1} is not present on the page" if !@browser.text.include?(arg1)
	end
end

# When /^I click "(.*?)" button$/ do |arg1|
# 	@browser.button(:value, arg1).click
# end

# Then /^I select "(.*?)" for id "(.*?)"$/ do |arg1, arg2|
# 	@browser.select_list(:id, arg2).select(arg1)
# end

When /^I click "(.*?)" link to edit$/ do |arg1|
	if arg1 == "unique_account_name"
		@browser.element(:xpath,"//a[@title='#{@account_name}']").when_present.click
		sleep 2
	else
		@browser.div(:class, 'pbBody').link(:text, arg1).when_present.click
		sleep 2
	end
	# @browser.div(:class, 'pbBody').link(:text, arg1).when_present.click
	#@browser.div(:class, 'pbBody').link(:text, arg1).when_present.fire_event('onclick')
end

When /^I click My Name on top$/ do
	@browser.span(:id, "userNavLabel").click
end

Then /^I delete the entry$/ do
	@browser.button(:value,"Delete").exists?

	if @browser.name == :safari || @browser.name == :iPad
		# puts "delete for safari"
		alertvalue = @browser.button(:value,"Delete").attribute_value('onclick')
		abcd = alertvalue.split("navigateToUrl")[1]
		abcd = abcd.split("','")[0]

		urlvalue = @browser.url
		urlval1 = urlvalue.split(".com/")
		urlvalue = urlval1[0]+".com/"+ abcd.split("('")[1]
		sleep 5
		@browser.goto urlvalue

	else
		@browser.button(:value,"Delete").click
		sleep 2
		@browser.alert.exists?
		sleep 2
		@browser.alert.ok
		sleep 5
	end
end

Then(/^I wait to see the text "(.*?)"$/) do |arg1|
	@browser.link(:text, arg1).wait_until_present
end

And /^I am logged into salesforce.com$/ do
	step "I go to the url \"http://www.salesforce.com\""
	step "I wait to see the text \"Privacy Statement\""
	step "I click the button to login"
	step "I wait to see the text \"Forgot your password?\""
	step "I fill value for username and password"
	@browser.button(:id,"Login").click
	@browser.link(:text, "Contacts").wait_until_present
end

And /^I get the unique_account_name value$/ do
	@account = @browser.text_field(:id, "con4").value
end

#Delete these steps
# Given /^I open the internet browser$/ do
# 	system "adb forward tcp:8080 tcp:8080"
# 	sleep 5
# 	require 'watir-webdriver'
#   	@browser = Watir::Browser.new(:remote, :url=>'http://10.3.96.161:3001/wd/hub/')
# end
Given /^I open the internet browser$/ do
	require 'watir-webdriver'
  	@browser = Watir::Browser.new :chrome #:safari
end