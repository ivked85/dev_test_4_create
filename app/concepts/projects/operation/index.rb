module Projects::Operation
  class Index < Trailblazer::Operation
    step :pagination!
    step :model!

  private

    def pagination!(ctx, headers: {}, **)
      ctx['pagination.page'] = headers['Pagination-Page'] || 0
      ctx['pagination.limit'] = headers['Pagination-Limit'] || 5
    end

    def model!(ctx, **)
      ctx['model'] = Project.paginate(page: ctx['pagination.page'].to_i,
                                      limit: ctx['pagination.limit'].to_i)
    end
  end
end
