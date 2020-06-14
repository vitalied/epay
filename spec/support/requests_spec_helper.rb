module RequestsSpecHelper
  def json_headers
    {
      Accept: 'application/json',
      'Content-Type': 'application/json'
    }
  end

  def token_headers
    json_headers.merge(Authorization: "Token #{try(:token)}")
  end

  def body
    JSON.parse(response.body, symbolize_names: true) rescue {}
  end

  def body_error
    body[:error]
  end
end

RSpec.configure do |config|
  config.include RequestsSpecHelper
end
