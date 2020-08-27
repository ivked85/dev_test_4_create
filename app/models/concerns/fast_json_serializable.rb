module FastJsonSerializable
  extend ActiveSupport::Concern
  
  def as_json(options)
    return super(options) unless serializer_class
    
    serializer_class.new(self).serializable_hash
  end

private

  def serializer_class
    serializer_name.constantize if Object.const_defined?(serializer_name)
  end

  def serializer_name
    "#{self.class.name}Serializer"
  end
end
