class PaginatedController < ApplicationController
  include Pagy::Backend

  private

  def pagy_get_vars(collection, vars)
    {
      count: collection.count,
      page: params["page"],
      items: vars[:items],
    }
  end
end
