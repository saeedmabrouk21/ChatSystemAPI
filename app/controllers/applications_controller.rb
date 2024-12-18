class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update ]

  # POST /applications
  def create
    @application = Application.new(application_params)

    if @application.save
      render json: { token: @application.token }, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # GET /applications/:token
  def show
    render json: ApplicationSerializer.new(@application).serializable_hash[:data][:attributes]
  end

  # PATCH/PUT /applications/:token
  def update
    retries = 0
    begin
      if @application.update(application_params)
        render json: ApplicationSerializer.new(@application).serializable_hash[:data][:attributes]
      else
        render json: @application.errors, status: :unprocessable_entity
      end
    rescue ActiveRecord::StaleObjectError
      Rails.logger.info "Retrying update for application with token #{@application.token}, attempt ##{retries}"
      retries += 1
      if retries <= Rails.configuration.max_retries
        # Reload the application and retry the update
        @application.reload
        retry
      else
        # If maximum retries exceeded, respond with a conflict error
        render json: { error: "Conflict detected. The application was updated by another process. Please try again." }, status: :conflict
      end
    end
  end


  private

  # Set application for actions that need a specific application
  def set_application
    @application = Application.find_by(token: params[:token])
    render json: { error: "Application not found" }, status: :not_found unless @application
  end

  # Strong parameters for application creation/updating
  def application_params
    params.require(:application).permit(:name)
  end
end
