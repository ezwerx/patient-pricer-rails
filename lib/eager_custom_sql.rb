# This Active Record mod enables eager loading of associations
# (the :include option) for both the find_by_sql method and has_many
# and has_and_belongs_to_many associations that use the :finder_sql option.
#
# The custom sql must include a left outer join for each eager-loaded model,
# and in addition must alias each selected field using the following aliases:
#    Primary key of base model: t0_r0
#    Other fields from base model: t0_rm, where m is the (m-1)th field of the table
#    Primary key of eager loaded models: tn_r0, where n is nth outer-joined table
#    Other fields from eager loaded models: the appropriate tn_rm alias
#
module ActiveRecord
  
  module Associations
    
    class AssociationProxy
    end
    
    class AssociationCollection < AssociationProxy
    end
    
    class HasManyAssociation < AssociationCollection
      protected
        def find_target
          if @reflection.options[:finder_sql]
            @reflection.klass.find_by_sql(@finder_sql, :include => @reflection.options[:include])
          else
            find(:all)
          end
        end
    end

    class HasAndBelongsToManyAssociation < AssociationCollection
      protected
        def find_target
          if @reflection.options[:finder_sql]
            records = @reflection.klass.find_by_sql(@finder_sql, :include => @reflection.options[:include])
          else
            records = find(:all)
          end
                                                                                                                              
          @reflection.options[:uniq] ? uniq(records) : records
        end
    end
    
  end

  class Base
    def self.find_by_sql_with_options(sql, options = {})
      options.assert_valid_keys [:include]
      sanitized_sql = sanitize_sql(sql)
      if options[:include].blank?
        connection.select_all(sanitized_sql, "#{name} Load").collect! { |record| instantiate(record) }
      else
        find_with_associations(options.merge(:sql => sanitized_sql))
      end
    end

    private
      def self.select_all_rows(options, join_dependency)
        connection.select_all(
          options[:sql] || construct_finder_sql_with_included_associations(options, join_dependency),
          "#{name} Load Including Associations"
        )
      end
      
  end
  
end