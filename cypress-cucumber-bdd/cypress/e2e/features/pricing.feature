Feature: Pricing page

  @TC-06
  Scenario: Pricing Page Displays Valid Price Values
    Given I navigate to the pricing page
    When I click the Messaging API pricing link
    Then I should be redirected to the "/pricing/messaging" page
    And the services table should be visible
    And all displayed prices should be greater than 0