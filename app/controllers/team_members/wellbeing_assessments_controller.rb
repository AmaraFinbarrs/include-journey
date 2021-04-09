module TeamMembers
  # app/controllers/team_members/wellbeing_assessments_controller.rb
  class WellbeingAssessmentsController < TeamMembersApplicationController
    before_action :user, except: :show
    before_action :team_member, :wellbeing_assessments, only: :index
    include Pagination

    before_action :wellbeing_metrics, only: %i[new create]
    before_action :wba_params, only: :create
    after_action :wba_scores, only: :create

    # GET /wellbeing_assessments
    # GET /team_members/:team_member_id/wellbeing_assessments
    # GET /users/:user_id/wellbeing_assessments
    def index; end

    # GET /wellbeing_assessments/:id
    def show
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])

      render 'show'
    end

    # GET /users/:user_id/wellbeing_assessments/new
    def new
      wellbeing_assessment_today
      last_scores
      @wellbeing_assessment = WellbeingAssessment.new

      render 'new'
    end

    # POST /users/:user_id/wellbeing_assessments
    def create
      if (@wellbeing_assessment = current_team_member.wellbeing_assessments.create!(user: @user))
        redirect_to wellbeing_assessment_path(@wellbeing_assessment)
      else
        redirect_to authenticated_team_member_root_path,
                    error: "Wellbeing assessment could not be created: #{@wellbeing_assessment.errors}"
      end
    end

    protected

    def resources
      @wellbeing_assessments.includes(:user, :wba_scores).order(created_at: :desc)
    end

    def resources_per_page
      6
    end

    def search
      @wellbeing_assessments.includes(:user, :wba_scores).joins(:user).where(user_search, wildcard_query)
                            .order(created_at: :desc)
    end

    private

    def last_scores
      last_wellbeing_assessment = @user.last_wellbeing_assessment

      return unless last_wellbeing_assessment.present?

      @last_scores = last_wellbeing_assessment.wba_scores.collect do |wba_score|
        { id: wba_score.wellbeing_metric_id, value: wba_score.value }
      end
    end

    def new_wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.new
    end

    def team_member
      return unless params[:team_member_id].present?

      @team_member = TeamMember.includes(:wellbeing_assessments).find(params[:team_member_id])
    end

    def user
      return unless params[:user_id].present?

      @user = User.includes(:wellbeing_assessments).find(params[:user_id])
    end

    def wba_params
      params.require(:wellbeing_assessment).permit(@wellbeing_metrics.map { |metric| "wellbeing_metric_#{metric.id}" })
    end

    def wba_scores
      @wellbeing_metrics.each do |metric|
        @wellbeing_assessment.wba_scores.create!({ wellbeing_metric: metric,
                                                   value: wba_params["wellbeing_metric_#{metric.id}"] })
      end
    end

    def wellbeing_assessment
      @wellbeing_assessment = WellbeingAssessment.includes(:user, :team_member).find(params[:id])
    end

    def wellbeing_assessments
      @wellbeing_assessments =
        if @team_member.present?
          @team_member.wellbeing_assessments
        elsif @user.present?
          @user.wellbeing_assessments
        else
          WellbeingAssessment
        end
    end

    def wellbeing_assessment_today
      wellbeing_assessment_today = @user.wellbeing_assessment_today

      return unless wellbeing_assessment_today.present?

      redirect_to wellbeing_assessment_path(wellbeing_assessment_today),
                  notice: 'The below wellbeing assessment was completed today'
    end

    def wellbeing_metrics
      @wellbeing_metrics = WellbeingMetric.all.order(:created_at)
    end
  end
end
