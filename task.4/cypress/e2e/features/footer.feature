Feature: Footer links

  Background:
    Given the base URL is accessible
    And Cypress environment is properly configured
    And I am on the home page

  @TC-08
  Scenario: API Validation of Footer COMPANY Section Internal Links
    When I extract an array of URLs from all links inside the "Company" column in the footer
    Then the server response for every URL should return HTTP status code 200 or 403 if links protected by bot-detection

  @TC-09
  Scenario: API Validation of Footer LEGAL Section Internal Links
    When I extract an array of URLs from all links inside the "Legal" column in the footer
    Then the server response for every URL should return HTTP status code 200 or 403 if links protected by bot-detection

  @TC-10
  Scenario: API Validation of Footer COMPARE Section Internal Links
    When I extract an array of URLs from all links inside the "Compare" column in the footer
    Then the server response for every URL should return HTTP status code 200 or 403 if links protected by bot-detection

  @TC-11
  Scenario Outline: Footer social icons link to the correct external profile
    Then the "<network>" icon should be clickable
    And it should link to "<host>"

    Examples:
      | network  | host                        |
      | linkedin | linkedin.com/company/telnyx |
      | x        | x.com/telnyx                |
      | facebook | facebook.com/Telnyx         |