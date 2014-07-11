require 'rubygems';
require 'sinatra';
require 'haml'
require 'sinatra/formkeeper'

FILE = '/tmp/msgs'
form_messages File.expand_path(File.join(settings.root, 'messages', 'en.yml'))

enable :sessions

def read_messages(lines)
  open("/tmp/" + session[:logged_room], "w") do |f|
    f.puts("nobody;hello "+ session[:logged_room])
  end unless File.exist?("/tmp/" + session[:logged_room])
  content = IO.readlines("/tmp/" + session[:logged_room])
  if content.length < lines
    content
  else
    content[-lines..-1]
  end
end

helpers do

  def location(loc)
    "location.href = '" + url(loc) + "'"
  end

  def partial(page, options = {})
    haml page.to_sym, options.merge!(:layout => false)
  end

  def logged_room?
    if !session[:logged_room].nil?
      pass = File.read("/tmp/" + session[:logged_room] + ".pwd")
      session[:logged_password].eql?(pass)
    else
      nil
    end
  end

end

get '/' do
  if logged_room?
    redirect to("/talking")
  end
  haml :index, :layout => :layout
end

post '/create' do
  form do
    field :name, :present => true
    field :password, :present => true
  end
  if form.failed?
    output = haml :index, :layout => :layout
    fill_in_form(output)
  else
    if File.exist?("/tmp/" + form[:name])
      if File.read("/tmp/" + form[:name] + ".pwd") == form[:password]
        session[:logged_room] = form[:name]
        session[:logged_password] = form[:password]
        redirect url("/talking")
      else
        @error_message = "wrong password"
        output = haml :index, :layout => :layout
        fill_in_form(output)
      end
    else
      File.open("/tmp/" + form[:name] + ".pwd", 'w') { |file| file.write(form[:password]) }
      session[:logged_room] = form[:name]
      session[:logged_password] = form[:password]
      redirect url("/talking")
    end
  end
end

get '/leave' do
  session[:logged_room] = nil
  session[:logged_password] = nil
  redirect to("/")
end

get '/talking' do
  if logged_room?.nil?
    @room = session[:logged_room]
    haml :login, :layout => :layout
  else
    @messages = read_messages(10)
    haml :talking, :layout => :layout
  end
end

post '/send' do
  if !params[:message].nil?
    newcontent = read_messages(9).push(params[:nick]. + ";" + params[:message])
    open("/tmp/" + session[:logged_room], 'w') do |f|
      newcontent.each do |line|
        f.puts(line)
      end
    end
  end
  @messages = read_messages(10)
  @nick = params[:nick]
  haml :talking, :layout => :layout
end

get '/messages' do
  if logged_room?
    @messages = read_messages(10)
    partial "messages"
  end
end