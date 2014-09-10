module EightEightTwo
  module Backends
    class Log < EightEightTwo::Backend
      def initialize(domain, options)
      end

      def lookup(qname, qclass, qtype)
        $stderr.puts "#{qname} #{qclass} #{qtype}"
        raise NotFound
      end
    end
  end
end
