module EightEightTwo
  module Backends
    class Print < EightEightTwo::Backend
      def initialize
      end

      def lookup(qname, qclass, qtype)
        $stderr.puts " qname=#{qname} qclass=#{qclass} qtype=#{qtype}"
        # raise NotFound
        # answer = Net::DNS::RR::A.new("#{req.question.first} 192.168.0.1") #This can throw a InvalidAddressError
        answer1 = Net::DNS::RR::A.new(name: qname,
                                      ttl:  360,
                                      cls:  Net::DNS::IN,
                                      type: Net::DNS::A,
                                      address: "127.0.0.1" )
        answer2 = Net::DNS::RR::A.new(name: qname,
                                      ttl:  360,
                                      cls:  Net::DNS::IN,
                                      type: Net::DNS::A,
                                      address: "127.0.0.2" )
        answer = [answer1,answer2]
      end
    end
  end
end
