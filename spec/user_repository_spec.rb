require_relative '../lib/repositories/user_repository'
require_relative 'database_helper'

RSpec.describe UserRepository do
  before(:each) do 
    reset_makers_bnb_table
  end

  context '.create' do
    it 'creates a new user in the database' do
      UserRepository.create('john', 'johndoe@example.com', 'password123')
      user = UserRepository.all
      
      expect(user.length).to eq(3)
      expect(user.last.username).to eq('john')
      expect(user.last.email).to eq('johndoe@example.com')
      expect(user.last.password).to eq('password123')
    end
  end

  context '.authenticate' do
    it 'returns the user if the email and password match' do
      user = UserRepository.authenticate('Khuslen@gmail.com', 'Hello123')

      expect(user).not_to be_nil
      expect(user.username).to eq('Khuslen')
      expect(user.email).to eq('Khuslen@gmail.com')
      expect(user.password).to eq('Hello123')
    end

    it 'returns nil if the email and password do not match' do
      user = UserRepository.authenticate('Khuslen@gmail.com', 'incorrect_password')

      expect(user).to be(nil)
    end
  end

  context '.all' do
    it 'returns all users from the database' do
      users = UserRepository.all

      expect(users.length).to eq(2)

      expect(users[0].username).to eq('Jessica')
      expect(users[0].email).to eq('Jessica@gmail.com')
      expect(users[0].password).to eq('IloveMakers2023')

      expect(users[1].username).to eq('Khuslen')
      expect(users[1].email).to eq('Khuslen@gmail.com')
      expect(users[1].password).to eq('Hello123')
    end
  end

  context 'find' do
    it 'returns user with id 2' do
      users = UserRepository.find(2)
      expect(users.username).to eq('Khuslen')
      expect(users.email).to eq('Khuslen@gmail.com')
      expect(users.password).to eq('Hello123')
    end
  end
end