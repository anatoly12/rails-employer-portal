module EmployerPortal
  class MemoryCache

    # ~~ public instance methods ~~
    def initialize(max_size = 50)
      @max_size = max_size
      @cache = {}
    end

    def set(key, object, _time)
      cache[key] = object
      cache.shift if cache.size > max_size
    end

    def get(key)
      cache[key]
    end

    def delete(key)
      cache.delete key
    end

    private

    attr_reader :max_size, :cache
  end
end
