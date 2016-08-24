require 'spec_helper'

describe Reflex do
  let(:client)  { Reflex::API.new }
  let(:api_url) { "https://reflex.stif.info/ws/reflex/V1/service=getData/?format=xml&idRefa=0&method=getOR" }

  it 'should have a version number' do
    expect(Reflex::VERSION).not_to be nil
  end

 it 'should have a default timeout value' do
    expect(client.timeout).to equal(30)
  end

  it 'should set timeout from initializer' do
    expect(Reflex::API.new(timeout: 60).timeout).to equal(60)
  end

  it 'should raise exception on Api call timeout' do
    stub_request(:get, api_url).to_timeout
    expect { client.api_request(method: 'getOR') }.to raise_error(Reflex::ReflexError)
  end

  it 'should raise exception on Reflex API response 404' do
    stub_request(:get, api_url).to_return(status: 404)
    expect { client.api_request(method: 'getOR') }.to raise_error(Reflex::ReflexError)
  end

  context 'process file' do
    let(:process_results) { client.process 'getOR' }
    before(:each) do
      ['getOR', 'getOP'].each do |name|
        stub_request(:get, "https://reflex.stif.info/ws/reflex/V1/service=getData/?format=xml&idRefa=0&method=#{name}").
        to_return(body: File.open("#{fixture_path}/#{name.downcase}.zip"), status: 200)
      end
    end

    it 'request should be successfull' do
      file = client.api_request(method: 'getOR')
      expect(file).to be_a Tempfile
    end

    it 'should return results on valid request' do
      expect(process_results[:quay].count).to eq 6788
      expect(process_results[:stop_place_entrances].count).to eq 60
      expect(process_results[:stop_places].count).to eq 1144
    end
  end
end
