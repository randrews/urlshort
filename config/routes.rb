Rails.application.routes.draw do
  root 'link#form'

  post '/v1/links' => 'link#api_create', as: :api_create
  post '/v1/links/:code/delete' => 'link#api_delete', as: :api_delete
  post '/v1/links/:code/update' => 'link#api_update', as: :api_update
  get '/v1/:code' => 'link#visit', as: :visit
end
