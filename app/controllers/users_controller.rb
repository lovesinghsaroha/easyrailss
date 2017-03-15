class UsersController < ApplicationController
	  before_action :islogged , except: [:welcome , :login , :sign_in]
    
  def welcome
  end

  def dashboard
    @u = ErUser.find(session[:er_usr_parm])
  end

  def login
  	u = ErUser.find_by_email(params[:user][:email])
  	if u and u.authenticate(params[:user][:password])
  		session[:er_usr_parm] = u.id
  		redirect_to "/"
  	else
  		@lg_err_log = "Cannot log in.."
  		render "welcome"
  	end
  end

  def sign_up
  	u = ErUser.new(email: params[:user][:email],name: params[:user][:name],password: params[:user][:password],password_confirmation: params[:user][:password_confirmation])
  	if u.save
  		session[:er_usr_parm] = u.id
  		redirect_to "/"
  	else
  		@si_err_log = "Cannot add new user.."
  		render "welcome"
  	end
  end
end
