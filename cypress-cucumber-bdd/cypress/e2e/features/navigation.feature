Feature: Homepage and navigation

  @TC-01
  Scenario: Home Page Loads Successfully
    Given the base URL is accessible
    When I navigate to the base URL
    Then the user should be on the main page and it should be loaded

  @TC-02
  Scenario: Logo Click Redirects to Home Page
    Given the base URL is accessible
    And I am navigated to any internal subpage
    Then the main header area with the Telnyx logo should be visible
    When I click the logo
    Then I should be redirected to the main page

  @TC-03
  Scenario: Main navigation displays all top-level menu items
    Given I am on the home page
    Then all 6 navigation tabs should be visible in the header

  @TC-04
  Scenario: Navigation Menu Dropdown Appears on Click
    Given I am on the home page
    When I click on the "Solutions" navigation dropdown
    Then the dropdown should appear

  @TC-05
  Scenario: Navigation Submenu Link Redirects to Correct Page
    Given I am on the home page
    When I click on the "Products" navigation dropdown
    Then the dropdown should appear
    And I click on "View all primitives"
    Then I should be redirected to the "/products" page

  @TC-07
  Scenario: All AI tabs are visible and clickable
    Given I am on the home page
    When I scroll to the AI agents tabs
    Then the tabs should be visible
    And the tabs should be clickable