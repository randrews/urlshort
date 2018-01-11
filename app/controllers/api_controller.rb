class ApiController < ApplicationController
  before_action :find_link, only: [:delete, :update]

  def create
    url = get_url
    # Finally we have a URL! Let's make a link
    # (or return one that already exists)
    link = Link.find_or_create_by!(url: url)
    render json: { hash: link.code }
  rescue => err
    render json: { error: err }, status: 422
  end

  def delete
    @link.destroy
    render json: { message: 'Link deleted' }
  end

  # So for the record, I'd never want to actually implement
  # this, because: make a link, submit it to Reddit, wait
  # for it to hit frontpage, then change the target to this:
  # http://bit.ly/IqT6zt
  # But, here it is:
  def update
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
end
