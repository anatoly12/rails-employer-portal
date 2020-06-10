class EmployeesController < ApplicationController

  def index
  end

  def create
    bulk = EmployerPortal::EmployeeBulkImport.new(params)
    if bulk.has_file?
      raise "bulk: #{bulk.csv.inspect}"
    else
      raise "manual create"
    end
  end

private

  def employees
    []
  end
  helper_method :employees

end
