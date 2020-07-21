class Audit < Sequel::Model

  # ~~ plugins ~~
  plugin :polymorphic
  plugin :serialization, :json, :changes

  # ~~ associations ~~
  many_to_one :item, polymorphic: true
  many_to_one :created_by, polymorphic: true
end
