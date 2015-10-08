module AWS
  module SES
    # Adds functionality for send_email and send_raw_email
    # Use the following to send an e-mail:
    #
    #   ses = AWS::SES::Base.new( ... connection info ... )
    #   ses.send_email :to        => ['jon@example.com', 'dave@example.com'],
    #                :source    => '"Steve Smith" <steve@example.com>',
    #                :subject   => 'Subject Line'
    #                :text_body => 'Internal text body'
    #
    # By default, the email "from" display address is whatever is before the @.
    # To change the display from, use the format:
    #
    #   "Steve Smith" <steve@example.com>
    #
    # You can also send Mail objects using send_raw_email:
    #
    #   m = Mail.new( :to => ..., :from => ... )
    #   ses.send_raw_email(m)
    #
    # send_raw_email will also take a hash and pass it through Mail.new automatically as well.
    #
    module SendEmail

      # Sends an email through SES
      #
      # the destination parameters can be:
      #
      # [A single e-mail string]  "jon@example.com"
      # [A array of e-mail addresses]  ['jon@example.com', 'dave@example.com']
      #
      # ---
      # = "Email address is not verified.MessageRejected (AWS::Error)"
      # If you are receiving this message and you HAVE verified the [source] please <b>check to be sure you are not in sandbox mode!</b>
      # If you have not been granted production access, you will have to <b>verify all recipients</b> as well.
      # http://docs.amazonwebservices.com/ses/2010-12-01/DeveloperGuide/index.html?InitialSetup.Customer.html
      # ---
      #
      # @option options [String] :source Source e-mail (from)
      # @option options [String] :from alias for :source
      # @option options [String] :to Destination e-mails
      # @option options [String] :cc Destination e-mails
      # @option options [String] :bcc Destination e-mails
      # @option options [String] :subject
      # @option options [String] :html_body
      # @option options [String] :text_body
      # @option options [String] :return_path The email address to which bounce notifications are to be forwarded. If the message cannot be delivered to the recipient, then an error message will be returned from the recipient's ISP; this message will then be forwarded to the email address specified by the ReturnPath parameter.
      # @option options [String] :reply_to The reploy-to email address(es) for the message.  If the recipient replies to the message, each reply-to address will receive the reply.
      # @option options
      # @return [Response] the response to sending this e-mail
      def send_email(options = {})
        package = {}

        package[:source] = options[:source] || options[:from]

        destinations = {}
        destinations[:to_addresses] = options[:to] if options[:to]
        destinations[:cc_addresses] = options[:cc] if options[:cc]
        destinations[:bcc_addresses] = options[:bcc] if options[:bcc]
        package[:destination] = destinations

        package[:message] = {
          subject: { data: options[:subject] },
          body: { }
        }

        if options[:html_body]
          package[:message][:body][:html] = { data: options[:html_body] }
        end
        if options[:text_body] || options[:body]
          package[:message][:body][:text] =
            { data: options[:text_body] || options[:body] }
        end
        if options[:return_path]
          package[:return_path] = options[:return_path]
        end
        if options[:reply_to]
          package[:reply_to_addresses] = options[:reply_to]
        end
        package[:source_arn] = @source_arn if @source_arn

        puts "Calling send_email: #{package}"
        resp = @client.send_email(package)
        puts "Response: #{resp}"
        resp
      rescue => e
        puts e.message
        puts e.backtrace
      end

      # Sends using the SendRawEmail method
      # This gives the most control and flexibility
      #
      # This uses the underlying Mail object from the mail gem
      # You can pass in a Mail object, a Hash of params that will be parsed by Mail.new, or just a string
      #
      # Note that the params are different from send_email
      # Specifically, the following fields from send_email will NOT work:
      #
      # * :source
      # * :html_body
      # * :text_body
      #
      # send_email accepts the aliases of :from & :body in order to be more compatible with the Mail gem
      #
      # This method is aliased as deliver and deliver! for compatibility (especially with Rails)
      #
      # @option mail [String] A raw string that is a properly formatted e-mail message
      # @option mail [Hash] A hash that will be parsed by Mail.new
      # @option mail [Mail] A mail object, ready to be encoded
      # @option args [String] :source The sender's email address
      # @option args [String] :destinations A list of destinations for the message.
      # @option args [String] :from alias for :source
      # @option args [String] :to alias for :destinations
      # @return [Response]
      def send_raw_email(mail, args = {})
        puts "send_raw_email: mail=#{mail.inspect} args=#{args}"
        message = mail.is_a?(Hash) ? Mail.new(mail) : mail
        if message.has_attachments? && message.text_part.nil? && message.html_part.nil?
          raise ArgumentError, "Attachment provided without message body"
        end

        options = { }
        options[:from] = message.from.first
        options[:from] = args[:from] if args[:from]
        options[:from] = args[:source] if args[:source]
        options[:to] = message.to if message.to
        options[:to] = args[:to] if args[:to]
        options[:cc] = message.cc if message.cc
        options[:cc] = args[:cc] if args[:cc]
        options[:bcc] = message.bcc if message.bcc
        options[:bcc] = args[:bcc] if args[:bcc]
        options[:subject] = message.subject
        options[message.mime_type == 'text/html' ? :html_body : :text_body] = message.body.decoded
        options[:return_path] = message.return_path if message.return_path
        options[:reply_to] = message.reply_to if message.reply_to

        send_email(options)
      end

      alias :deliver! :send_raw_email
      alias :deliver  :send_raw_email
    end
  end
end
