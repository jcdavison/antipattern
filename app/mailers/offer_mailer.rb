class OfferMailer < ActionMailer::Base

  def notify_of_offer args
    @offer_owner = args[:offer_owner]
    @review_request_owner = args[:review_request_owner]
    @review_request_id = args[:review_request_id]
    to = @review_request_owner.email
    subject = 'Antipattern.io offer for code review'
    mail to: to, from: 'jd@antipattern.io', subject: subject
  end

  def notify_acceptance recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    to = [ @offer_owner.email, @review_request_owner.email ]
    subject = 'Antipattern.io acceptance of Code Review Offer'
    mail to: to, from: 'jd@antipattern.io', subject: subject
  end

  def notify_rejection recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    to = @offer_owner.email
    subject = 'Antipattern.io code review offer status'
    mail to: to, from: 'jd@antipattern.io', subject: subject
  end
end
