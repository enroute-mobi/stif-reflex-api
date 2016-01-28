require 'rails_helper'

describe Codifligne do
  let(:client) { Codifligne::API.new }
  let(:api_index_url) { "#{client.base_url}/0/0/0/0/0/0/0/xml"}

  it 'should have a version number' do
    expect(Codifligne::VERSION).not_to be nil
  end

  it 'should have a default timeout value' do
    expect(client.timeout).to equal(30)
  end

  it 'should set timeout from initializer' do
    expect(Codifligne::API.new(timeout: 60).timeout).to equal(60)
  end

  it 'should raise exception on Codifligne API response 404' do
    stub_request(:get, api_index_url).to_return(status: 404)
    expect { client.operators }.to raise_error(Codifligne::CodifligneError)
  end

  it 'should return operators on valid operator request' do
    xml = File.new(fixture_path + '/index.xml')
    stub_request(:get, api_index_url).to_return(body: xml)
    expect(client.operators.count).to equal(82)
  end

  it 'should raise exception on unparseable response' do
    xml = File.new(fixture_path + '/invalid_index.xml')
    stub_request(:get, api_index_url).to_return(body: xml)
    expect { client.operators }.to raise_error(Codifligne::CodifligneError)
  end

  it 'should return operators on valid line request' do
    url = "#{client.base_url}/0/0/0/ADP/0/0/0/xml"
    xml = File.new(fixture_path + '/line.xml')
    stub_request(:get, url).to_return(body: xml)
    expect(client.lines(operator_name: 'ADP').count).to equal(3)
  end

  it 'should raise exception on Api call timeout' do
    stub_request(:get, api_index_url).to_timeout
    expect { client.operators }.to raise_error(Codifligne::CodifligneError)
  end
end
