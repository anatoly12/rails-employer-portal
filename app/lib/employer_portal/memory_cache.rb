module EmployerPortal
  class MemoryCache

    # ~~ accessors ~~
    attr_reader :max_size

    # ~~ public instance methods ~~
    def initialize(max_size = 50)
      @max_size = max_size
      @cache = {}
    end

    def set(key, object, _ttl = nil)
      if cache.key? key
        cache.delete(key)
        cache[key] = object
      else
        cache[key] = object
        cache.shift if cache.size > max_size
      end
    end

    def get(key)
      cache[key]
    end

    def delete(key)
      cache.delete key
    end

    private

    attr_reader :cache
  end
end
