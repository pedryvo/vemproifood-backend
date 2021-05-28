Rails.application.routes.draw do
  post '/', to: 'main#search'
end
