class Word < ActiveRecord::Base
  
  has_many :parents, :class_name => "Synonym", :foreign_key => "synonym_id", :dependent => :destroy
  has_many :children, :class_name => "Synonym", :foreign_key => "word_id", :dependent => :destroy

  has_many :parent_words, :through => :parents  
  has_many :child_words, :through => :children  

  validates_presence_of :text
  validates_uniqueness_of :text
  
end
