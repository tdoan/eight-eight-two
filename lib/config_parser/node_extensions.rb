#
# node_extensions.rb - Data classes for treetop grammar.
#
# ====================================================================
# Copyright (c) 2014 Tony Doan <tdoan@tdoan.com>.  All rights reserved.
#
# This software is licensed as described in the file LICENSE.txt, which
# you should have received as part of this distribution.  The terms
# are also available at http://github.com/tdoan/eight-eight-two/tree/master/LICENSE.txt.
# If newer versions of this license are posted there, you may use a
# newer version instead, at your option.
# ====================================================================
#
module EightEightTwoConfig
  class IntegerLiteral < Treetop::Runtime::SyntaxNode
    def to_i
      return self.text_value.to_i
    end
  end

  class StringLiteral < Treetop::Runtime::SyntaxNode
  end

  class FloatLiteral < Treetop::Runtime::SyntaxNode
  end

  class Identifier < Treetop::Runtime::SyntaxNode
  end

  class ServerBlock < Treetop::Runtime::SyntaxNode
    def port
      @h[:port]
    end
    def backend
      @h[:backend]
    end
    def ip
      @h[:ip]
    end
    def domain
      @h[:domain]
    end
    def options
      @h[:options]
    end
    def to_h
      @h ||= bbody.to_h
    end
  end

  class Body < Treetop::Runtime::SyntaxNode
  end

  class BlockBody < Treetop::Runtime::SyntaxNode
    def to_h
      h = {}
      elements.each do |e|
        if e.respond_to?(:k_v)
          k,v = e.k_v 
          h[k] = v
        else
          # $stderr.puts e.inspect
        end
      end
      h
    end
  end

  class Port < Treetop::Runtime::SyntaxNode
    def k_v
     [:port, (port_number.to_i)] 
    end
  end

  class Ip < Treetop::Runtime::SyntaxNode
    def k_v
      [:ip, ip.text_value]
    end
  end

  class DomainName < Treetop::Runtime::SyntaxNode
    def k_v
      [:domain, string.text_value]
    end
  end

  class Backend < Treetop::Runtime::SyntaxNode
    def k_v
      [:backend, string.text_value]
    end
  end

  class Options < Treetop::Runtime::SyntaxNode
    def k_v
      self.ob.k_v
    end
  end

  class OptionsBody < Treetop::Runtime::SyntaxNode
    def k_v
      h={}
      elements.each do |e|
        next unless e.is_a? EightEightTwoConfig::Option
        k,v = e.k_v
        h[k] = v
      end
      [:options, h]
    end
  end

  class Option < Treetop::Runtime::SyntaxNode
    def k_v
      [self.key.text_value, self.value.text_value]
    end
  end
end
