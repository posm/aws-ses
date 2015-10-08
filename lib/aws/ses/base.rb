module AWS #:nodoc:
  # AWS::SES is a Ruby library for Amazon's Simple Email Service's REST API (http://aws.amazon.com/ses).
  #
  # == Getting started
  #
  # To get started you need to require 'aws/ses':
  #
  #   % irb -rubygems
  #   irb(main):001:0> require 'aws/ses'
  #   # => true
  #
  # Before you can do anything, you must establish a connection using Base.new.  A basic connection would look something like this:
  #
  #   ses = AWS::SES::Base.new(
  #     :access_key_id     => 'abc',
  #     :secret_access_key => '123'
  #   )
  #
  # The minimum connection options that you must specify are your access key id and your secret access key.
  #
  # === Connecting to a server from another region
  #
  # The default server API endpoint is "email.us-east-1.amazonaws.com", corresponding to the US East 1 region.
  # To connect to a different one, just pass it as a parameter to the AWS::SES::Base initializer:
  #
  #   ses = AWS::SES::Base.new(
  #     :access_key_id     => 'abc',
  #     :secret_access_key => '123',
  #     :server => 'email.eu-west-1.amazonaws.com'
  #   )

  module SES

    # AWS::SES::Base is the abstract super class of all classes who make requests against SES
    class Base
      include SendEmail
      include Info

      attr_reader :client

      def initialize(options = {})
        puts "Initialising SES sender: #{options}"
        @source_arn = options[:source_arn]
        @client = Aws::SES::Client.new
      end
    end # class Base
  end # Module SES
end # Module AWS
