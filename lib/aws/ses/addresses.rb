module AWS
  module SES
    # AWS::SES::Addresses provides for:
    # * Listing verified e-mail addresses
    # * Adding new e-mail addresses to verify
    # * Deleting verified e-mail addresses
    #
    # You can access these methods as follows:
    #
    #   ses = AWS::SES::Base.new( ... connection info ... )
    #
    #   # Get a list of verified addresses
    #   ses.addresses.list
    #
    #   # Add a new e-mail address to verify
    #   ses.addresses.verify('jon@example.com')
    #
    #   # Delete an e-mail address
    #   ses.addresses.delete('jon@example.com')
    class Addresses < Base
      def initialize(ses)
        @ses = ses
      end

      # List all verified e-mail addresses
      #
      # Usage:
      # ses.addresses.list
      # =>
      # ['email1@example.com', email2@example.com']
      def list
        @ses.client.list_verified_email_addresses().verified_email_addresses
      end

      def verify(email)
        @ses.client.verify_email_address(email_address: email)
      end

      def delete(email)
        @ses.client.delete_verified_email_address(email_address: email)
      end
    end

    class Base
      def addresses
        @addresses ||= Addresses.new(self)
      end
    end
  end
end
