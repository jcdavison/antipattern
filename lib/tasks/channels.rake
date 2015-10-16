task :populate_notification_channels => :environment do
  CodeReview.avail_topics.each do |topic|
    NotificationChannel.find_or_create_by name: topic
  end
end
