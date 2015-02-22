class OfferMailer < ActionMailer::Base
  FROM = 'jd@antipattern.io'

  def notify_of_offer recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    @review_request_id = recipients[:code_review].id
    to = @review_request_owner.email
    subject = 'Antipattern.io Code Review offer'
    mail to: to, from: FROM, subject: subject
  end

  def notify_acceptance recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    @code_review = recipients[:code_review]
    to = [ @offer_owner.email, @review_request_owner.email ]
    subject = 'Antipattern.io Code Review offer acceptance'
    mail to: to, from: FROM, subject: subject
  end

  def notify_rejection recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    to = @offer_owner.email
    subject = 'Antipattern.io Code Review offer update'
    mail to: to, from: FROM, subject: subject
  end

  def notify_delivery recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    @code_review = recipients[:code_review]
    to = @review_request_owner.email
    subject = 'Antipattern.io Code Review delivery'
    mail to: to, from: FROM, subject: subject
  end

  def notify_pay recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    @code_review = recipients[:code_review]
    to = @offer_owner.email
    subject = 'Antipattern.io Code Review acceptance and pmt'
    mail to: to, from: FROM, subject: subject
  end

  def notify_dispute recipients
    @offer_owner = recipients[:offer_owner]
    @review_request_owner = recipients[:review_request_owner]
    @code_review = recipients[:code_review]
    @offer = recipients[:offer]
    mail to: 'jd@startuplandia.io', from: FROM, subject: 'Antipattern dispute'
  end

  def notify_confirmation recipients
    @offer_owner = recipients[:offer_owner]
    @code_review = recipients[:code_review]
    @review_request_owner = recipients[:review_request_owner]
    @offer = recipients[:offer]
    to = @offer_owner.email
    mail to: to, from: FROM, subject: 'Antipattern CodeReview Confirmation'
  end
end
