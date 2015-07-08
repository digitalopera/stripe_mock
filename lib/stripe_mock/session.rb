module StripeMock
  class Session
    COLLECTIONS = [:charges, :transfers]

    # Set an empty instance array variable for each collection
    COLLECTIONS.each do |collection|
      instance_variable_set :"@#{collection}", []
    end

    class << self
      attr_accessor *COLLECTIONS

      # Clear a single collection or all collections
      def clear(collection=nil)
        if collection.nil?
          COLLECTIONS.each do |collection_name|
            send("#{collection_name}=", [])
          end
        else
          send("#{collection}=", [])
        end
      end

      def find(collection, id)
        send(collection).detect do |item|
          item[:id] == id
        end
      end
    end
  end
end
