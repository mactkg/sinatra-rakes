require 'sinatra/base'

class App < Sinatra::Base
  get '/' do
    return 'hello world'
  end

  get '/users/:id' do
    return "your id is: #{params[:id]}"
  end
end
