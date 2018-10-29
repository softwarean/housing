class Api::ApplicationController < ActionController::API
  include PunditConcern

  before_action :restrict_content_type, :authorize_request

  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from Apipie::ParamMissing, with: :param_missing
  rescue_from Apipie::ParamInvalid, with: :param_invalid

  attr_reader :current_user

  private

  def restrict_content_type
    return if request.content_type == 'application/json'

    render_error(:not_acceptable, 'Content-Type must be application/json')
  end

  def authorize_request
    command = Api::AuthorizeRequest.call(request.headers)

    if command.success?
      @current_user = command.result
    else
      access_forbidden
    end
  end

  def not_authorized
    render_error(:unauthorized, I18n.t('api.errors.not_authorized'))
  end

  def access_forbidden
    render_error(:forbidden, I18n.t('api.errors.forbidden'))
  end

  def not_found
    render_error(:not_found, I18n.t('api.errors.not_found'))
  end

  def param_missing(exception)
    missing_param = exception.param.name

    unprocessable_entity(missing_param => [I18n.t('api.errors.missing_param')])
  end

  def param_invalid(exception)
    invalid_param = exception.param

    unprocessable_entity(invalid_param => [I18n.t('api.errors.invalid_param')])
  end

  def unprocessable_entity(errors)
    render_error(:unprocessable_entity, I18n.t('api.errors.unprocessable_entity'), errors)
  end

  def render_success
    render json: {
      status: :success
    }, status: :ok
  end

  def render_error(status, message, errors = nil)
    body = {
      status: :error,
      message: message
    }

    body[:errors] = errors if errors.present?

    render json: body, status: status
  end

  def render_data(data)
    render json: {
      status: :success,
      data: data
    }, status: :ok
  end

  def serialize_model(model, serializer)
    serializer.new(model, root: false)
  end

  def serialize_collection(collection, each_serializer)
    ActiveModelSerializers::SerializableResource.new(collection, each_serializer: each_serializer)
  end
end
