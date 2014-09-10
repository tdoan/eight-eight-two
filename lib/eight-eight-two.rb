#!/usr/bin/env ruby
#
# eight-eight-two.rb - Main
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
require 'yaml'
require 'socket'
require 'etc'
require 'pathname'
require 'eventmachine'
require 'net/dns'

require 'version'
require 'config_parser/parser'

module EightEightTwo
  class NotFound < Exception
  end

  class Server < EventMachine::Connection
    def initialize(backend, *args)
      @backend = backend.new(*args)
      $stderr.puts "Backend Class: #{@backend.class}"
    end

    def receive_data(data)
      peer = get_peername
      srcport, srcip = Socket.unpack_sockaddr_in(peer)
      log = "#{Time.now.strftime('%Y-%m-%d %T')} srcip=#{srcip} srcport=#{srcport}"
      begin
        req = Net::DNS::Packet.parse(data)
        reqid = req.header.id
        log+=" reqid=#{reqid}"
        question = req.question[0]
        response = Net::DNS::Packet.new('127.0.0.1',Net::DNS::A)
        response.question = req.question
        header = Net::DNS::Header.new(id: req.header.id, aa: true, anCount: 1, opCode: 0, qr: 1, ra: 0)
        response.header = header
        answer = @backend.lookup(question.qName.to_s,
                        question.qClass.to_s,
                        question.qType.to_s)
        log+= " #{question.qClass} #{question.qType} #{question.qName}"
      rescue ArgumentError, Net::DNS::Packet::PacketError
        log += " Malformed request."
        return
      rescue NotFound => e
        response.header.rCode=3
        response.answer = []
        log+= " #{question.qClass} #{question.qType} #{question.qName} NOT FOUND"
      rescue Exception => e
        log += " Unknown Error, exception class was #{e.class}. #{e.message}"
        return
      else
        response.answer = answer
      end
      send_data(response.data)
      $stderr.puts log
    end

    def self.execute(options)
      EventMachine::run {
        options.config.each do |block|
          port = block.port
          ip = block.ip
          ip ||= '127.0.0.1'
          $stderr.puts "Starting server on #{ip}:#{port}..."
          begin
            klass_name = "EightEightTwo::Backends::#{block.backend.capitalize}"
            require("#{block.backend}")
            klass = Object.const_get(klass_name)
            options = block.options || {}
            EventMachine::open_datagram_socket("127.0.0.1",port, EightEightTwo::Server, klass, block.domain, options)
          rescue LoadError
            $stderr.puts "Unable to find backend #{block.backend}. Please make sure it is in the load path."
            exit(99)
          rescue RuntimeError => ex
            $stderr.puts ex.class
            $stderr.puts ex.inspect
            $stderr.puts "Unable to bind to socket, exiting."
            EM.stop
          end
        if Process.euid == 0
          $stderr.puts "dropping privileges"
          nobody_uid = [Etc.getpwnam('nobody').uid].pack("l").unpack("l").first
          process::sys.setuid(nobody_uid)
          process::uid.change_privilege(nobody_uid)
        end
        end
      }
      exit(99)
    end
  end
end
