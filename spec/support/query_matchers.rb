RSpec::Matchers.define :be_sortable do |column, items|
  match do
    res = subject.search_dataset({}, "#{column}:asc").all
    expect(res.map(&:pk)).to eql items.map(&:pk)
    res = subject.search_dataset({}, "#{column}:desc").all
    expect(res.map(&:pk)).to eql items.map(&:pk).reverse
  end
  description { "be sortable by #{column}" }
end
