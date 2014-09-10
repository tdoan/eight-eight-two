# coding: utf-8
#
# eight-eight-two.gemspec - Gemspec
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
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name          = "eight-eight-two"
  spec.version       = EightEightTwo::VERSION
  spec.authors       = ["Tony Doan"]
  spec.email         = ["tdoan@tdoan.com"]
  spec.summary       = %q{A simple DNS server with pluggable backends.}
  spec.description   = %q{A DNS server written using EventMachine. }
  spec.homepage      = "http://github.com/tdoan/eight-eight-two"
  spec.license       = "MIT"

  spec.files         = %W{lib/eight-eight-two.rb lib/version.rb lib/config_parser/eight-eight-two_config.rb bin/eet eight-eight-two.gemspec LICENSE.txt README.md Rakefile}
  spec.files         += Dir.glob("lib/config_parser/*")
  spec.executables   = %W{eet}
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "treetop", "~> 1.5"
  spec.add_dependency "net-dns", "~> 0.8"
  spec.add_dependency "eventmachine", "~> 1.0"
end
