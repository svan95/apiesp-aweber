class SendDataWorker < ApplicationController
  include Sidekiq::Worker

  def perform(*args)
    contacts = Contact.where(sent_aweber: nil)
    if contacts.exists?
      contacts.each do |c|
        send_to_aweber(c)
      end
    end
  end
end
