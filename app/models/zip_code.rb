class ZipCode < Sequel::Model

  # ~~ constants ~~
  CACHE = EmployerPortal::MemoryCache.new

  # ~~ plugins ~~
  unrestrict_primary_key
  plugin :caching, CACHE

end
