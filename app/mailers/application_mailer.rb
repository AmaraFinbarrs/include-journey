# app/mailers/application_mailer.rb
class ApplicationMailer < ActionMailer::Base
  helper :mailer

  default from: 'plic-journey@legaltech.wales'
  layout 'mailer'
end
