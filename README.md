# Busker

An extremely simple web framework. It's called Busker as a reference to
Sinatra. It mimics Sinatra in some aspects while still trying to stay a
true wanderer of the streets.

## Installation

Add this line to your application's Gemfile:

    gem 'busker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install busker

## Usage

    require 'busker'

    Busker::Busker.new do
      # minimal route definition
      route '/' do
        "Busker version: #{Busker::VERSION}"
      end

      # respond to multiple HTTP methods, overwrite response content_type
      route '/info', [:GET, :POST, :PUT, :DELETE] do |params, request, response|
        response.content_type = 'text/plain'
        request.inspect
      end

      # usage of URL params, render template with variable
      route '/template', :GET do |params|
        @title = params[:title] || 'no title'
        if params[:external]
          render './template.erb'
        else
          render :template
        end
      end

      # usage of dynamic route params
      route '/item/:id' do |params|
        "requested item with id: #{params[:id]}"
      end

      # list all defined routes
      route '/routes' do |params, request, response|
        response.content_type = 'text/plain'
        @_[:routes].keys.map{|e| e.join("\n")}.join("\n\n")
      end
    end.start

    __END__
    @@ template
    <h1><%= @title %></h1>

## Design principles

* Small code base that is easy to understandable and hackable
* Such a tiny code base that you can just copy it into your one-file-project without the need to require a Gem
* No dependencies except what is in the Ruby Standard Lib
* Backward compatibility to older Ruby versions
* Some minor resemblance to Sinatra
* Ease of use
* It's not meant as a complete web framework like Rails but concentrates on the basics

## TODO / Ideas

* Improve render method, allow yield etc
* Improve error handling, honor production/development environment?
* Auto reload?
* Anything cool that doesn't break the design principles ...

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

Or just use GitHubs on page editing ...
it will do all of the above for you and is reasonable given the size of the source.
Make sure to add an explanation though!
