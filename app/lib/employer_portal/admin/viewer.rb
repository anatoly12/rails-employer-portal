class EmployerPortal::Admin::Viewer
  # ~~ delegates ~~
  delegate :created_at, :to_param, to: :decorated

  # ~~ public instance methods ~~
  def initialize(context, decorated)
    @context = context
    @decorated = decorated
  end

  private

  attr_reader :context, :decorated
end
