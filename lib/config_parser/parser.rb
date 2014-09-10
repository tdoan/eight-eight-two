#
# parser.rb - Engine to run treetop grammar.
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
require 'treetop'

require File.expand_path('../node_extensions', __FILE__)
require File.expand_path('../eight-eight-two_config', __FILE__)

module EightEightTwo
  class ConfigParseException < Exception
  end

  class Parser
    # Treetop.load(File.expand_path('../eight-eight-two_config.treetop', __FILE__))
    @@parser = EightEightTwoConfigParser.new

    def self.parse(data)
      tree = @@parser.parse(data)
      if(tree.nil?)
        raise ConfigParseException , @@parser.failure_reason
      end
      return tree
    end
  end
end
