require "modules/http_request"
require "fixtures/test_data"

Given('the address checking service endpoint: {string}') do |endPoint|
  @resource_path= endPoint
end

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

# Verifies that a response is returned when the GET CITIES service makes a request.
# @param postcode [String] Valid or Invalid German Postcodes
Then('I should receive a response with {string}') do |expectedCities|
  if @response.code == 200
    @response_body = JSON.parse @response.body
    listOfExpectedCities = expectedCities.split(/, /)
    listOfActualCities = @response_body["Cities"]
    assert_equal listOfExpectedCities, listOfActualCities, "The City List in service response do not match with the expected result!"
  end
end

# Verifies that the service request recieves data for success & no data for a failure in the response body
Then('No JSON data is returned for HTTP error status') do
  if @response.code == 200
    refute @response.body.empty?, 'The response is empty for 200 status code'
  else
    assert @response.body.empty?, 'The response should not return JSON Data when error occured'
  end
end

# Verifies that the service request returns the expected HTTP status codes for both success and failure cases.
Then('The response {int} status code should match') do |status_code|
  assert_equal @response.code, status_code
end



# Verifies that a response is returned when the GET STREET service makes a request.
# @raise [StandardError] If the GET request fails
When('I request the streets for {string} with postcode {string}') do |city, postcode|
  complete_uri = "#{@resource_path}/#{postcode}/#{city}/streets"
  begin
    @request = ServiceRequest.setup_request(ENV.fetch('VERIVOX_API_HOST'))
    @response = @request.get(complete_uri)
  rescue StandardError => ex
    raise "Failed to receive GET streets response! #{ex.message}"
  end
end

# Verifies that the service response contains the expected list of streets.
Then('I should receive a response with a list of streets for {string}') do |expectedCity|
  if @response.code == 200
    @response_body = JSON.parse @response.body
    listOfExpectedStreets = get_list_of_streets(expectedCity)
    @listOfActualStreets = @response_body["Streets"]
    assert_equal listOfExpectedStreets, @listOfActualStreets, "The Street List in service response do not match with the expected result!"
  end
end

# Verifies that atleast 1 street should exists from the list of streets
# Verifies if the no of streets in the response matches as expected
Then('The response should contain {int} streets') do |expectedNoOfStreets|
  if @response.code == 200
    actualNoOfStreets = @response_body["Streets"].length
    raise "Atleast 1 street should exists from the list of streets" if actualNoOfStreets < 1
    assert_equal expectedNoOfStreets, actualNoOfStreets, "The No of Streets in service response do not match with the expected result!"
  end
end

# Verifies that street names with special characters and dashes from the streets
Then('The street names with special characters and dashes displayed correctly') do

  if @response.code == 200
    @listOfActualStreets.each do |streetName|
      checkInvalidCharacter = streetName.match(/[-.äöüëïÄÖÜËÏ1-9a-zA-Z]+/) ? true : false
      if !checkInvalidCharacter
        @streetWithInvalidCharacter = streetName
        raise "This street name has a invalid character #{@streetWithInvalidCharacter}"
        break
      end
    end
  end
end

# @funcion get_list_of_streets Get the list of expected streets names
def get_list_of_streets(cityName)
  case cityName
  when "Berlin"
    return STREETS_10409_BERLIN
  when "Fischerbach"
    return STREETS_77716_FISCHERBACH
  when "Haslach"
    return STREETS_77716_HASLACH
  when "Hofstetten"
    return STREETS_77716_HOFSTETTEN
  else
    nil
  end
end