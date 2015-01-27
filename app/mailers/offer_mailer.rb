class OfferMailer < ActionMailer::Base

  SUBJ = 'Antipattern.io offer for code review'
  def notify_of_offer args
    @offer_owner = args[:offer_owner]
    @review_request_owner = args[:review_request_owner]
    @review_request_id = args[:review_request_id]
    to = @review_request_owner.email
    mail to: to, from: 'jd@startuplandia.io', subject: SUBJ
  end

end
