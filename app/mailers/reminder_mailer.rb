class ReminderMailer < ApplicationMailer
  default from: 'example@gmail.com'

  def reminder_email
    @reminder = params[:reminder]
    mail(to: @reminder.user.email, subject: 'reminder')
  end
end
