Rails.application.routes.draw do
  resources :notes
  devise_for :users, path: 'users',
                     controllers: { registrations: 'users/registrations',
                                    confirmations: 'users/confirmations',
                                    sessions: 'users/sessions',
                                    passwords: 'users/passwords',
                                    unlocks: 'users/unlocks' }
  devise_for :team_members, path: 'team_members',
                            controllers: { registrations: 'team_members/registrations',
                                           confirmations: 'team_members/confirmations',
                                           sessions: 'team_members/sessions',
                                           passwords: 'team_members/passwords',
                                           unlocks: 'team_members/unlocks' }

  authenticated :user do
    scope module: 'users' do
      root 'dashboard#show', as: :authenticated_user_root

      resources :wba_selves, only: %i[show new create] do
        resources :wba_self_permissions, only: %i[new create], as: :permissions
      end

      resources :journal_entries, only: %i[new create] do
        resources :journal_entry_permissions, only: %i[new create], as: :permissions

        get 'dashboard', to: 'journal_entries_dashboard#show', on: :collection, as: :dashboard
        get 'page/:page_number', to: 'journal_entries_pages#index', on: :collection, as: :pages
      end

      resources :crisis_events, only: :create do
        put '/:crisis_event_id', to: 'crisis_events#update', on: :collection, as: :update
      end
    end
  end

  authenticated :team_member do
    scope module: 'team_members' do
      root 'dashboard#show', as: :authenticated_team_member_root

      resources :team_members, only: :show do
        scope controller: 'team_members' do
          put 'approve', action: 'approve_team_member', on: :member, as: :approve
          put 'admin', action: 'toggle_admin', on: :member, as: :toggle_admin
        end

        resources :wba_team_members, path: 'wba', only: :show, as: :wba_team_member
      end

      resources :users, only: :show, as: :user
      resources :crisis_events, only: %i[show index], as: :crisis_events do
        put 'close', action: 'close', on: :member, as: :close
      end
    end
  end

  unauthenticated do
    root 'pages#main'
  end
end
