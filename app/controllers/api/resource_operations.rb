module API::ResourceOperations
  extend Grape::API::Helpers

  %w[index show create update destroy].each do |name|
    define_method(name) { |**options, &block| action name, options, &(block || default_block) }
  end

  def default_block
    Proc.new { |result| result['model'] }
  end

  def action name, **options
    result = operation_for(name).(params: params, **options)
    if result.success?
      yield result
    else
      error!(result['errors'], result['code'])
    end
  end

  def operation_for action
    "#{namespace}/operation/#{action}".classify.constantize
  end
end
