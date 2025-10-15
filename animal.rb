require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

get('/animals') do
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true

  query = params[:q]

  if query && !query.empty?
    @animals = db.execute("SELECT * FROM animals WHERE name LIKE ?","%#{query}%")
  else
    @animals = db.execute("SELECT * FROM animals")
  end

  slim(:"animals/index")
end

get('/animals/new') do

  slim(:"animals/new")
end

post('/animals') do
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true
  name = params[:q]
  amount = params[:a]

  db.execute("INSERT INTO animals (name, amount) VALUES (?,?)",[name,amount])
  redirect('/animals')
end

post('/animals/:id/delete') do
  db = SQLite3::Database.new("db/animals.db")
  denna_ska_bort = params[:id].to_i
  db.execute("DELETE FROM animals WHERE id = ?",denna_ska_bort)
  redirect('/animals')
end

get('/animals/:id/edit') do
  db = SQLite3::Database.new("db/animals.db")
  db.results_as_hash = true
  id = params[:id].to_i
  @selected_animal = db.execute("SELECT * FROM animals WHERE id = ?",id).first

  slim(:"animals/edit")
end

post('/animals/:id/update') do
  db = SQLite3::Database.new("db/animals.db")

  id = params[:id].to_i
  name = params[:q]
  amount = params[:a].to_i

  db.execute('UPDATE animals SET name=?, amount=? WHERE id=?', [name, amount,id])

  redirect('/animals')
end