Rails.application.routes.draw do
  # Priority: first created -> highest priority
  # Show all routes: "rake routes"

  root 'welcome#index'
  get 'about' => 'welcome#about'
  get 'quick_search/member' => 'welcome#search_member'

  # Member Management
  resources :members do
    member do
      # put 'update_membership', as: 'update_membership_of'
    end
    collection do
      get 'moi_sheet', as: nil
      get 'email_list', as: nil
      get 'importer', as: nil, to: 'members_import#index'
      post 'importer/import', as: nil, to: 'members_import#import'
    end
    resources :memberships, only: [:index, :create, :destroy]
  end

  # User Session
  scope 'users', as: 'user' do
    resource :session, only: [:new, :create, :destroy],
                       controller: 'user_session'
  end

  # User Management
  resources :users

end
