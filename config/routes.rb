Rails.application.routes.draw do
  root 'link#form'

  post '/v1/links' => 'api#create'
  post '/v1/links/:code/delete' => 'api#delete'
  post '/v1/links/:code/update' => 'api#update'
  get '/v1/:code' => 'api#visit', as: :visit

  # This could obviously be a resource but I figured I'd
  # write it out by hand.
  post '/links' => 'link#create', as: :create
  get '/links/:code' => 'link#edit', as: :edit
  patch '/links/:code' => 'link#update', as: :update
  delete '/links/:code' => 'link#delete', as: :delete
end
