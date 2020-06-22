class Capybara::Driver::Node
  def submit
    raise NotImplementedError
  end
end

class Capybara::RackTest::Node
  def submit
    Capybara::RackTest::Form.new(driver, self.native).submit({})
  end
end

class Capybara::Node::Element
  def submit
    base.submit
  end

  def parent_form
    find(:xpath, "ancestor::form")
  end
end
