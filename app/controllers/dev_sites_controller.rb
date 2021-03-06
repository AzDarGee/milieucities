class DevSitesController < ApplicationController
  DEFAULT_SITES_LIMIT = 50
  load_and_authorize_resource
  after_action :allow_iframe, only: [:index]

  def index
    @no_header = true
    # @dev_sites = DevSiteSearch.new(search_params).results
    @dev_sites= DevSite.all
    @total = @dev_sites.count
    paginate

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    @no_header = true
    @dev_site = DevSite.includes(:addresses, :statuses, :likes).find(params[:id])
    return redirect_to wakefield_path if @dev_site.devID.eql?('wakefield-1') && request.format.html?
  end

  def new
    @application_types = ApplicationType::VALID_APPLICATION_TYPES
    @statuses = @dev_site.valid_statuses
    @notification_options = Notification::STATUS_TO_NOTIFICATION_TYPES_MAP.to_json
    @contact_options = Contact::VALID_CONTACT_TYPES
    @no_header = true
  end

  def edit
    @application_types = ApplicationType::VALID_APPLICATION_TYPES
    @statuses = @dev_site.valid_statuses
    @notification_options = Notification::STATUS_TO_NOTIFICATION_TYPES_MAP.to_json
    @contact_options = Contact::VALID_CONTACT_TYPES
    @no_header = true
  end

  def create
    respond_to do |format|
      if @dev_site.save
        format.html { redirect_to @dev_site, notice: 'Development successfully created.' }
        format.json { render :show, status: :created, location: @dev_site }
      else
        format.html { render :new, alert: 'Failed to create development.' }
        format.json { render json: @dev_site.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @dev_site.update(dev_site_params.except(:files))
      add_new_files
      remove_deleted_files
      if @dev_site.save
        format.html { redirect_to @dev_site, notice: 'Development successfully updated.' }
        format.json { render :show, status: :accepted, location: @dev_site }
      else
        format.html { render :edit }
        format.json { render json: @dev_site.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @dev_site.destroy
    respond_to do |format|
      format.html { redirect_to dev_sites_path, notice: 'Development successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private

  def paginate
    limit = dev_sites_limit
    page = page_number
    @dev_sites.limit!(limit).offset!(limit * page)
  end

  def dev_sites_limit
    params[:limit].present? ? params[:limit].to_i : DEFAULT_SITES_LIMIT
  end

  def page_number
    params[:page].present? ? params[:page].to_i : 0
  end

  def add_new_files
    new_files = dev_site_params[:files]
    return unless new_files && new_files.any?

    dev_site_files = @dev_site.files
    dev_site_files += new_files
    @dev_site.files = dev_site_files
  end

  def remove_deleted_files
    files_to_delete = JSON.parse(params[:files_to_delete]) if params[:files_to_delete]
    return unless files_to_delete

    dev_site_files = @dev_site.files

    files_to_delete.each do |file_to_delete|
      deleted_file = dev_site_files.select {|uploader| uploader.file.filename == file_to_delete['name'] }.first
      deleted_file.try(:remove!)
      dev_site_files.delete(deleted_file)
      @dev_site.files = dev_site_files

      if @dev_site.files.empty? && @dev_site.read_attribute(:files).size == 1
        @dev_site.remove_files = true
      end

      @dev_site.save
    end

  end

  def search_params
    params.permit(:query, :latitude, :longitude, :year, :ward, :status, :municipality, :featured)
  end

  # rubocop:disable Metrics/MethodLength
  def dev_site_params
    params
      .require(:dev_site)
      .permit(
        :devID,
        :title,
        :address,
        :build_type,
        :description,
        :short_description,
        :ward_id,
        :municipality_id,
        :received_date,
        :active_at,
        :url_full_notice,
        addresses_attributes: [
          :id,
          :street,
          :city,
          :province_state,
          :country,
          :_destroy
        ],
        images: [],
        files: [],
        likes_attributes: [:id, :user_id, :dev_site_id, :_destroy]
      )
  end

  def allow_iframe
    response.headers.delete 'X-Frame-Options'
    # response.headers['X-Frame-Options'] = 'ALLOW-FROM http://guelph.ca'
  end
end
