# REST Routing (REST)
# Users 
## List all users
Requests:
GET /users
Response (200 0K):
A list of all users
## Find a specific user
Request:
GET /users/:id
Response (200 OK):
A specific user
## Post signup
Request:
POST /signup
Response (200 OK):
Creates a new user
## Get Signup
Request:
Get /signup
Response (200 OK):
Returns signup form
## Get Login
Request:
GET /login
Response (200 OK):
Returns user login form
## Post Login
Request:
POST /login
Response (200 OK):
Logs user in if already signed up 
Validates username and password
## Get Logout
Request:
GET /logout
Response (200 OK):
Logs user out
## Get profile
Request:
GET /profile
Response (200 OK):
Returns users details
## Main page
Request 
GET /
Response (200 OK):
Returns login and signup forms