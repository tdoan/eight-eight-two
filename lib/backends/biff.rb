require 'erb'
require 'eventmachine'
require 'pathname'
require 'rb-fsevent'

class DirWatcher < EventMachine::Connection
  def initialize(notifyee)
    @notifyee = notifyee
  end

  def receive_data data
    @notifyee.reload
  end

  def unbind
    $stderr.puts "watcher died with exit status: #{get_status.exitstatus}"
    watch_path = File.expand_path( "../bin/fsevent_watch", ($:.grep /rb-fsevent/)[0] )
    $stderr.puts "Starting a new one"
    EventMachine.popen("#{watch_path} #{File.expand_path('~/.biff')}", DirWatcher, @notifyee)
  end
end

module EightEightTwo
  module Backends
    class Biff < EightEightTwo::Backend
      def initialize(domain,options={})
        @subdomain = domain
        reload
        watch_path = File.expand_path( "../bin/fsevent_watch", ($:.grep /rb-fsevent/)[0] )
        begin
          EventMachine.popen("#{watch_path} #{File.expand_path('~/.biff')}", DirWatcher, self)
        rescue RuntimeError
          $stderr.puts "Popen unsupported on this platform, automatic reloading disabled."
        end
      end

      def lookup(qname, qclass, qtype)
        begin
          lookupname = qname.gsub(/\.#{@subdomain}\.$/,'')
          if (@biffs.fetch(lookupname) and qclass == "IN" and qtype == "A")
            answer = Net::DNS::RR::A.new(
              name: qname,
              ttl:  360,
              cls:  Net::DNS::IN,
              type: Net::DNS::A,
              address: "127.0.0.1" )
            return answer
          end
        rescue KeyError
          raise NotFound
          return nil
        else 
          raise NotFound
        end
      end

      def reload
        @biffs = {}
        $stderr.puts "Biff is reloading..."
        biff_dir = Pathname.new('~/.biff').expand_path
        biff_nginx = Pathname.new('~/.biff.nginx').expand_path
        File.open(biff_nginx,'w') do |nginx_file|
          biff_dir.each_child do |child|
            app_name = child.basename.to_s
            @biffs[app_name] = child.realpath if File.directory?(child)
            link_dest = @biffs[app_name]
            $stderr.puts "Will respond to: #{app_name}.#{@subdomain}"
            template_path = File.expand_path("../../../conf/rails.nginx.erb",__FILE__)
            data = File.open(template_path,'r').read
            nginx_file.puts ERB.new(data,nil,'-').result(binding)
          end
        end
      end
    end
  end
end
