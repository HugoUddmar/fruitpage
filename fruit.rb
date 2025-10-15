require 'sinatra'
require 'slim'
require 'sinatra/reloader'
require 'sqlite3'

get('/') do
  @h = "Hugo"
  slim(:about)
end

get('/fruits') do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  query = params[:q]

  if query && !query.empty?
    @fruits = db.execute("SELECT * FROM fruits WHERE name LIKE ?","%#{query}%")
  else
    @fruits = db.execute("SELECT * FROM fruits")
  end
  #Ge oss hash istället för arrayer
  #[{},{}]

  

  #Använd SQL för att prata med db
  #samt hämta allt från db

  slim(:"fruits/index")
end

get('/fruits/new') do
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true

  slim(:"fruits/new")
end

post('/fruits/:id/delete') do
  db = SQLite3::Database.new("db/fruits.db")
  #Extrahera id från sökväg för att få rätt frukt
  denna_ska_bort = params[:id].to_i
  #ta bort från db
  db.execute("DELETE FROM fruits WHERE id = ?",denna_ska_bort)
  redirect('/fruits')
end



post('/fruit') do 
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  fruit = params[:q]
  amount = params[:a]

  db.execute("INSERT INTO fruits (name, amount) VALUES (?,?)",[fruit,amount])
  redirect('/fruits') # Hoppa till routen som visar upp alla frukter

end

get('/fruits/:id/edit') do
  id = params[:id].to_i
  db = SQLite3::Database.new("db/fruits.db")
  db.results_as_hash = true
  @selected_fruit = db.execute("SELECT * FROM fruits WHERE id = ?",id).first

  slim(:"fruits/edit")
end

post('/fruits/:id/update') do
  db = SQLite3::Database.new("db/fruits.db")

  id = params[:id].to_i
  name = params[:name]
  amount = params[:amount].to_i

  db.execute("UPDATE fruits SET name=?, amount=? WHERE id=?", [name,amount,id])

  redirect('/fruits')
end

get('/hugo/:id') do
  @Hugo = {
          "name" => "Hugo",
          "height" => "182 cm",
          "favoämne" => "matte"
  }

  @id = params[:id]

  @sak = @Hugo[@id]

  slim(:hugo)
end

get('/fruits2/:id') do
  id = params[:id].to_i
  @fruits = ["banan","durian","äpple","jordgubbe"]
  @fruit = @fruits[id-1]
  slim(:fruits)
end

get('/dogs') do
  @dogs = [
    {
      "name" => "Miles",
      "age" => "88",
    },
    {
      "name" => "David",
      "age" => "37",
    },
    {
      "name" => "Otis",
      "age" => "16",
    },
    {
      "name" => "Bruno",
      "age" => "39",
    }
  ]

  slim(:dogs)
end

