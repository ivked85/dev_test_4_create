module Projects::Operation
  class Index < BaseOperation
    step :pagination!
    step :model!
    step Subprocess(Task::Authorize)

    private

    def pagination!(ctx, headers: {}, **)
      ctx['pagination.page'] = headers['Pagination-Page'] || 0
      ctx['pagination.limit'] = headers['Pagination-Limit'] || 5
    end

    def model!(ctx, **)
      ctx['pagination.item_count'] = Project.all.count
      ctx['model'] = Project.includes(:client)
                            .paginate(page: ctx['pagination.page'].to_i,
                                      limit: ctx['pagination.limit'].to_i)
    end
  end
end
