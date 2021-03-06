module AWS
  module SES
    # Adds functionality for the statistics and info send quota data that Amazon SES makes available
    #
    # You can access these methods as follows:
    #
    #   ses = AWS::SES::Base.new( ... connection info ... )
    #
    # == Get the quota information
    #   response = ses.quota
    #   # How many e-mails you've sent in the last 24 hours
    #   response.sent_last_24_hours
    #   # How many e-mails you're allowed to send in 24 hours
    #   response.max_24_hour_send
    #   # How many e-mails you can send per second
    #   response.max_send_rate
    #
    # == Get detailed send statistics
    # The result is a list of data points, representing the last two weeks of sending activity.
    # Each data point in the list contains statistics for a 15-minute interval.
    # GetSendStatisticsResponse#data_points is an array where each element is a hash with give string keys:
    #
    # * +Bounces+
    # * +DeliveryAttempts+
    # * +Rejects+
    # * +Complaints+
    # * +Timestamp+
    #
    #   response = ses.statistics
    #   response.data_points # =>
    #       [{"Bounces"=>"0",
    #         "Timestamp"=>"2011-01-26T16:30:00Z",
    #         "DeliveryAttempts"=>"1",
    #         "Rejects"=>"0",
    #         "Complaints"=>"0"},
    #        {"Bounces"=>"0",
    #         "Timestamp"=>"2011-02-09T14:45:00Z",
    #         "DeliveryAttempts"=>"3",
    #         "Rejects"=>"0",
    #         "Complaints"=>"0"},
    #        {"Bounces"=>"0",
    #         "Timestamp"=>"2011-01-31T15:30:00Z",
    #         "DeliveryAttempts"=>"3",
    #         "Rejects"=>"0",
    #         "Complaints"=>"0"},
    #        {"Bounces"=>"0",
    #         "Timestamp"=>"2011-01-31T16:00:00Z",
    #         "DeliveryAttempts"=>"3",
    #         "Rejects"=>"0",
    #         "Complaints"=>"0"}]

    module Info
      # Returns quota information provided by SES
      def quota
        @ses.client.get_send_quota()
      end

      def statistics
        @ses.client.get_send_statistics().send_data_points
      end
    end
  end
end
