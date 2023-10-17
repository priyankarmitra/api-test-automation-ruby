require "httparty"

class HttpRequest
  attr_accessor :url

  def initialize(host)
    @host = host
  end

  def get(path, query='')
    if path.empty?
      raise 'path is empty'
    end

    url = @host + path + query
    response = HTTParty.get(url, :headers => {"Content-Type" => "application/json"})
  end

  def post(path, pay_load, query='')
    if path.empty? and pay_load.emtpy?
      raise 'path / payload is empty'
    end
    
    url = @host + path + query
    response = HTTParty.post(url, :body => pay_load, :headers => {"Content-Type" => "application/json"})
  end
end

# Module for managing service requests
module ServiceRequest
  extend self

  def setup_request(host)
    @request = HttpRequest.new(host)
  end

  def clear_request
    @request = nil
  end

  def get_request(path, query='')
    @request.get(path, query)
  end

  def post_request(path, pay_load, query='')
    @request.post(path, pay_load, query)
  end
end
