module Models
  module JsonSerializations
    extend ActiveSupport::Concern
    include ActiveModel::Serializers::JSON

    included do
      def attributes=(hash)
        model_name = self.class.name.underscore
        attributes_list = self.attributes.keys
        hash = hash[model_name] if hash[model_name]
        hash.each do |key, value|
          normalized_key = key.underscore
          send("#{normalized_key}=", value) if attributes_list.include?(normalized_key)
        end
      end
    end
  end
end
