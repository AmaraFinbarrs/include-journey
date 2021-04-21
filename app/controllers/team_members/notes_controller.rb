module TeamMembers
  # app/controllers/team_members/notes_controller.rb
  class NotesController < TeamMembersApplicationController
    before_action :note_params, :user, only: %i[create update]
    before_action :note, only: :update

    # POST /notes
    def create
      @note = create_note(nil)
      redirect_to user_path(@user), notice: @note ? 'Note added!' : "The note couldn't be added. Please try again."
    end

    # GET /notes/:id
    def show
      # Show all notes in the edit-chain.
    end

    # PUT /notes/:id/update
    def update
      redirect_to user_path(@user), notice: 'Nothing to update!' and return if no_changes_made?

      ActiveRecord::Base.transaction do
        @new_note = create_note(@note)
        @note.update!(replaced_by: @new_note)
      end
      redirect_to user_path(@user), flash: { success: 'Successfully updated note!' }
    rescue ActiveRecord::RecordInvalid
      redirect_to user_path(@user), flash: { error: 'Something went wrong. Please try again.' }
    end

    # DELETE
    def destroy
      # destroy
    end

    private

    def no_changes_made?
      @note[:content] == note_params[:content] || @note[:visible_to_user] == note_params[:visible_to_user]
    end

    def create_note(replacing = nil)
      current_team_member.notes.create!(content: note_params[:content],
                                        visible_to_user: note_params[:visible_to_user],
                                        user: @user,
                                        replacing: replacing)
    end

    def user
      @user = User.find(params[:user_id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: users_path, flash: { error: 'User not found' })
    end

    def note
      @note = Note.find(note_params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_back(fallback_location: user_path, flash: { error: 'Note not found' })
    end

    def note_params
      params.require(:note).permit(:id, :content, :visible_to_user)
    end
  end
end
