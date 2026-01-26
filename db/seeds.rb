workspace = Workspace.create name: "Default workspace"

User.create!(
  workspace: workspace,
  email_address: "test@example.com",
  password: "password"
)

9.times do |index|
  User.create!(
    workspace: workspace,
    email_address: "test#{index + 1}@example.com",
    password: "password"
  )
end
