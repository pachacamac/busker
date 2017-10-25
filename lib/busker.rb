require 'busker/version'
require 'webrick'
require 'cgi'
require 'erb'

module Busker
  class Busker
    def initialize(opts={}, &block)
      @_ = {:routes => {}} #using @_ to store instance variables so they're less likely to get overwritten unintentionally while still allowing easy access when needed
      instance_eval(&block) if block_given?
      opts[:Port] ||= opts.delete(:port) || 8080
      opts[:content_type] ||= opts.delete(:content_type) || 'text/html'
      opts[:DocumentRoot] ||= opts.delete(:document_root) || File.expand_path('./')
      @_[:server] = WEBrick::HTTPServer.new(opts)
      @_[:server].mount_proc '' do |rq, rs| #request, response
        begin
          rs.status, rs.content_type, method = nil, opts[:content_type], rq.request_method.tr('-', '_').upcase
          route, handler = @_[:routes].find{|k,v| k[:methods].include?(method) && k[:matcher].match(rq.path_info)}
          params = Hash[ CGI::parse(rq.query_string||'').map{|k,v| [k.to_sym,v[0]]} + #url params
                         rq.query.map{|k,v| [k.to_sym, v]} + #query params
                         ($~ ? $~.names.map(&:to_sym).zip($~.captures) : []) ] #dynamic route params. $~ is the info of the last match (see line 17)
          body = handler[:block].call(params, rq, rs)
          rs.status, rs.body = route ? [rs.status || 200, body] : [404, 'not found']
        rescue => e
          @_[:server].logger.error "#{e.message}\n#{e.backtrace.map{|line| "\t#{line}"}.join("\n")}"
          rs.status, rs.body = 500, "#{e}"
        end
      end
    end

    def route(path, methods = ['GET', 'POST'], opts={}, &block)
      path = "/#{path}" unless path[0] == '/'
      methods = Array(methods).map{|e| e.to_s.tr('-', '_').upcase}
      matcher = Regexp.new("\\A#{path.gsub(/(:\w+)/){|m| "(?<#{$1[1..-1]}>\\w+)"}}\\Z")
      block ||= proc{|pa,rq,rs| @params,@request,@response = pa,rq,rs; render path}
      @_[:routes][{:methods => methods, :path => path, :matcher => matcher}] = {:opts => opts, :block => block}
    end

    def render(name, opts={})
      @_[:templates] ||= (Hash[DATA.read.split(/^@@\s*(.*\S)\s*$/)[1..-1].map(&:strip).each_slice(2).to_a] rescue {})
      [@_[:templates][name.to_s] || File.read(name.to_s), #template to render
       @_[:templates][(opts.has_key?(:layout) ? opts[:layout] : 'layout').to_s] #layout to use, if any
      ].compact.reduce(nil){|prev, temp| _render(temp){prev}}
    end

    def _render(content)
      ERB.new(content).result(binding)
    end

    def start
      trap('INT'){@_[:server].stop}
      @_[:server].start ensure @_[:server].shutdown
    end
  end
end
