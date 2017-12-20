# coding: utf-8
require 'spec_helper'

describe Reflex do
  let(:client)  { Reflex::API.new }
  let(:api_url) { "https://195.46.215.128/ws/reflex/V1/service=getData/?format=xml&idRefa=0" }

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
    stub_request(:get, "#{api_url}&method=getOR").to_timeout
    expect { client.api_request(method: 'getOR') }.to raise_error(Reflex::ReflexError)
  end

  it 'should raise exception on Reflex API response 404' do
    stub_request(:get, "#{api_url}&method=getOR").to_return(status: 404)
    expect { client.api_request(method: 'getOR') }.to raise_error(Reflex::ReflexError)
  end

  context 'process file' do
    let(:process_results) { client.process 'getOR' }
    before(:each) do
      ['getOR', 'getOP'].each do |name|
        stub_request(:get, "#{api_url}&method=#{name}").
        to_return(body: File.open("#{fixture_path}/reflex.zip"), status: 200)
      end
    end

    it 'request should be successfull' do
      response = client.api_request(method: 'getOR')
      expect(response).to be_a Tempfile
    end

    it 'should return results on valid request' do
      expect(process_results[:Quay].count).to eq 2
      expect(process_results[:StopPlace].count).to eq 4
    end

    it 'should retrieve town and postal address' do
      expect(process_results[:Quay].first['Town']).to eq('Abloné-sur-Seine')
      expect(process_results[:StopPlace].first['Town']).to eq('Dammartin-en-Goële')
    end

    it 'should retrieve long lat of quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['gml:pos'][:lng]).to eq(2.4188263089316813)
        expect(quay['gml:pos'][:lat]).to eq(48.7276875270213)
      end
    end

    it 'should handle non zip files' do
      stub_request(:get, "#{api_url}&method=getOR").
      to_return(body: File.open("#{fixture_path}/reflex.xml"), status: 200)

      expect(process_results[:Quay].count).to eq 2
      expect(process_results[:StopPlace].count).to eq 4
    end
  end

  context 'lamber wilson' do
    let(:client)  { Reflex::LamberWilson.new }

    it 'should convert lamber93 point to wgs84 point' do
      cord  = [650045.098, 6857815.614]
      point = client.to_longlat(cord)
      expect(point[:lng]).to be_within(0.000001).of(2.3196613994745)
      expect(point[:lat]).to be_within(0.000001).of(48.81846921123396)
    end

    it 'should accept string cord as parameters' do
      cord  = '650045.098 6857815.614'
      point = client.to_longlat(cord)
      expect(point[:lng]).to be_within(0.000001).of(2.3196613994745)
      expect(point[:lat]).to be_within(0.000001).of(48.81846921123396)
    end
  end
end
