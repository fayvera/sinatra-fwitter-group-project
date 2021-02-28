class UsersController < ApplicationController

    get '/signup' do
        if !logged_in?
            erb :'/users/create_user', locals: {message: "Please sign up before you sign in."} 
        else 
            redirect to "/tweets"
        end
    end

    get '/users/:slug' do
        @user = User.find_by_slug(params[:slug])
        erb :'users/show'
    end
    # post '/users/:slug' do
    #     if logged_in?
    #         @user = User.find_by_slug(params[:slug])
    #         redirect to "/users/#{@user.slug}"
    #     else
    #         redirect to '/login'
    #     end
    # end

    get '/login' do
        if !logged_in?
            erb :'/users/login'
        else
            redirect to "/tweets"
        end
    end

    post '/signup' do 
        if params[:username] == "" || params[:email] == "" || params[:password] == ""
            redirect to "/signup"
        elsif @user = User.find_by(:username => params[:username], :email => params[:email])
            redirect to "/login", locals: {message: "User already exists."}
        else
            @user = User.create(:username => params[:username], :email => params[:email], :password => params[:password])
            session[:user_id] = @user.id
            redirect to "/tweets"
        end
    end


    post '/login' do
        user = User.find_by(:username => params[:username])
        if user && user.authenticate(params[:password])
            session[:user_id] = user.id
            redirect to '/tweets'
        else
            redirect to '/signup'
        end
    end


    get '/logout' do
        if logged_in?
            session.destroy
            redirect to '/login'
        else
            redirect to '/'
        end
    end
end
