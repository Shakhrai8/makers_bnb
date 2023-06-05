require 'pg'

def reset_makers_bnb_table
  seed_sql = File.read('spec/users_seeds.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'makersbnb_test' })
  connection.exec(seed_sql)
end
