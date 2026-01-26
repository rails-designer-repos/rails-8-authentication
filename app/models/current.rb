class Current < ActiveSupport::CurrentAttributes
  attribute :session, :impersonated_user_id, :impersonated_session_id

  def user
    impersonated_user || session&.user
  end

  delegate :workspace, to: :user, allow_nil: true

  private

  def impersonated_user
    if impersonated_user_id.present?
      User.find_by(id: impersonated_user_id)
    end
  end
end
