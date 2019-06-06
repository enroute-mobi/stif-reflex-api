# coding: utf-8
require 'spec_helper'

describe Reflex do
  let(:client)  { Reflex::API.new }
  let(:api_url) { "https://pprod.reflex.stif.info/ws/rest/V2/getData?method=getAll" }

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
    expect { client.api_request(method: 'getAll') }.to raise_error(Reflex::ReflexError)
  end

  it 'should raise exception on Reflex API response 404' do
    stub_request(:get, api_url).to_return(status: 404)
    expect { client.api_request(method: 'getAll') }.to raise_error(Reflex::ReflexError)
  end

  context 'process file' do
    let(:process_results) { client.process 'getAll' }
    before(:each) do
      stub_request(:get, api_url).
      to_return(body: File.open("#{fixture_path}/reflex.zip"), status: 200)
    end

    it 'request should be successfull' do
      response = client.api_request(method: 'getAll')
      expect(response).to be_a Tempfile
    end

    it 'should return results on valid request' do
      expect(process_results[:Quay].count).to eq 2
      expect(process_results[:StopPlace].count).to eq 2
      expect(process_results[:OrganisationalUnit].count).to eq 1
    end

    it 'should retrieve type_of_organisation of organisational unit' do
      expect(process_results[:OrganisationalUnit].first['type_of_organisation']).to eq('FR1-ARRET_Organisation')
    end

    it 'should retrieve long lat of quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['gml:pos'][:lng]).to be_within(0.000001).of(2.5187845)
        expect(quay['gml:pos'][:lat]).to be_within(0.000001).of(48.9132038)
      end
    end

    it 'should retrieve town and postal address' do
      expect(process_results[:Quay].first['Town']).to eq('Livry-Gargan')
      expect(process_results[:StopPlace].first['Town']).to eq('Livry-Gargan')
    end

    it 'should retrieve long lat of quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['gml:pos'][:lng]).to be_within(0.000001).of(2.5187845)
        expect(quay['gml:pos'][:lat]).to be_within(0.000001).of(48.9132038)
      end
    end

    it 'should retrieve the destinations of quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['destinations'].size).to eq 1
        expect(quay['destinations'].first['Name']).to eq '234'
      end
    end

    it 'should retrieve the tariff zones of quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['tariff_zones'].size).to eq 1
        expect(quay['tariff_zones'].first).to eq 'FR1:TariffZone:4:LOC'
      end
    end

    it 'should retrieve the derived from reference of the quay' do
      process_results[:Quay].first.tap do |quay|
        expect(quay['derivedFromObjectRef']).to eq "FR::Quay:29924:FR1"
      end
    end

    it 'should handle non zip files' do
      stub_request(:get, api_url).
      to_return(body: File.open("#{fixture_path}/reflex.xml"), status: 200)

      expect(process_results[:Quay].count).to eq 2
      expect(process_results[:StopPlace].count).to eq 2
    end
  end

  context 'lamber wilson' do
    let(:client)  { Reflex::LamberWilson.new }

    it 'should convert lamber93 point to wgs84 point' do
      cord  = [650045.098, 6857815.614]
      point = client.to_longlat(cord)
      expect(point[:lng]).to be_within(0.000001).of(2.319661)
      expect(point[:lat]).to be_within(0.000001).of(48.818469)
    end

    it 'should accept string cord as parameters' do
      cord  = '650045.098 6857815.614'
      point = client.to_longlat(cord)
      expect(point[:lng]).to be_within(0.000001).of(2.319661)
      expect(point[:lat]).to be_within(0.000001).of(48.818469)
    end
  end
end
