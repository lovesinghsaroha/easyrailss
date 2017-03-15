class ErCtrlView < ApplicationRecord
	validates_presence_of :name 
	validates_uniqueness_of :uic
end
