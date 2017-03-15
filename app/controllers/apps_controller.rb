	require 'json'
	require 'dropbox_sdk'
	APP_KEY = 'mis9kxt9yt5kv22'
    APP_SECRET = 'rya345l06cguky7'


class AppsController < ApplicationController
	before_action :isloggedj 
	before_action :set_def 
	before_action :find_ua , except: [:create , :get_apps , :get_app]

# Apps Crud----------------------------------------------
# Create apps in er
	def create
		nid = 1
		lua = ErUserApp.last
		if lua
			nid = lua.id + 1
		end	
		if nid < 5
			ua = ErUserApp.new(name: params[:name] , description: params[:description] , rep_n: "esrapr#{nid}")
			if ua.save
		        am = ErAppMember.new(er_user_app_id: ua.id , er_user_id: session[:er_usr_parm] , uic: "#{ua.id}.#{session[:er_usr_parm]}",owner: true)				
				if am.save
					@res = am
				    @status = 200
				end
			end
		end
		render json: @res.to_json(include: :er_user_app) , status: @status	
	end

# Get user apps in er dash
	def get_apps
		am = ErAppMember.where(er_user_id: session[:er_usr_parm])
		render json: am.to_json(include: :er_user_app) , status: 200
	end

# Get single app info in er
	def get_app
		    ua = ErUserApp.find(params[:id])
		    if ua
		        am = ErAppMember.find_by(er_user_id: session[:er_usr_parm],er_user_app_id: ua.id) 
		        if am
		        	@status = 200
			        session[:er_usr_app_parm] = ua.id
			        @res = ua
		        end
		    end
			render json: @res , status: @status
	end
# Apps Crud ends------------------------------------------------

# Apps Controller Crud------------------------------------------
# Create controllers in er apps
	def create_ctrl
		ac = ErAppCtrl.new(name: params[:name], er_user_app_id: @ua.id, uic: "#{params[:name]}.#{@ua.id}",content: "")
		if ac.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/controllers/#{@ua.rep_n}/#{ac.name}_controller.rb","" , false)
			#Dir.mkdir "apps_repo/#{@ua.rep_n}/app/views/#{@ua.rep_n}/#{ac.name}"
			@status = 200
			@res = ac
		end
		render json: @res , status: @status
	end

# Get all controllers of er app
	def get_ctrls
		ac = ErAppCtrl.where(er_user_app_id: @ua.id)
		@status = 200
		@res = ac 
		render json: @res , status: @status
	end

# Update controller code in er app
	def update_ctrl
		ac = ErAppCtrl.find_by(name: params[:name] , uic: "#{params[:name]}.#{@ua.id}")
		ac.content = params[:content]
		if ac.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/controllers/#{@ua.rep_n}/#{ac.name}_controller.rb" , "require_dependency '#{@ua.rep_n}/application_controller' \n  module #{@ua.rep_n.capitalize}\n  class #{ac.name.capitalize}Controller < ApplicationController\n " + ac.content +  "\n end\n  end" , true)
			@status = 200
		end
		render json: @res , status: @status		
	end
# Apps Controller Crud ends---------------------------------------------

# Apps Models Crud-------------------------------------------------------
# Get models code of er apps
	def get_models
		am = ErAppModel.where(er_user_app_id: @ua.id)
		@status = 200
		@res = am 
		render json: @res , status: @status			
	end

# Create model of er app
	def create_model
		am = ErAppModel.new(name: params[:name], er_user_app_id: @ua.id, uic: "#{params[:name]}.#{@ua.id}",content: "",table_n: params[:table_n])
		if am.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/models/#{@ua.rep_n}/#{am.name}.rb" , "module #{@ua.rep_n.capitalize}\n  class #{am.name.capitalize} < ApplicationRecord\n self.table_name = '#{am.table_n}' \n end\n end \n" ,false)
			@status = 200
			@res = am
		end
		render json: @res , status: @status				
	end

# Update model of er app
	def update_model
		am = ErAppModel.find_by(name: params[:name] , uic: "#{params[:name]}.#{@ua.id}")
		am.content = params[:content]
		if am.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/models/#{@ua.rep_n}/#{am.name}.rb","module #{@ua.rep_n.capitalize}\n  class #{am.name.capitalize} < ApplicationRecord\n self.table_name = '#{am.table_n}' \n " + am.content + "\n end \n end \n" , true)
			@status = 200
		end
		render json: @res , status: @status			
	end
# Apps Models Crud ends--------------------------------------------------

# Apps Views Crud--------------------------------------------------------
# Get views code of er app
	def get_views
		cv = ErCtrlView.where(er_user_app_id: @ua.id , ctrl_n: params[:ctrl_n])
		@status = 200
		@res = cv
		render json: @res , status: @status	 
	end

# Create views in er app
	def create_view
		cv = ErCtrlView.new(name: params[:name], er_user_app_id: @ua.id, uic: "#{params[:name]}.#{params[:ctrl_n]}",ctrl_n: params[:ctrl_n],content: "")
		if cv.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/views/#{cv.ctrl_n}-#{cv.name}.html.erb", "" , false)
			@status = 200
			@res = cv
		end
		render json: @res , status: @status			
	end

# Update views in er apps
	def update_view
		cv = ErCtrlView.find_by(name: params[:name] , uic: "#{params[:name]}.#{params[:ctrl_n]}")
		cv.content = params[:content]
		if cv.save
			write_file_d("apps_repo/#{@ua.rep_n}/app/views/#{cv.ctrl_n}-#{cv.name}.html.erb" , cv.content , true)
			@status = 200
		end
		render json: @res , status: @status			
	end
# Apps Views Crud ends-------------------------------------------------

# Apps Other related info and data-------------------------------------
# Update routes of er apps
	def update_routes
	    @ua.routes_inf = params[:routes_inf]
	    if @ua.save
	    	write_file_d("apps_repo/#{@ua.rep_n}/config/routes.rb","#{@ua.rep_n.capitalize}::Engine.routes.draw do \n" + @ua.routes_inf + "\n end \n" , true)
			@status = 200
	    end
		render json: @res , status: @status		    	
	end

# Update app db info
    def update_db
    	@ua.db_inf = params[:db_inf]
    	if @ua.save
    		js = JSON.parse(@ua.db_inf)
    		write_file_d("apps_repo/#{@ua.rep_n}/app/models/#{@ua.rep_n}/application_record.rb" , "module #{@ua.rep_n.capitalize} \n class ApplicationRecord < ActiveRecord::Base \n self.abstract_class = true \n establish_connection(adapter: '#{js['adapter']}' , host: '#{js["host"]}' , username: '#{js["username"]}' , password: '#{js["password"]}' , database: '#{js["database"]}') \n end \n end \n",true)
    		@status = 200
    	end
    	render json: @res , status: @status	
    end	

# Apps Other info and data ends-----------------------------------------	

# Private functions
    private

# Set default objects before method calls
    def set_def
    	@status = 500
    	@res = {}
    end

# Write file data
    def write_file_d(loc , cont , upd)
    	if Rails.env.production?
    		if upd
    			open("/Apps/heroku/easyrails/" + loc, 'w') {|f| f.puts cont}
    		else
    			client = DropboxClient.new("Uvvp9nfYjAAAAAAAAAAAEArT_bJ3I4xhUwL2pHhMY3KHgNsIxf_5hLxCNSfCq3mI")
    		    response = client.put_file("/Apps/heroku/easyrails/" + loc, cont)
    		end
    	else
    		File.open(loc , 'w') do |f|
				f.write(cont)
			end
    	end
    end
# Get user app info 
    def find_ua
    	@ua = ErUserApp.find(session[:er_usr_app_parm])
    	if not @ua
    		render json: {} , status: 500		 
    	end
    end    
end
