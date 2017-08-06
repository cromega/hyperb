require 'helper'
require 'http'

RSpec.describe Hyperb::Containers do

  before do
    @client = Hyperb::Client.new(access_key: 'key', secret_key: '123')

    @containers_base_path = Hyperb::Request::BASE_URL + Hyperb::Request::VERSION + '/containers/'
    @containers_path =  @containers_base_path + 'json'
    @remove_container_path = @containers_base_path
    @create_container_path = @containers_base_path + 'create'
  end

  describe '#containers' do

    it 'request to the correct path should be made' do

      stub_request(:get, @containers_path)
      .to_return(body: fixture('containers.json'))

      @client.containers
      expect(a_request(:get, @containers_path)).to have_been_made
    end

    it 'request to the correct path should be made with all=true' do
      stub_request(:get, @containers_path + '?all=true')
      .to_return(body: fixture('containers.json'))

      @client.containers(all: true)
      expect(a_request(:get, @containers_path + '?all=true')).to have_been_made
    end

    it 'request to the correct path should be made with limit=5' do
      stub_request(:get, @containers_path + '?limit=5')
      .to_return(body: fixture('containers.json'))

      @client.containers(limit: 5)
      expect(a_request(:get, @containers_path + '?limit=5')).to have_been_made
    end

    it 'request to the correct path should be made with since=someId' do
      stub_request(:get, @containers_path + '?since=3afff57')
      .to_return(body: fixture('containers.json'))

      @client.containers(since: '3afff57')
      expect(a_request(:get, @containers_path + '?since=3afff57')).to have_been_made
    end

    it 'request to the correct path should be made with before=someId' do
      stub_request(:get, @containers_path + '?before=3afff57')
      .to_return(body: fixture('containers.json'))

      @client.containers(before: '3afff57')
      expect(a_request(:get, @containers_path + '?before=3afff57')).to have_been_made
    end

    it 'request to the correct path should be made with all=true and since=someId' do
      stub_request(:get, @containers_path + '?all=true&since=3afff57')
      .to_return(body: fixture('containers.json'))

      @client.containers(all: true, since: '3afff57')
      expect(a_request(:get, @containers_path + '?all=true&since=3afff57')).to have_been_made
    end

    it 'request to the correct path should be made with size=true' do
      stub_request(:get, @containers_path + '?size=true')
      .to_return(body: fixture('containers.json'))

      @client.containers(size: true)
      expect(a_request(:get, @containers_path + '?size=true')).to have_been_made
    end

    it 'return array of containers' do
      stub_request(:get, @containers_path + '?all=true')
      .to_return(body: fixture('containers.json'))

      containers = @client.containers(all: true)
      expect(containers).to be_a Array
      expect(containers[0]).to be_a Hyperb::Container
    end

    it 'correct attrs' do
      stub_request(:get, @containers_path)
      .to_return(body: fixture('containers.json'))

      @client.containers.each do |container|
        expect(container.id).to be_a String
        expect(container.created).to be_a Fixnum
        expect(container.command).to be_a String
        expect(container.networksettings).to be_a Hash
        expect(container.hostconfig).to be_a Hash
      end
    end
  end

  describe '#inspect_container' do

    before do
      stub_request(:get, @containers_base_path + 'name/json')
      .to_return(body: fixture('inspect_container.json'))
    end

    it 'should raise ArgumentError when id is missing' do
      expect { @client.inspect_container }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made' do
      @client.inspect_container id: 'name'
      expect(a_request(:get, @containers_base_path + 'name/json')).to have_been_made
    end

    it 'return a hash with symbolized attrs' do
      res = @client.inspect_container(id: 'name')
      expect(res).to be_a Hash
      expect(res.has_key?(:args)).to be true
      expect(res.has_key?(:config)).to be true
      expect(res.has_key?(:created)).to be true
    end

  end

  describe '#remove_container' do

    it 'should raise ArgumentError when id is not provided' do
      stub_request(:delete, @remove_container_path)
      .to_return(body: fixture('remove_container.json'))

      expect { @client.remove_container }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made with id=fffff' do
      stub_request(:delete, @remove_container_path + 'fffff')
      .to_return(body: fixture('remove_container.json'))

      @client.remove_container(id: 'fffff')
      expect(a_request(:delete, @remove_container_path + 'fffff')).to have_been_made
    end

    it 'request to the correct path should be made with force=true' do
      stub_request(:delete, @remove_container_path + 'fffff?force=true')
      .to_return(body: fixture('remove_container.json'))

      @client.remove_container(id: 'fffff', force: true)
      expect(a_request(:delete, @remove_container_path + 'fffff?force=true')).to have_been_made
    end

    it 'request to the correct path should be made with v=true' do
      stub_request(:delete, @remove_container_path + 'fffff?v=true')
      .to_return(body: fixture('remove_container.json'))

      @client.remove_container(id: 'fffff', v: true)
      expect(a_request(:delete, @remove_container_path + 'fffff?v=true')).to have_been_made
    end

    it 'request to the correct path should be made with v=true and force=true' do
      stub_request(:delete, @remove_container_path + 'fffff?force=true&v=true')
      .to_return(body: fixture('remove_container.json'))

      @client.remove_container(id: 'fffff', v: true, force: true)
      expect(a_request(:delete, @remove_container_path + 'fffff?force=true&v=true')).to have_been_made
    end
  end

  describe '#create_container' do

    it 'should raise ArgumentError when image is not provided' do
      stub_request(:post, @create_container_path)
      .to_return(body: fixture('create_container.json'))

      expect { @client.create_container }.to raise_error(ArgumentError)
    end

    it 'request to the correct path should be made with name=container_name' do
      stub_request(:post, @create_container_path + '?name=container_name')
      .with(body: { image: 'image' })
      .to_return(body: fixture('create_container.json'))

      @client.create_container(image: 'image', name: 'container_name')
      expect(a_request(:post, @create_container_path + '?name=container_name')).to have_been_made
    end

    it 'correct request should be made with hostname' do
      path = @create_container_path + '?name=container_name'

      stub_request(:post, path)
      .with(body: { image: 'image', hostname: 'hostnamy' })
      .to_return(body: fixture('create_container.json'))

      @client.create_container(image: 'image', name: 'container_name', hostname: 'hostnamy')
      expect(a_request(:post, path).with(body: { image: 'image', hostname: 'hostnamy' })).to have_been_made
    end
  end

end
