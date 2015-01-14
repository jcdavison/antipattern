class OfferMailer < ActionMailer::Base
  default 
  SUBJ = 'Antipattern.io offer for code review'

  def notify_of_offer args
    @offer_owner = args[:offer_owner]
    @review_request_owner = args[:review_request_owner]
    mail to: @review_request_owner.email, from: 'jd@startuplandia.io', cc: @offer_owner, subject: SUBJ
  end
end
