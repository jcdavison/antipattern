class OfferMailer < ActionMailer::Base
  default from: "jd@startuplandia.io"
  SUBJ = 'Antipattern.io offer for code review'

  def notify_of_offer args
    @offer_owner = args[:offer_owner]
    @review_request_owner = args[:review_request_owner]
    mail to: @review_request_owner.email, cc: @offer_owner, subject: SUBJ
  end
end
