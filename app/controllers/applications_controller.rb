class ApplicationsController < ApplicationController
  before_action :set_application, only: [ :show, :update ]

  # POST /applications
  def create
    @application = Application.new(application_params)
    # Generates a random token for the application
    @application.token = SecureRandom.hex(10)

    if @application.save
      render json: @application, status: :created
    else
      render json: @application.errors, status: :unprocessable_entity
    end
  end

  # GET /applications/:token
  def show
    render json: @application
  end

  # PATCH/PUT /applications/:token
  def update
    if @application.update(application_params)
      render json: @application
    else
      render json: @application.errors, status: :unprocessable_entity
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
