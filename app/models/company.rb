class Company < Sequel::Model

  # ~~ plugins ~~
  plugin :uuid
  plugin :timestamps

  # ~~ associations ~~
  one_to_many :employers, class: "Employer"

end
