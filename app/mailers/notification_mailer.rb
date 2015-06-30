class NotificationMailer < ActionMailer::Base
  FROM = 'jd@antipattern.io'
  NEW_CODE_REVIEW = 'AntiPattern.io New CodeReview Notification'

  def new_code_review args
    @code_review = args[:code_review]
    @recipient = args[:subscriber]
    to = @recipient.email
    subject = NEW_CODE_REVIEW
    mail to: to, from: FROM, bcc: FROM, subject: subject
  end
end
