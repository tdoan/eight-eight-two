#
# Rakefile - rakefile
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
require "bundler/gem_tasks"
verbose(true)
SRC = FileList['lib/**/*.treetop']
DST = SRC.pathmap("%X.rb")
task :default => :build
task :build => :parser
task :parser => 'lib/config_parser/eight-eight-two_config.rb'
rule ".rb" => ".treetop" do |t|
  sh "tt -f -o #{t.name} #{t.source}"
end
