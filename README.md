# Test REST API Services using Ruby, Cucumber (Gherkin), and Generate HTML Reports

This repository provides a framework and example code for testing RESTful API services using Ruby, Rspec and Cucumber (Gherkin). 
The tests are designed to ensure the functionality of REST APIs and generate HTML reports to provide clear and organized test results.


### Project Structure

```
test-verivox-api-framework/
│
├── lib/
│   ├── fixtures/
│   │   └── test_data.rb               # Static Test Data for testing
│   │ 
│   └── helpers/
│   │   └── common.rb                  # Initiate common libs and classes 
│   │ 
│   └── modules/
│   │   └── http_request.rb            # API Modules and class
│   │ 
├── features/
│   ├── step_definitions/
│   │   └── address_checker_steps.rb   # Step Definitions for Address Checker API
│   │
│   └── address_checker.feature        # Test scenarios to find the cities and streets for a given postcode
│
├── config/
│   └── cucumber.yaml            # Load necessary dependencies and configure HTTParty
│
├── Gemfile                      # Define project dependencies that will be installed when you run bundle install
├── README.md                    # Project Notes & Documentation
│
└──
```



## Prerequisites

Before getting started, make sure you have the following prerequisites installed:
https://www.ruby-lang.org/en/documentation/installation/

 Verify your ruby version in your system , if ruby is setup we can go straight to `Installing Depencies` section
    ```
    ruby -v
    ```

### Mac:
  
  If the system version is 3.0.0 we are good. If it is below that please follow the below steps:
  ```
  brew install rbenv
  rbenv init
  rbenv install 3.0.0
  rbenv global 3.0.0
  ruby -v
  ```

  The output should be something like this:

  ```
  ruby 3.0.0p0 (2020-12-25 revision 95aff21468) [arm64-darwin21]
  ```

  We also need to update your **~/.bash_profile** and add the following lines:

  ```
  export PATH=$PATH:/usr/local/bin
  eval "$(rbenv init - zsh)"
  export PATH=/opt/homebrew/Cellar:$PATH
  ```

  Execute the bash profile and restart terminal to see if you still have the changes!
  
### Windows:

  Download Ruby devkit and follow the installation instruction https://rubyinstaller.org/downloads/

  Open new CMD, then run `ruby -v`

  The output should be something like this:

  ```
  ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x64-mingw-ucrt]
  ```


## Install Dependencies

Open new Terminal / command prompt and run the following commands on the project directory:

  ```
  gem install bundler
  bundle install
  ```

  This should install all the Ruby gems / dependencies.
  Or you can separately install them:

  ```
  gem 'cucumber'
  gem 'httparty'
  gem 'json-schema'
  gem 'minitest', '~> 5.20'
  ```
  Now, we should be good to start execution Localy.

## Test Execution

Open CMD / Terminal and navigate to the project directory

### Specification Execution

  ### Default

  ```
  bundle exec cucumber
  ```

  ### Execution of tests with tags:
  ```
  cucumber <folder_name>/<file_name> -t @tagName
  ```
  *Example:* cucumber features/address_checker.feature -t @scenario1

  ### Execution of feature:
  ```
  cucumber <folder_name>/<file_name>
  ```
  *Example:*  cucumber features/address_checker.feature

## HTML Reporting:

The reports are **dynamic and are generated in Cucumber Cloud** when you run your test, you the dynamic cucumber link in web browser


**Example:**
```
View your Cucumber Report at:                                            

│ https://reports.cucumber.io/reports/e006dfb1-210f-403f-867d-e58b573676c1 │
│                                                                          │
│ This report will self-destruct in 24h.                                   │
│ Keep reports forever: https://reports.cucumber.io/profile                |
```

## Project Notes

- There are **2 scenarios** and **16 test cases**
- When you run the test only **14 test cases** will **PASS** and **2  test cases** will **FAIL**

The reason 2  test cases will fail is because of 2 known Defects:

 ### Defect 1:
 
 Some city names with spaces and '/' do not appear in the response correctly, only the first word is shown, causing truncation.

**Ex:** *77716, Haslach im Kinzigtal* and *99974 Mühlhausen/Thüringen*

 **Steps To Reproduce**

 1. Make a request to cities '/geo/latestv2/cities' API for postcode 15230
 2. Make another request to cities '/geo/latestv2/cities' API for postcode 60306
 
 *Expected:* The first response should contain the city name as `Frankfurt an der Oder` and the second response should contain the city name `Frankfurt` or `Frankfurt am Main`
 
 *Actual:* In both the responses city name appears as `Frankfurt`

 ### Defect 2:
 
 Some postcodes return only one city, but the expectation is to retrieve multiple cities.
 
**Ex:**
*Sollstedter Weg 1B, 99974 Unstruttal* and *Güldene Ecke 6, 99974 Mühlhausen/Thüringen*

*Gersdorf 97, 01816 Bahretal* and *Am Tannenbusch 5, 01816 Bad Gottleuba-Berggießhübel*

 
 **Steps To Reproduce**

 1. Make a request to cities '/geo/latestv2/cities' API for postcode 99974
 
 *Expected:* The response should contain 2 cities `"Mühlhausen/Thüringen" and "Unstruttal"`
 
 *Actual:* In the response one 1 city name appears `Mühlhausen`

 ## Sample Test Scenario

Here's an example of a Gherkin feature file and its corresponding step definition:

**Sample Feature File (user.feature):**

```gherkin

  @automated @scenario1
  Scenario Outline: Find the cities for a given postcode
    Given the address checking service endpoint: "<Endpoint>"
    When I request the cities for postcode "<Postcode>"
    Then I should receive a response with "<CityList>"
    And No JSON data is returned for HTTP error status
    And The response <HttpStatus> status code should match

    Examples:
      | Endpoint               | Postcode      | CityList                                        | HttpStatus |
      | /geo/latestv2/cities   | 10409         | Berlin                                          | 200        |
      | /geo/latestv2/cities   | 77716         | Fischerbach, Haslach im Kinzigtal, Hofstetten   | 200        |
```

**Sample Step Definition (UserSteps.cs):**

```
# Verifies that a response is returned when the GET CITIES service makes a request.
# @param postcode [String] Valid or Invalid German Postcodes
# @raise [StandardError] If the GET request fails
When('I request the cities for postcode {string}') do |postcode|
  complete_uri = "#{@resource_path}/#{postcode}"
  begin
    @request = ServiceRequest.setup_request(ENV.fetch('VERIVOX_API_HOST'))
    @response = @request.get(complete_uri)
  rescue StandardError => ex
    raise "Failed to receive GET city response! #{ex.message}"
  end
end

```
## Sample CMD execution screens
![image](https://github.com/priyankarmitra/api-test-automation-ruby/assets/54986023/9afd1916-7560-4179-b315-321e2a7f6b98)

## Sample HTML report
![image](https://github.com/priyankarmitra/api-test-automation-ruby/assets/54986023/3047bd51-9517-4de7-bcc4-fc7bdb867f1e)


