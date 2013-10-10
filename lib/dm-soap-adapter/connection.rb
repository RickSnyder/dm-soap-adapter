require 'savon' 

module DataMapper
  module Adapters
    module Soap
      
      class Connection

        def initialize(options)
          @wsdl_path = options.fetch(:path)
          @create_method = options.fetch(:create)
          @read_method = options.fetch(:read) # This maps to get a single object
          @update_method = options.fetch(:update)
          @delete_method = options.fetch(:delete)
          @query_method = options.fetch(:all) 
          @savon_options = {wsdl: @wsdl_path}
          if options[:logging_level] && options[:logging_level].downcase == 'debug'
            @savon_options[:log_level] = :debug
            @savon_options[:pretty_print_xml] = true            
          end
          @client = Savon::Client.new(@savon_options)
          @options = options
          @expose_client = @options.fetch(:enable_mock_setters, false)
        end
        
        def client=(client)
          @client = client if @expose_client
        end
        
        def client
          @client = Savon::Client.new(@savon_options)
        end
        
        def call_create(objects)
          call_service(@create_method, message: objects)
        end

        def call_update(objects)
          call_service(@update_method , message: objects)
        end

        def call_delete(keys)
          call_service(@delete_method, message: keys)
        end
    
        def call_get(id)
          call_service(@read_method, message: id)
        end
    
        def call_query(query)
          call_service(@query_method, message: query)
        end
        
        def call_service(operation, objects)
          DataMapper.logger.debug( "Calling #{operation.to_sym} with #{objects.inspect}")
          response = @client.call(operation.to_sym, objects)
        end
        
      end 
    end
  end
end