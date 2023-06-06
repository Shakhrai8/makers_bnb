# UserRepository Design Recipe

## 1. Describe the Problem

As a user
I want to list a space

As a user
I want to add a name

As a user
I want to add a description

As a user
I want to add a price

As a user
I want to display the dates when listing is avaliable

## 2.

_Include the name of the method, its parameters, return value, and side effects._

```ruby
create(name, description, price, dates_avaliable ) method

all method for tests

find(id) method for tests

find(city)

dates()


```

## 3. Create Examples as Tests

_Make a list of examples of what the method will take and return._

```ruby
# EXAMPLE

#shows all listings
ListingRepository.all

result = ListingsRepository.all
expect(result.length).to eq(2)
expect(result).to include('London Plaza')

#Creates a new listing
ListingsRepository.create('The Ritz', 'Cornwall', '3 bedroom flat', '70.50', '2023-05-05', '2023-06-20', NOW(), NOW(), 1)

result = ListingsRepository.all

expect(result.last.name).to eq('The Ritz')
expect(result.last.city).to eq('Cornwall')

listing = ListingRepository.all
expect(listing.length).to eq(3)
expect(listing.last.id).to eq(3)

#finds a listing by id

listing = ListingsRepository.find(2)

expect(listing.name).to eq('paris cottage')



```

_Encode each example as a test. You can add to the above list as you go._

## 4. Implement the Behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._
