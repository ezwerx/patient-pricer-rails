class CreateSynonyms < ActiveRecord::Migration
  def self.up
    
    create_table :synonyms do |t|
        t.column :word_id,    :integer, :null => false
        t.column :synonym_id, :integer, :null => false
    end
    
    execute "alter table synonyms
             add constraint fk_synonym_word
             foreign key (word_id) references words(id)"
    
    execute "alter table synonyms
             add constraint fk_synonym_child
             foreign key (synonym_id) references words(id)"
    
  end

  def self.down
    drop_table :synonyms
  end
  
end
