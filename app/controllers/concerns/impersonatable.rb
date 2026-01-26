module Impersonatable
  extend ActiveSupport::Concern

  included do
    helper_method :impersonating?, :original_user, :impersonation_expires_at

    before_action :set_impersonation_context
    before_action :expire_impersonation
  end

  private

  IMPERSONATION_EXPIRY = 1.hour

  def impersonating?
    session[:impersonated_session_id].present?
  end

  def original_user
    if impersonating?
      Session.find_by(id: session[:impersonated_session_id])&.user
    end
  end

  def impersonation_expires_at
    if impersonating?
      Time.zone.parse(session[:impersonated_at]) + IMPERSONATION_EXPIRY
    end
  end

  def set_impersonation_context
    Current.impersonated_user_id = session[:impersonated_user_id]
    Current.impersonated_session_id = session[:impersonated_session_id]
  end

  def expire_impersonation
    if impersonating? && impersonation_expired?
      unimpersonate!
    end
  end

  def impersonate!(user)
    if impersonatable?(user)
      session[:impersonated_session_id] = Current.session.id
      session[:impersonated_user_id] = user.id
      session[:impersonated_at] = Time.current
    end
  end

  def unimpersonate!
    session.delete(:impersonated_session_id)
    session.delete(:impersonated_user_id)
  end

  def impersonation_expired?
    started_at = Time.zone.parse(session[:impersonated_at])

    started_at.blank? || started_at.before?(IMPERSONATION_EXPIRY.ago)
  end

  def impersonatable?(user)
    Current.user.present?
      && !impersonating?
      && Current.user.id != user.id
  end
end
