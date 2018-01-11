class ApplicationController < ActionController::Base
  def find_link
    @link = Link.find_by(code: params[:code])
    render json: { error: 'Link not found' }, status: 404 unless @link
    @link
  end

  def get_url
    # This lets actions run in two modes:
    # - API sent a JSON payload as the body
    # - API sent a form payload as the body
    # I wasn't sure if the intent was for the payload
    # to be a JSON string or a form, so I just made
    # it handle both.

    url = params[:url]

    if url.blank?
      begin
        json = request.body.read # Grab and parse the body
        hash = JSON.parse(json)
        url = hash.try(:[], 'url') # Hope it's a hash with that field
        raise 'No URL given' unless url
      rescue JSON::ParserError
        raise 'Unable to parse JSON'
      end
    end

    url
  end
end
