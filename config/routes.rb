Rails.application.routes.draw do
  root 'link#form'

  post '/v1/links' => 'link#api_create', as: :api_create
  get '/v1/:code' => 'link#visit', as: :visit
end
