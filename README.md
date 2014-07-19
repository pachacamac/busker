# Busker :walking::notes:

An extremely simple web framework. It's called Busker as a reference to
Sinatra. It mimics Sinatra in some aspects while still trying to stay a
true wanderer of the streets.

## Design principles

* Small code base that is easily understandable, hackable and embeddable
* No dependencies except what is in the Ruby Standard Lib
* Backward compatibility to older Ruby versions
* Ease of use / Some minor resemblance to Sinatra, hence the name
* It's not meant as a complete web framework but concentrates on the basics

## Installation

Add this line to your application's Gemfile:

    gem 'busker'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install busker

## Usage

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

  # usage of dynamic route params
  route '/item/:id' do |params|
    "requested item with id: #{params[:id]}"
  end

  # list all defined routes
  route '/routes' do |params, request, response|
    response.content_type = 'text/plain'
    @_[:routes].keys.map{|e| e.join("\n")}.join("\n\n")
  end

  # implicit route definitions
  route :implicit
  route '/implicit/something'

end.start # notice the call to start

# inline templates like in Sinatra
__END__
@@ template
<h1><%= @title %></h1>

@@ /implicit
<h1><%= @params.inspect %></h1>

@@ /implicit/something
<h1><%= @request.inspect %></h1>

```

## Questions

### Why not use Sinatra?

Sinatra is about 2000 lines of code (nothing you would directly, as in copy the code, embed in your single-file project) while Busker is less than 50 lines of code. Plus Sinatra depends on Rack and Tilt. Both external Gems while one of Buskers design principles is to only rely on modules that are within the Ruby Standard Library.

This makes it literally small and deployable enough to be used in a tiny single file project. This is great for toy projects, educational purposes, payloads, embedded projects ...

But that all being said, you should probably use Rails or Sinatra for your project.

### When shouldn't I use Busker?

I wouldn't consider Busker to be "production ready" by any means. It's something to play around and have fun with. I haven't made exhaustive benchmarks or in depths security checks. And I would love to get honest, constructive opinions (considering the design principles). 

## TODO / Ideas

* Improve render method, allow yield etc
* Improve error handling, honor production/development environment?
* Tests? :ok_hand:
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
