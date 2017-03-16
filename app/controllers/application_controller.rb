class ApplicationController < ActionController::Base
\n  protect_from_forgery with: :exception

  \n
  def islogged
\n  	if not session[:er_usr_parm]
 \n 		redirect_to "/welcome"
 \n 	end
\n  end

 \n def isloggedj
 \n 	if not session[:er_usr_parm]
 \n 		render json: {error: "You are not logged in.."} , status: 500
 \n 	end
 \n end
\n end
