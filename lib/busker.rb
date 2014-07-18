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
      opts[:DocumentRoot] ||= opts.delete(:document_root) || File.expand_path('./')
      @_[:server] = WEBrick::HTTPServer.new(opts)
      @_[:server].mount_proc '' do |rq, rs| #request, response
        begin
          rs.status, rs.content_type, method = nil, 'text/html', rq.request_method.tr('-', '_').upcase
          route, handler = @_[:routes].find{|k,v| k.first.include?(method) && k.last.match(rq.path_info)}
          params = Hash[ CGI::parse(rq.query_string||'').map{|k,v| [k.to_sym,v[0]]} + #url params
                         rq.query.map{|k,v| [k.to_sym, v]} + #query params
                         ($~ ? $~.names.map(&:to_sym).zip($~.captures) : []) ] #dynamic route params. $~ is the info of the last match (see line 17)
          rs.status, rs.body = route ? [rs.status || 200, handler[:block].call(params, rq, rs)] : [404, 'not found']
        rescue => e
          @_[:server].logger.error "#{e.message}\n#{e.backtrace.map{|line| "\t#{line}"}.join("\n")}"
          rs.status, rs.body = 500, "#{e}"
        end
      end
    end

    def route(path, methods = ['GET'], opts={}, &block)
      methods = (methods.is_a?(Array) ? methods : [methods]).map{|e| e.to_s.tr('-', '_').upcase}
      matcher = Regexp.new("\\A#{path.gsub(/(:\w+)/){|m| "(?<#{$1[1..-1]}>\\w+)"}}\\Z")
      @_[:routes][[methods, path, matcher]] = {:opts => opts, :block => block}
    end

    def render(name)
      @_[:templates] ||= (Hash[DATA.read.split(/^@@\s*(.*\S)\s*$/)[1..-1].map(&:strip).each_slice(2).to_a] rescue {})
      ERB.new(@_[:templates][name.to_s] || File.read(name)).result(binding)
    end

    def start
      @_[:server].start ensure @_[:server].shutdown
    end
  end
end
