class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def islogged
  	if not session[:er_usr_parm]
  		redirect_to "/welcome"
  	end
  end

  def isloggedj
  	if not session[:er_usr_parm]
  		render json: {error: "You are not logged in.."} , status: 500
  	end
  end
end
