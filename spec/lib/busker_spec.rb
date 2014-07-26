require 'spec_helper'
require 'busker'

describe Busker do
  it 'has a version' do
    expect(Busker::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end

describe Busker::Busker do
  it 'can define a route via the initialize block' do
    busker = Busker::Busker.new do
      route '/path', :POST do
        'trallala'
      end
    end
    routes = busker.instance_variable_get('@_')[:routes]
    expect(routes).to be_a Hash
    expect(routes.size).to eql 1
    key, value = routes.first
    expect(key).to be_a Hash
    expect(key[:methods]).to eql ['POST']
    expect(key[:path]).to eql '/path'
    expect(key[:matcher]).to be_a Regexp
    expect(value).to be_a Hash
    expect(value[:opts]).to be_a Hash
    expect(value[:block]).to be_a Proc
  end

  # TODO: way more tests, including integration tests with capybara
end
