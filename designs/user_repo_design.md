# UserRepository Design Recipe

## 1. Describe the Problem

As a user
I want to sign up

As a user
I want to login

As a user
I want to see my profile

As a user
I want to log out
## 2.

_Include the name of the method, its parameters, return value, and side effects._

```ruby
create(username, email, password) method

authenticate(email, password) method

all method for tests

find(id) method for tests
```

## 3. Create Examples as Tests

_Make a list of examples of what the method will take and return._

```ruby
# EXAMPLE

UserRepository.create("Afrika", "afrika@gmail.com", "qwerty")
result = UserRepository.all
expect(result.last.username).to eq("Afrika")

user = UserRepository.authenticate("afrika@gmail.com", "qwerty")
expect(user.username).to eq("Afrika")

user = UserRepository.all
expect(user.length).to eq(2)
expect(user.last.id).to eq(2)

user = UserRepository.find(id)
```

_Encode each example as a test. You can add to the above list as you go._

## 4. Implement the Behaviour

_After each test you write, follow the test-driving process of red, green, refactor to implement the behaviour._