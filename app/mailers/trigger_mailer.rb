class TriggerMailer < ApplicationMailer
  def email(from:, to:, subject:, html:, text:)
    mail(
      from: from,
      reply_to: from,
      to: to,
      subject: subject,
    ) do |format|
      format.html { render plain: html }
      format.text { render plain: text }
    end
  end
end
