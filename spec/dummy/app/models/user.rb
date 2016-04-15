class User < ActiveRecord::Base
  has_many :likes

  def send_instructions
    mail = Notifier.instructions(self)
    mail.send(mail.respond_to?(:deliver_now) ? :deliver_now : :deliver)
  end
end
