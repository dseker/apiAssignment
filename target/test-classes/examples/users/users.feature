Feature: sample karate test script
  for help, see: https://github.com/intuit/karate/wiki/IDE-Support
##
#  Background:
#    * url 'https://jsonplaceholder.typicode.com'
#
#  Scenario: get all users and then get the first user by id
#    Given path 'users'
#    When method get
#    Then status 200
#
#    * def first = response[0]
#
#    Given path 'users', first.id
#    When method get
#    Then status 200
#
#  Scenario: create a user and then get it by id
#    * def user =
#      """
#      {
#        "name": "Test User",
#        "username": "testuser",
#        "email": "test@user.com",
#        "address": {
#          "street": "Has No Name",
#          "suite": "Apt. 123",
#          "city": "Electri",
#          "zipcode": "54321-6789"
#        }
#      }
#      """
#
#    Given url 'https://jsonplaceholder.typicode.com/users'
#  #  And request user
#  #  When method post
#  #  Then status 201
#
#  #  * def id = response.id
# #   * print 'created id is: ', id
#
##    Given path id
#    # When method get
#    # Then status 200
#    # And match response contains user
##
  Background:
    * url 'https://reqres.in/api/users'


  Scenario: Validate and extract object with id 11

    Given param page = 2
    When method GET
    Then status 200
    And assert responseTime < 2500
    * match responseType == 'json'
    * match response.data[0].first_name == 'Michael'
    * def objectOfId11 = get[0] response.data[*].[?(@.id==11)]
    And print objectOfId11


  Scenario: Check for user 11 and validate

    Given url 'https://reqres.in/api/users?id=11'
    When method GET
    Then status 200
    * print response
    * def id = response.data.id
    * def name = response.data.first_name
    * def surname = response.data.last_name
    * assert id == 11
    * assert name == 'George'
    * assert surname == 'Edwards'
    * assert name + surname == 'GeorgeEdwards'

  Scenario: Register new Employee and validate
    Given url 'https://reqres.in/api/create'
    When request {"name": "Peter", "job":"Sales"}
    And method post
    Then status 201
    * match responseType == 'json'
    * print 'Response is: ', response
    * response.name == 'Peter'
    * response.job == 'Sales'

    Scenario: Validate unsuccessfully register of user
      Given url 'https://reqres.in/api/register'
      When request {"email":"karate@gmail.com"}
      And method post
      Then status 400
      * print response
      * assert response.error == 'Missing password'


    Scenario: Bonus question...

      Given param page = 2
      When method GET
      Then status 200
      * match responseType == 'json'
      * def firstRequestResponse = get[0] response.data[*].[?(@.id==11)]
      * print 'First req response: ', firstRequestResponse
      Given url 'https://reqres.in/api/users?id=11'
      When method GET
      Then status 200
      * def secondRequestResponse = response
      * print 'Second req response: ', secondRequestResponse
      * assert firstRequestResponse == secondRequestResponse



