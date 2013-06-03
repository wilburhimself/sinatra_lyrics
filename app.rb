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
  set :root, MyApp.root

  get '/' do
    haml :index
  end

  post '/' do
    fetcher = Lyricfy::Fetcher.new
    @input_artist = params[:artist]
    @input_song   = params[:song]

    if !params[:artist].empty? and !params[:song].empty?
      @song    = fetcher.search params[:artist], params[:song]
      @message = "No song was found." if !@song
    else
      @missing_artist = params[:artist].empty?
      @missing_song   = params[:song].empty?
      @message        = "You have to enter the artist name and the song name."
    end

    haml :index
  end
end

MyApp::run! if __FILE__ == $0
