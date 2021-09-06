# app/models/journal_entry.rb
class JournalEntry < PermissionRecord
  belongs_to :user

  has_many :journal_entry_permissions, foreign_key: :journal_entry_id, dependent: :delete_all
  has_many :journal_entry_view_logs, foreign_key: :journal_entry_id, dependent: :delete_all

  after_create :increment_cache

  scope :created_in_last_week, -> { where('journal_entries.created_at >= ?', 1.week.ago) }
  scope :created_in_last_month, -> { where('journal_entries.created_at >= ?', 1.month.ago) }

  def permissions
    journal_entry_permissions
  end

  private

  def increment_cache
    user.update!(journal_entries_count: user.journal_entries_count + 1,
                 journal_entries_this_month_count: Date.today.day == 1 ? 1 : user.journal_entries_this_month_count + 1)
  end
end
