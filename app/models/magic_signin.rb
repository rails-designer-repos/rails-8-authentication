class MagicSignin
  AUTO_GENERATED_PASSWORD = SecureRandom.hex(32)

  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :email_address, :string

  validates :email_address, presence: true

  validates :email_address, is_not_spam: true

  def save
    return unless valid?

    User.where(email_address: email_address).first_or_create.tap do |user|
      if user.new_record?
        user.password = AUTO_GENERATED_PASSWORD
        user.save

        create_workspace_for user
      end

      send_magic_link_to user
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

  def send_magic_link_to(user)
    MagicSignupMailer.magic_link(user).deliver_later
  end
end
