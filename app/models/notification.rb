class Notification < ActiveRecord::Base
  mount_uploader :notice, FilesUploader
  belongs_to :notifiable, polymorphic: true

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

  NOTIFICATION_TYPE_TO_TEMPLATE_MAP = {
    COMPLETE_APPLICATION_AND_PUBLIC_MEETING => 'NOTICE OF COMPLETE APPLICATION AND PUBLIC MEETING',
    COMPLETE_APPLICATION => 'NOTICE OF COMPLETE APPLICATION',
    PUBLIC_MEETING => 'NOTICE OF PUBLIC MEETING',
    DECISION_MEETING => 'DECISION MEETING NOTICE',
    REVISED_APPLICATION_AND_PUBLIC_MEETING => 'NOTICE OF REVISED APPLICATION AND MEETING',
    REVISED_APPLICATION => 'NOTICE OF REVISED APPLICATION',
    PASSING => 'Notice of Passing',
    REJECTED => 'Notice of Decision - rejection',
    COMMENTS_CLOSED => 'Generic Comment Period Closed'
  }.freeze

  STATUS_TO_NOTIFICATION_TYPES_MAP = {
    Status::APPLICATION_COMPLETE_STATUS => [COMPLETE_APPLICATION, PUBLIC_MEETING, COMPLETE_APPLICATION_AND_PUBLIC_MEETING],
    Status::PLANNING_REVIEW_STATUS => [DECISION_MEETING, COMMENTS_CLOSED],
    Status::REVISION_STATUS => [REVISED_APPLICATION, REVISED_APPLICATION_AND_PUBLIC_MEETING],
    Status::DECISION_STATUS => [PASSING, REJECTED]
  }.freeze
end
