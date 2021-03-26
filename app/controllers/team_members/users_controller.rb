module TeamMembers
  # app/controllers/team_members/users_controller.rb
  class UsersController < PaginationController
    before_action :user, except: %i[index search]
    before_action :user_location, :note, :user_notes, :wba, :wellbeing_metrics, :journal_entries, :unread_entries, :active_crisis, only: :show
    before_action :maximum, :user_pin, except: %i[show index search]
    before_action :verify_pin, only: :pin
    before_action :verify_unpin, only: :unpin
    before_action :query, :pinned_users, :active_users, :user_count, only: :index
    before_action :search, :limit_resources, :redirect, only: :index

    # GET /users/:id
    def show
      render 'show'
    end

    # PUT /users/:id/pin
    def pin
      @user_pin = current_team_member.user_pins.create!({ user: @user, order: @maximum.present? ? @maximum.next : 1 })

      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin ? message('has been pinned') : message('could not be pinned'))
    end

    # PUT /users/:id/unpin
    def unpin
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.destroy! ? message('has been unpinned') : message('could not be unpinned'))
    end

    # PUT /users/:id/increment
    def increment
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.increment ? message('pin successfully moved') : message('pin could not be moved'))
    end

    # PUT /users/:id/decrement
    def decrement
      redirect_back(fallback_location: authenticated_team_member_root_path,
                    notice: @user_pin.decrement ? message('pin successfully moved') : message('pin could not be moved'))
    end

    protected

    def limit
      @limit = 6
    end

    def resources
      @resources = User.includes(:wellbeing_assessments, :crisis_events).where.not(id: current_team_member.pinned_users)
                       .order(created_at: :desc)
    end

    private

    def note
      @note = Note.new
    end

    def user
      @user = User.includes(:notes).find(params[:id])
    end

    def user_count
      @user_count = User.count
    end

    def user_notes
      @user_notes = @user.notes.order(created_at: :desc)
    end

    def user_location
      @user_location = Timeout::timeout(5) { Net::HTTP.get_response(URI.parse('http://api.hostip.info/country.php?ip=' + @user.last_sign_in_ip )).body } rescue "Unknown"
    end

    def wba
      @wba = @user.last_wellbeing_assessment
    rescue ActiveRecord::RecordNotFound
      session notice: 'No wellbeing assessment could be found'
    end

    def wellbeing_metrics
      if @wba.present?
        (@wellbeing_metrics = @wba.wba_scores.includes(:wellbeing_metric))
      end
    end

    def active_crisis
      @active_crisis = @user.crisis_events.active
    end

    def journal_entries
      @journal_entries = @user.journal_entries
    end

    def unread_entries
      @unread_journal_entries = current_team_member.unread_journal_entries(@user)
    end

    def active_users
      @active_users = User.where(last_sign_in_at: (Time.zone.now - 30.days)..Time.zone.now).count
    end

    def maximum
      @maximum = current_team_member.user_pins.maximum(:order)
    end

    def message(message)
      "#{@user.full_name} #{message}"
    end

    def query_params
      params.permit(:query, :page)
    end

    def pinned_users
      @pinned_users = current_team_member.pinned_users.order(:order)
    end

    def query
      @query = query_params[:query]
    end

    def search
      return unless @query.present?

      @resources = User.where('lower(first_name) like lower(?) or lower(last_name) like lower(?)',
                              "%#{@query}%", "%#{@query}%")
    end

    def user_pin
      @user_pin = current_team_member.user_pins.find_by(user_id: @user.id)
    end

    def verify_pin
      return unless @user_pin.present?

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: message('is already pinned'))
    end

    def verify_unpin
      return if @user_pin.present?

      redirect_back(fallback_location: authenticated_team_member_root_path, alert: message('is not currently pinned'))
    end
  end
end
