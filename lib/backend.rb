module EightEightTwo
  class Backend
    @backends = []
    def self.inherited(subclass)
      @backends << subclass
    end

    def self.backends
      @backends.dup
    end
  end
end
