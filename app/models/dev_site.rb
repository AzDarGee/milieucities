class DevSite < ActiveRecord::Base
  scope :latest, -> { joins(:statuses).order('statuses.status_date DESC') }

  mount_uploaders :images, ImagesUploader
  mount_uploaders :files, FilesUploader

  VALID_APPLICATION_TYPES = [
    'Site Plan Approval',
    'Condo Approval',
    'Subdivision Approval',
    'Zoning Amendment',
    'Registered Condominium',
    'Site Plan Control',
    'Official Plan Amendment',
    'Zoning By-law Amendment',
    'Demolition Control',
    'Cash-in-lieu of Parking',
    'Plan of Subdivision',
    'Plan of Condominium',
    'Derelict',
    'Vacant',
    'Master Plan'
  ].freeze

  VALID_BUILDING_TYPES = [
    'Not Applicable',
    'Derelict',
    'Demolition',
    'Residential Apartment',
    'Low-rise Residential',
    'Mid-rise Residential',
    'Hi-rise Residential',
    'Mixed-use Residential/Community',
    'Commercial',
    'Commercial/Hotel',
    'Mixed-use',
    'Additions'
  ].freeze

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :addresses, as: :addressable, dependent: :destroy
  has_one  :sentiment, as: :sentimentable, dependent: :destroy
  has_many :statuses, dependent: :destroy
  has_many :city_files, dependent: :destroy
  has_many :likes, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true
  accepts_nested_attributes_for :statuses, allow_destroy: true
  accepts_nested_attributes_for :likes, allow_destroy: true

  validates :devID, uniqueness: { message: 'Dev Id must be unique' }
  validates :application_type, presence: { message: 'Application type is required' }
  validates :description, presence: { message: 'Description is required' }
  validates :ward_name, presence: { message: 'Ward name is required' }
  validates :ward_num, presence: { message: 'Ward number is required' }, numericality: true

  def self.search(search_params)
    @dev_sites = DevSite.all
    @search_params = search_params

    location_search
    query_search

    @dev_sites
  end

  def status
    return if statuses.empty?
    statuses.order('status_date DESC').first.status
  end

  def status_date
    return if statuses.empty?
    return nil unless statuses.order('status_date DESC').first.status_date
    statuses.order('status_date DESC').first.status_date.strftime('%B %e, %Y')
  end

  def street
    return if addresses.empty?
    addresses.first.street
  end

  def address
    return if addresses.empty?
    [addresses.first.street, addresses.first.city, addresses.first.province_state].delete_if(&:blank?).join(', ')
  end

  def latitude
    return if addresses.empty?
    addresses.first.lat
  end

  def longitude
    return if addresses.empty?
    addresses.first.lon
  end

  def image_url
    return images.first.web.url if images.present?
    return streetview_image unless addresses.empty?
    ActionController::Base.helpers.image_path('mainbg.jpg')
  end

  def update_sentiment(comment_sentiment)

    update({
      anger_total: comment_sentiment.anger + anger_total,
      joy_total: comment_sentiment.joy + joy_total,
      fear_total: comment_sentiment.fear + fear_total,
      sadness_total: comment_sentiment.sadness + sadness_total,
      disgust_total: comment_sentiment.disgust + disgust_total
    })

    create_sentiment if sentiment.blank?
    comments_count = comments.count

    sentiment.update({
      anger: anger_total/comments_count,
      joy: joy_total/comments_count,
      fear: fear_total/comments_count,
      sadness: sadness_total/comments_count,
      disgust: disgust_total/comments_count
    })
  end

  def self.find_ordered(ids)
    return where(id: ids) if ids.empty?
    order_clause = 'CASE dev_sites.id '
    ids.each_with_index do |id, index|
      order_clause << "WHEN #{id} THEN #{index} "
    end
    order_clause << "ELSE #{ids.length} END"
    where(id: ids).order(order_clause)
  end

  after_create do
    Resque.enqueue(NewDevelopmentNotificationJob, id) unless Rails.env.test?
  end

  private

  def streetview_image
    root_url = 'https://maps.googleapis.com/maps/api/streetview'
    image_size = '600x600'
    api_key = 'AIzaSyAwocEz4rtf47zDkpOvmYTM0gmFT9USPAw'

    "#{root_url}?size=#{image_size}&location=#{address}&key=#{api_key}"
  end

  class << self
    def location_search
      location_search_params = [:latitude, :longitude]
      search_by_location if location_search_params.all? { |param| @search_params[param].present? }
    end

    def query_search
      query_params = [:year, :ward, :status]
      query_params.each do |param|
        send("search_by_#{param}") if @search_params[param].present?
      end
    end

    def search_by_location
      dev_site_ids = []
      lat = @search_params[:latitude]
      lon = @search_params[:longitude]
      dev_site_ids
        .push(Address.within(5, origin: [lat, lon])
        .closest(origin: [lat, lon])
        .limit(150)
        .pluck(:addressable_id))
      @dev_sites = DevSite.find_ordered(dev_site_ids.flatten.uniq)
    end

    def search_by_year
      @dev_sites.where!('extract(year from updated) = ?', @search_params[:year])
    end

    def search_by_ward
      @dev_sites.where!('lower(ward_name) = lower(?)', @search_params[:ward])
    end

    def search_by_status
      @dev_sites
        .where!("statuses.status_date = (select max(statuses.status_date) \
                 from statuses where statuses.dev_site_id = dev_sites.id)")
        .where!(statuses: { status: @search_params[:status] })
    end
  end
end
