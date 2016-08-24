require 'spec_helper'

describe Reflex do
  let(:client) { Reflex::API.new }

  it 'should have a version number' do
    expect(Reflex::VERSION).not_to be nil
  end

  it 'should test !' do
    ['getOR', 'getOP'].each do |name|
      stub_request(:get, "https://reflex.stif.info/ws/reflex/V1/service=getData/?format=xml&idRefa=0&method=#{name}").
      to_return(body: File.open("#{fixture_path}/#{name.downcase}.zip"), status: 200)
    end

    start = Time.now
    # get_op = client.process 'getOP'
    get_or = client.process 'getOR'

    # ap get_op[:stop_places].count
    # puts "GET_OP STOP PLACES COUNT : #{get_op[:stop_places].count}"
    ap '------------'
    puts "GET_OR STOP PLACES COUNT : #{get_or[:stop_places].count}"
    # ap '------------'
    # get_op[:stop_places] << get_or[:stop_places]
    # get_op[:stop_places].flatten!

    # ids      = {}
    # doublons = {}

    # get_op[:stop_places].each do |item|
    #   doublons[item.stif_id] = item if ids[item.stif_id]
    #   ids[item.stif_id] = item
    # end

    # puts "TOTAL : #{ids.count}"
    # puts "Doublons : #{doublons.count}"
    puts "Processed in #{Time.now - start} seconds"
  end

  # it 'should have a default timeout value' do
  #   expect(client.timeout).to equal(30)
  # end

  # it 'should set timeout from initializer' do
  #   expect(Reflex::API.new(timeout: 60).timeout).to equal(60)
  # end

  # it 'should raise exception on Api call timeout' do
  #   stub_request(:get, api_index_url).to_timeout
  #   expect { client.operators }.to raise_error(Reflex::ReflexError)
  # end

  # it 'should raise exception on Reflex API response 404' do
  #   stub_request(:get, api_index_url).to_return(status: 404)
  #   expect { client.operators }.to raise_error(Reflex::ReflexError)
  # end

  # it 'should return operators on valid operator request' do
  #   xml = File.new(fixture_path + '/index.xml')
  #   stub_request(:get, api_index_url).to_return(body: xml)
  #   operators = client.operators()

  #   expect(operators.count).to equal(82)
  #   expect(operators.first).to be_a(Reflex::Operator)
  # end

  # it 'should raise exception on unparseable response' do
  #   xml = File.new(fixture_path + '/invalid_index.xml')
  #   stub_request(:get, api_index_url).to_return(body: xml)
  #   expect { client.operators }.to raise_error(Reflex::ReflexError)
  # end

  # it 'should return operators by transport_mode' do
  #   url = client.build_url(transport_mode: 'fer')
  #   xml = File.new(fixture_path + '/index_transport_mode.xml')
  #   stub_request(:get, url).to_return(body: xml)
  #   operators = client.operators(transport_mode: 'fer')

  #   expect(operators.count).to equal(3)
  #   expect(operators.first).to be_a(Reflex::Operator)
  # end

  # it 'should return operators on valid line request' do
  #   url = client.build_url(operator_name: 'RATP')
  #   xml = File.new(fixture_path + '/line.xml')
  #   stub_request(:get, url).to_return(body: xml)

  #   lines = client.lines(operator_name: 'RATP')
  #   expect(lines.count).to equal(382)
  #   expect(lines.first).to be_a(Reflex::Line)
  # end

  # it 'should retrieve lines with Operator lines method' do
  #   url = client.build_url(operator_name: 'RATP')
  #   xml = File.new(fixture_path + '/line.xml')
  #   stub_request(:get, url).to_return(body: xml)

  #   expect(operator.lines.count).to equal(382)
  # end

end
