class OfferMailer < ActionMailer::Base
  add_template_helper GeneralHelper
  FROM = 'jd@antipattern.io'

  def notify_of_offer recipients
    @offer_owner = recipients[:offer_owner]
    @code_review_owner = recipients[:code_review_owner]
    @code_review_id = recipients[:code_review].id
    to = [ @code_review_owner.email, @offer_owner.email ]
    subject = "Antipattern.io, let's review some code!"
    mail to: to, from: FROM, subject: subject
  end
end
