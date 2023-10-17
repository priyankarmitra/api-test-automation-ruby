# language: en
# encoding: utf-8
Feature: Find the cities and streets for a given postcode
  AS a Verivox developer
  I WANT TO find city and street names for a particular German postcode
  SO THAT I can help customers select their address details more easily

  @automated @scenario1
  Scenario Outline: Find the cities for a given postcode
    Given the address checking service endpoint: "<Endpoint>"
    When I request the cities for postcode "<Postcode>"
    Then I should receive a response with "<CityList>"
    And No JSON data is returned for HTTP error status
    And The response <HttpStatus> status code should match

    Examples:
      | Endpoint               | Postcode      | CityList                                              | HttpStatus |
      | /geo/latestv2/cities   | 10409         | Berlin                                                | 200        |
      | /geo/latestv2/cities   | 07629         | Hermsdorf, Reichenbach, Schleifreisen, St. Gangloff   | 200        |
      | /geo/latestv2/cities   | 77716         | Fischerbach, Haslach im Kinzigtal, Hofstetten         | 200        |
      | /geo/latestv2/cities   | 99974         | Mühlhausen, Unstruttal                                | 200        |
      | /geo/latestv2/cities   | 22333         |                                                       | 404        |
      | /geo/INVALID/cities    | 10585         |                                                       | 404        |
      | /geo/latestv2/cities   | 117863        |                                                       | 404        |
      | /geo/latestv2/cities   | 0             |                                                       | 404        |
      | /geo/latestv2/cities   | NE3$12        |                                                       | 404        |

   @automated @scenario2
   Scenario Outline: Find the streets for a given postcode and city
    Given the address checking service endpoint: "<Endpoint>"
    When I request the streets for "<CityList>" with postcode "<Postcode>"
    Then I should receive a response with a list of streets for "<CityList>"
    And The response should contain <NoOfStreets> streets
    And The street names with special characters and dashes displayed correctly
    And The response <HttpStatus> status code should match

    Examples:
      | Endpoint               | Postcode      | CityList           | NoOfStreets | HttpStatus |
      | /geo/latestv2/cities   | 10409         | Berlin             | 29          | 200        |
      | /geo/latestv2/cities   | 77716         | Fischerbach        | 34          | 200        |
      | /geo/latestv2/cities   | 77716         | Haslach            | 121         | 200        |
      | /geo/latestv2/cities   | 77716         | Hofstetten         | 40          | 200        |
      | /geo/latestv2/cities   | 10585         | Stuttgart          | 0           | 404        |
      | /geo/latestv2/cities   | Stuttgart     | 10585              | 0           | 404        |
      | /geo/INVALID/cities    | 10585         | Berlin             | 0           | 404        |