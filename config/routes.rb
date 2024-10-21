Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      devise_for :users, path: '', singular: :user, path_names: {
        sign_in: 'login',
        sign_out: 'logout',
        registration: 'signup'
      },
      controllers: {
        sessions: 'api/v1/users/sessions',
        registrations: 'api/v1/users/registrations'
      }

      resources :events, only: [:index, :show, :edit, :new, :create]
    end
  end
end
