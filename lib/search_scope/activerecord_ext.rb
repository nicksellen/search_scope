module SearchScope
  
  module ClassMethods
    
    def search_scope(options)
			types = options[:types]      
      @default_search_type = options[:default].to_s if options[:default] 
      return unless types.is_a?(Hash)

      types.each do |key,value|          
        (@search_types ||= {})[key] = value if value.is_a?(Array)
      end

			named_scope :search, lambda { |*args|
				{ :conditions => conditions_for_search(*args) } 
			}

			instance_eval <<-EOF
	    	def conditions_for_search(queries,options = {})
					find_arguments = {}
		      [options,@search_types].each { |h| h.stringify_keys! }
		      fields = if options["type"] && @search_types.keys.include?(options["type"].to_s)
		       	@search_types[options["type"].to_s]        
		      else
		        @search_types[@default_search_type]
		      end
	      	if fields
		      	queries = [queries] unless queries.is_a?(Array)
						values = {}
						
						sql = queries.enum_with_index.map do |query,index|
							value_name = "term_\#{index}"
							values[value_name.to_sym] = "%\#{query.downcase}%"
			        fields.map do |field|
			          "lower(\#{quoted_table_name}.`\#{field}`) like :\#{value_name}"   
			        end.join(" OR ")			
						end.join(" OR ")
						
						[sql,values]
				  else
		        raise "cannot work out which fields to search on, did you set some options and stuff?"
		      end
  			end
			EOF
		end
  	end
end

ActiveRecord::Base.extend(SearchScope::ClassMethods)
