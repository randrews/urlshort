class LinkController < ApplicationController
  before_action :find_link, only: [:edit, :update, :delete]

  def create
    link = Link.find_or_create_by(url: params[:link][:url])
    if link.valid?
      flash[:message] = "Link created! #{visit_url(link.code)} (Edit it here: #{edit_url(link.code)} )"
    else
      flash[:error] = "Error: #{link.errors.full_messages.to_sentence}"
    end
    redirect_to root_path
  end

  def update
    @link.update_attribute(:url, params[:link][:url])
    flash[:message] = 'Link updated'
    redirect_to root_path
  end

  def delete
    @link.destroy
    flash[:message] = 'Link deleted'
    redirect_to root_path
  end
end
