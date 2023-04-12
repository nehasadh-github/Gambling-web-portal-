require 'sinatra'
require 'sinatra/reloader'
require './user'

enable :sessions

get '/home' do
  erb :home
end

get '/login' do
  erb :login
end

get '/signup' do
  erb :signup
end

post '/signup' do
  if(!User.first(username: params[:username]))
    User.create(username: params[:username], password: params[:password],totalwin:"0",totalloss:"0",totalprofit:"0")
    session[:message] = "new Username #{params[:username]} is created"
    redirect '/login'
  else
    session[:message] = "Username #{params[:username]} is already exists"
    redirect '/signup'
  end
end

post '/login' do
  user = User.first(username: params[:username])
  if user != nil  && user.password != nil &&
      params[:password] == user.password
      session[:name] = params[:username]
      redirect to '/users'
  else
      session[:message] = "Username or Password incorrect"
      redirect '/login'
  end
end

get '/bettingform' do
  if session[:name] != nil
    user = User.first(username: session[:name])
    @totalwin = session[:totalwin]
    @totalloss = session[:totalloss]
    @totalprofit = session[:totalprofit]
    @winSessvalue = session[:win]
    @lossSessvalue = session[:loss]
    @profitSessvalue = session[:profit]
    erb :bettingform
  else
   redirect '/home'
  end
end

post '/bettingform' do
  money = params[:money].to_i
  number = params[:number].to_i
  roll = rand(6) + 1
  if number == roll
    save_session(:win, 5*money)
    save_session(:profit, 4*money)
    save_session(:totalwin, 5*money)
    save_session(:totalprofit, 4*money)
    session[:message] = "The dice landed on #{roll}, you choose #{number} and you won #{5*money} dollars"
  else
    save_session(:loss, money)
    save_session(:profit, -1*money)
    save_session(:totalloss, money)
    save_session(:totalprofit, -1*money)

    session[:message] = "The dice landed on #{roll}, you choose #{number} and you lost #{money} dollars"
  end
  redirect '/bettingform'
end

post '/logout' do
  user = User.first(username: session[:name])
  user.update(totalwin: session[:totalwin])
  user.update(totalloss: session[:totalloss])
  user.update(totalprofit: session[:totalprofit])
  session[:login] = nil
  session[:name] = nil
  redirect '/home'
end


get '/users' do
  if session[:name] != nil
    user = User.first(username: session[:name])
    @totalwin = user.totalwin
    @totalloss = user.totalloss
    @totalprofit = user.totalprofit
    session[:totalwin] = user.totalwin
    session[:totalloss] = user.totalloss
    session[:totalprofit] = user.totalprofit
    session[:win] = 0
    session[:loss] = 0
    session[:profit] = 0
    @winSessvalue = session[:win]
    @lossSessvalue = session[:loss]
    @profitSessvalue = session[:profit]
    erb :bettingform
  else
    redirect '/home'
  end
end


def save_session(parameter, money)
  count = (session[parameter] || 0).to_i
  count += money
  session[parameter] = count
end

not_found do
  "Page not found"
end
