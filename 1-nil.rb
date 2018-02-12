# 1. Setup library code

class Fixnum
  def week
    Object.new.tap do |week_object|
      def week_object.ago
        Time.now - 604800
      end
    end
  end
end

class Array
  alias_method :find_each, :each
end

module Enquiries
  class ExperienceBookingEnquiry
    def self.where(*conditions)
      [new]
    end

    def customer_name
      'John Smith'
    end

    def creator
    end
  end
end

class ActionMailer
  def self.mail(to:,subject:,body:)
    Object.new.tap do |postman|
      def postman.deliver
        sleep 0.1
      end
    end
  end
end

class UserMailer < ActionMailer
  def self.forgotten_enquiry_reminder(enquiry)
    subject = "Reminder: #{enquiry.customer_name} is waiting for a booking"

    body = <<~REMINDER
    Hey #{enquiry.creator.name},

    We just wanted to quickly remind you that #{enquiry.customer_name} is still waiting for a booking.

    It's been a week since they received a response now; don't let them slip through the net :).

    Cheers,
    SalesMaster
    REMINDER

    mail to: enquiry.creator.email, subject: subject, body: body
  end
end

# 2. Setup application code

class SendForgottenEnquiryRemindersInteractor
  def self.perform(enquiries)
    enquiries.find_each do |enquiry|
      UserMailer.forgotten_enquiry_reminder(enquiry).deliver
    end
  end
end

# 3. Execute application code

enquiries = Enquiries::ExperienceBookingEnquiry
  .where('workflow_state = ? AND updated_at < ?', 'new', 1.week.ago)

SendForgottenEnquiryRemindersInteractor.perform(enquiries)
