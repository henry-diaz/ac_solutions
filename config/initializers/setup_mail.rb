ActionMailer::Base.smtp_settings = {
  :address => "smtp.everyone.net",
  :port => 25,
  :domain => "216.200.145.17",
  :user_name => "send04@premper.net",
  :password => "S3nd04-12",
  :authentication => "login",
  :enable_starttls_auto => false
}
ActionMailer::Base.default_url_options[:host] = (Rails.env.development? ? "localhost:3000" : "ac-solutions.herokuapp.com")
ActionMailer::Base.delivery_method = :smtp
