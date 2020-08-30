module API::Helpers::ResourceOperations
  extend Grape::API::Helpers

  %w[index show create update destroy].each do |name|
    define_method(name) { |**options, &block| action name, options, &(block || default_block) }
  end

  def default_block
    proc { |result| result['model'] }
  end

  def action(name, **options)
    result = operation_for(name).(
      params: params,
      headers: headers,
      current_user: current_user,
      **options
    )

    return yield result if result.success?

    error!(result['errors'], result['code'])
  end

  def operation_for(action)
    "#{namespace}/operation/#{action}".classify.constantize
  end
end
