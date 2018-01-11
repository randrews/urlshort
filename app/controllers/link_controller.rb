class LinkController < ApplicationController
  before_action :find_link, only: [:api_delete, :api_update]

  def api_create
    url = get_url
    # Finally we have a URL! Let's make a link
    # (or return one that already exists)
    link = Link.find_or_create_by!(url: url)
    render json: { hash: link.code }
  rescue => err
    render json: { error: err }, status: 422
  end

  def api_delete
    @link.destroy
    render json: { message: 'Link deleted' }
  end

  # So for the record, I'd never want to actually implement
  # this, because: make a link, submit it to Reddit, wait
  # for it to hit frontpage, then change the target to this:
  # http://bit.ly/IqT6zt
  # But, here it is:
  def api_update
    url = get_url
    @link.update_attribute(:url, url)
    render json: { message: 'Link updated' }
  rescue => err
    render json: { error: err }, status: 422
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

  def create
    link = Link.find_or_create_by(url: params[:link][:url])
    if link.valid?
      flash[:message] = "Link created! #{visit_url(link.code)}"
    else
      flash[:error] = "Error: #{link.errors.full_messages.to_sentence}"
    end
    redirect_to root_path
  end

  private

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
