class Synonym < ActiveRecord::Base

  belongs_to :parent_word, :class_name => "Word", :foreign_key => "word_id"
  belongs_to :child_word, :class_name => "Word", :foreign_key => "synonym_id"

end
