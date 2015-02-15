require "./application"

map "/" do
  run Sinatra:Application
end
