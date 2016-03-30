# Busker :walking::notes:

An extremely simple web framework. It's called Busker as a reference to
Sinatra. It mimics Sinatra in some aspects while still trying to stay a
true wanderer of the streets.

Featured in the German [Linux Magazin](http://www.linux-magazin.de/Ausgaben/2014/10/Einfuehrung3) for some reason O.o

[![Gem Version](https://badge.fury.io/rb/busker.svg)](http://badge.fury.io/rb/busker) ![Installs](http://img.shields.io/gem/dt/busker.svg) [![security](https://hakiri.io/github/pachacamac/busker/master.svg)](https://hakiri.io/github/pachacamac/busker/master)

## Design principles :page_with_curl:

* Small code base that is easily understandable, hackable and embeddable
* No dependencies except what is in the Ruby Standard Lib
* Backward compatibility to older Ruby versions
* Ease of use / Some minor resemblance to Sinatra, hence the name
* It's not meant as a complete web framework but concentrates on the basics

## Installation :floppy_disk:

Add this line to your application's Gemfile:

    gem 'busker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install busker

Or copy the code into your project ... it's tiny!

## Usage :boom:

```ruby
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
  
  # render another layout than the default
  route '/alt_layout', :GET do |params|
    render :template, :layout => :another_layout
  end
  
  # usage of dynamic route params
  route '/item/:id' do |params|
    "requested item with id: #{params[:id]}"
  end

  # list all defined routes
  route '/routes', :GET do |params, request, response|
    response.content_type = 'text/plain'
    @_[:routes].keys.map{|k| "#{k[:methods].join('/')} #{k[:path]}"}.join("\n")
  end

  # implicit route definitions
  route :implicit
  route '/implicit/something'

end.start # notice the call to start

# inline templates like in Sinatra
__END__
@@ layout
<header>Header</header>
<%= yield %>
<footer>Footer</footer>

@@ another_layout
<div class="batman"><%= yield %></div>

@@ template
<h1><%= @title %></h1>

@@ /implicit
<h1><%= @params.inspect %></h1>

@@ /implicit/something
<h1><%= @request.inspect %></h1>

```

## Questions :grey_question:

### Why not use Sinatra?

Sinatra is about 2000 lines of code (nothing you would directly, as in copy the code, embed in your single-file project) while Busker is less than 50 lines of code. Plus Sinatra depends on Rack and Tilt. Both external Gems while one of Buskers design principles is to only rely on modules that are within the Ruby Standard Library.

This makes it literally small and deployable enough to be used in a tiny single file project. This is great for toy projects, educational purposes, payloads, embedded projects ...

But that all being said, you should probably use Rails or Sinatra for your project.

### When shouldn't I use Busker?

**I wouldn't consider Busker to be "production ready" by any means. (WEBrick is not the smartest choice for production environments! [Read here why](http://www.madebymarket.com/blog/dev/ruby-web-benchmark-report.html))** It's something to play around and have fun with. I haven't made exhaustive benchmarks or in depths security checks. And I would love to get honest, constructive opinions (considering the design principles).

## TODO / Ideas :bulb:

* More tests! (especially integration tests with Capybara)
* Improve render method, allow yield etc
* Improve error handling, honor production/development environment?
* Auto reload?
* A fork that doesn't need WEBrick?
* Anything cool that doesn't break the design principles ...

## Contributing :construction:

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Don't forget to write- and run tests for your new feature (run rspec)!
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

Or just use GitHubs on page editing ...
it will do all of the above for you and is reasonable given the size of the source.
Make sure to add an explanation though!
