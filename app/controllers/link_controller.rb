class LinkController < ApplicationController
  def api_create
    # This action should run in two modes:
    # - API sent a JSON payload as the body
    # - API sent a form payload as the body
    # I wasn't sure if the intent was for the payload to be a JSON string or a
    # form, so I just made it handle both.

    url = params[:url]

    if url.blank?
      begin
        json = request.body.read # Grab and parse the body
        hash = JSON.parse(json)
        url = hash.try(:[], 'url') # Hope it's a hash with a 'url' field
        render json: { error: 'No URL given' } unless url
      rescue JSON::ParserError
        render json: { error: 'Unable to parse JSON' }
      end
    end

    # Finally we have a URL! Let's make a link
    # (or return one that already exists)
    link = Link.find_by(url: url) || Link.create!(url: url)
    render json: { hash: link.code }
  end

  def visit
    link = Link.find_by(code: params[:code])

    if link
      # There's an issue here in that if the URL isn't a
      # real URL you'll get redirected to it anyway.
      # Unfortunately validating URLs is hard: URI.parse
      # will call basically anything a valid URI, it
      # just won't populate any of the components (host,
      # scheme, etc). So for now this works.
      redirect_to link.url
    else
      flash[:error] = 'Could not find that link'
      redirect_to root_path
    end
  end
end
