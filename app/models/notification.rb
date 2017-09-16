class Notification < ActiveRecord::Base
  mount_uploader :notice, FilesUploader
  belongs_to :notifiable, polymorphic: true
  after_create :send_notification

  FROM_EMAIL = 'notifications@milieu.io'.freeze

  COMPLETE_APPLICATION = 'complete_application'.freeze
  PUBLIC_MEETING = 'public_meeting'.freeze
  COMPLETE_APPLICATION_AND_PUBLIC_MEETING = 'complete_application_and_public_meeting'.freeze
  REVISED_APPLICATION = 'revised_application'.freeze
  REVISED_APPLICATION_AND_PUBLIC_MEETING = 'revised_application_and_public_meeting'.freeze
  DECISION_MEETING = 'decision_meeting'.freeze
  COMMENTS_CLOSED = 'comments_closed'.freeze
  PASSING = 'passing'.freeze
  REJECTED = 'rejected'.freeze

  GUELPH_NOTIFICATION_TYPES = [
    COMPLETE_APPLICATION,
    PUBLIC_MEETING,
    COMPLETE_APPLICATION_AND_PUBLIC_MEETING,
    REVISED_APPLICATION,
    REVISED_APPLICATION_AND_PUBLIC_MEETING,
    DECISION_MEETING,
    COMMENTS_CLOSED,
    PASSING,
    REJECTED
  ]

  NOTIFICATION_TYPE_TO_TEMPLATE_MAP = {
    COMPLETE_APPLICATION_AND_PUBLIC_MEETING => 'notice-of-complete-application-and-public-meeting',
    COMPLETE_APPLICATION => 'notice-of-complete-application',
    PUBLIC_MEETING => 'notice-of-public-meeting',
    DECISION_MEETING => 'decision-meeting-notice',
    REVISED_APPLICATION_AND_PUBLIC_MEETING => 'notice-of-revised-application-and-meeting',
    REVISED_APPLICATION => 'notice-of-revised-application',
    PASSING => 'notice-of-passing',
    REJECTED => 'notice-of-decision-rejection',
    COMMENTS_CLOSED => 'comment-period-closed-generic'
  }.freeze

  STATUS_TO_NOTIFICATION_TYPES_MAP = {
    Status::APPLICATION_RECEIVED_STATUS => [],
    Status::APPLICATION_COMPLETE_STATUS => [COMPLETE_APPLICATION, PUBLIC_MEETING, COMPLETE_APPLICATION_AND_PUBLIC_MEETING],
    Status::PLANNING_REVIEW_STATUS => [DECISION_MEETING, COMMENTS_CLOSED],
    Status::REVISION_STATUS => [REVISED_APPLICATION, REVISED_APPLICATION_AND_PUBLIC_MEETING],
    Status::DECISION_STATUS => [PASSING, REJECTED]
  }.freeze

  validates :send_at, presence: true
  validates :notification_type, presence: true, inclusion: { in: GUELPH_NOTIFICATION_TYPES }

  def send_notification
    notification_factory = MandrillNotificationFactory.new
    mandrill_email_object = notification_factory.generate(self)

    Resque.enqueue(SendNotificationJob, mandrill_email_object) if mandrill_email_object
  end
end
