# BookingRepository Design Recipe

## 1. Describe the Problem

As a user
I want to click on an available booking

As a user
I want to fill out a form to make a booking

As a user
I want to see a confirmation of my booking status 

As a user
I want to update my booking

As a user
I want to delete my booking 


As a 
## 2.

_Include the name of the method, its parameters, return value, and side effects._

```ruby
create(:space_id :user_id, :start_date, :end_date, :contents) method
# default :status

all method for tests

find(id) method for tests

update(id)

delete(id)
```

## 3. Create Examples as Tests

_Make a list of examples of what the method will take and return._

```ruby
# EXAMPLE

bookings = BookingRepository.all 

    expect(bookings.length).to eq(2)
    expect(bookings[0].contents).to eq('I would like an extra bed')

BookingRepository.create("1", "2023-06-10", '2023-06-15', 'Need an extra chair', 'pending')
result = UserRepository.all
expect(result).to include('Need an extra chair')

booking = BookingRepository.find(1)
expect(booking.contents).to eq ('I would like an extra bed')



user = UserRepository.all
expect(user.length).to eq(2)
expect(user.last.id).to eq(2)

user = UserRepository.find(id)
```

_Encode each example as a test. You can add to the above list as you go._

## 4. Implement the Behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._