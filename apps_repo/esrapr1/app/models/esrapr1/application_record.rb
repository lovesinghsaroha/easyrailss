module Esrapr1 
 class ApplicationRecord < ActiveRecord::Base 
 self.abstract_class = true 
 establish_connection(adapter: 'mysql2' , host: 'localhost' , username: 'root' , password: 'love6226' , database: 'blogbo_dev') 
 end 
 end 
