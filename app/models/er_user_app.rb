class ErUserApp < ApplicationRecord
	validates_presence_of :name
	validates_uniqueness_of :rep_n
end
