Feature: Cucumber Test

  Scenario: Pass
    When I have a passing test
    And I say hello

  Scenario: API Example
    Given I set X-Debug header to true
    Given I set X-Debug2 header to false
    When I GET /get
    Then response code should be 200

