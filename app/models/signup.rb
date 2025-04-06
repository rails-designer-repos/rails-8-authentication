class Signup
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email_address, :string
  attribute :password, :string
  attribute :terms, :boolean, default: false

  validates :email_address, presence: true
  validates :password, length: 8..128
  validates :terms, acceptance: true

  validates :email_address, is_not_spam: true

  def save
    if valid?
      User.create!(email_address: email_address, password: password).tap do |user|
        create_workspace_for user
        send_welcome_email_to user
      end
    end
  end

  def model_name
    ActiveModel::Name.new(self, nil, self.class.name)
  end

  private

  def create_workspace_for(user)
    Workspace.create(name: "New Workspace").tap do |workspace|
      workspace.users << user
    end
  end

  def send_welcome_email_to(user)
    # eg. WelcomeEmail.perform_later user
  end
end
