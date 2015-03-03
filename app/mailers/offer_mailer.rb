class OfferMailer < ActionMailer::Base
  FROM = 'jd@antipattern.io'

  def notify_of_offer recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review_id = recipients[:code_review].id
    to = @code_review_owner.email
    subject = 'Antipattern.io offer to Code Review'
    mail to: to, from: FROM, subject: subject
  end

  def notify_acceptance recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review = recipients[:code_review]
    to = [ @offer_owner.email, @code_review_owner.email ]
    subject = 'Antipattern.io offer to Code Review Accepted'
    mail to: to, from: FROM, subject: subject
  end

  def notify_rejection recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    to = @offer_owner.email
    subject = 'Antipattern.io Code Review offer update'
    mail to: to, from: FROM, subject: subject
  end

  def notify_delivery recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review = recipients[:code_review]
    to = @code_review_owner.email
    subject = 'Antipattern.io Code Review delivery'
    mail to: to, from: FROM, subject: subject
  end

  def notify_pay recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review = recipients[:code_review]
    to = @offer_owner.email
    subject = 'Antipattern.io Code Review Payment'
    mail to: to, from: FROM, subject: subject
  end

  def notify_dispute recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review = recipients[:code_review]
    @offer = recipients[:offer]
    mail to: 'jd@startuplandia.io', from: FROM, subject: 'Antipattern dispute'
  end

  def notify_confirmation recipients
    @offer_owner = recipients[:offer_owner]
    @code_review = recipients[:code_review]
    @code_review_owner = recipients[:code_review_owner]
    @offer = recipients[:offer]
    to = @offer_owner.email
    mail to: to, from: FROM, subject: 'Antipattern CodeReview Confirmation'
  end
end
