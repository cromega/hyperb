require 'hyperb/request'
require 'hyperb/utils'
require 'hyperb/volumes/volume'
require 'json'
require 'uri'
require 'base64'

module Hyperb
  # volumes module
  module Volumes
    include Hyperb::Utils

    # list volumes
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/list.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hyperb::Volume] Array of Hyperb::Volume.
    #
    # @param params [Hash] A customizable set of params.
    # TODO: @option params [String] :filters JSON encoded value of the filters
    # TODO: @option params filters [Boolean] :dangling
    def volumes(params = {})
      path = '/volumes'
      response = JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform)

      # hyper response atm comes inside a Volumes: [], unlike the images API
      # which is returned in a []
      response['Volumes'].map { |vol| Hyperb::Volume.new(vol) }
    end

    # remove volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/remove.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id volume id or name
    # @option params [String] :all default is true
    # @option params [String] :filter only return image with the specified name
    def remove_volume(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/volumes/' + params[:id]
      Hyperb::Request.new(self, path, {}, 'delete').perform
    end

    # inspect a volume
    #
    # @see https://docs.hyper.sh/Reference/API/2016-04-04%20[Ver.%201.23]/Volume/inspect.html
    #
    # @raise [Hyperb::Error::Unauthorized] raised when credentials are not valid.
    #
    # @return [Hash] array of downcase symbolized json response.
    #
    # @param params [Hash] A customizable set of params.
    # @option params [String] :id volume id or name
    def inspect_volume(params = {})
      raise ArgumentError, 'Invalid arguments.' unless check_arguments(params, 'id')
      path = '/volumes/' + params[:id]
      downcase_symbolize(JSON.parse(Hyperb::Request.new(self, path, {}, 'get').perform))
    end
  end
end