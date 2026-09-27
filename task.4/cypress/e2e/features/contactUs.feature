Feature: Contact Us page

  @TC-12
  Scenario: Contact Us Submit Button Is Clickable
    Given I am on the home page
    When I click on "TALK TO AN EXPERT"
    Then I should be redirected to the "/contact-us" page
    And the submit button should be clickable

  @TC-13
  Scenario: Contact Us Form Reason has two options
    Given I am on the contact-us page
    When I click on the contact reason dropdown
    Then two options should appear

  @TC-14
  Scenario: Contact Us Form fields are accepting input
    Given I am on the contact-us page
    When I input a randomly generated symbol into the contact form fields
    Then the fields should accept the symbol
    When I clear the fields
    Then the fields should be empty

  @TC-15
  Scenario: Cookies settings are editable on Contact Us page
    Given I am on the contact-us page
    When I see coockie settings button
    And I click the cookie settings button
    Then the cookie settings panel should appear
    When I confirm my cookie choices
    Then the choice should be confirmed