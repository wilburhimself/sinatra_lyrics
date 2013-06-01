require 'sinatra/base'
require 'lyricfy'
require 'sass'
require 'haml'

class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/templates/sass'

  get '/css/*.css' do
    filename = params[:splat].first
    sass filename.to_sym
  end

end

class MyApp < Sinatra::Base
  use SassHandler
  # Configuration ++++++++++++++++++++++++++++++++++++++++++++++++++++
  set :public_dir, File.dirname(__FILE__) + '/public'
  set :views, File.dirname(__FILE__) + '/templates'

  get '/' do
    haml :index
  end

  post '/' do
    fetcher = Lyricfy::Fetcher.new
    @song = fetcher.search params[:artist], params[:song]

    haml :index
  end
end

if __FILE__ == $0
  MyApp::run!
end
