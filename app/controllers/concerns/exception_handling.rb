module ExceptionHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      error_response(status: :not_found, message: e.message)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      error_response(status: :unprocessable_entitystatus, message: e.message)
    end

    rescue_from Exceptions::ParameterMissingError do |e|
      error_response(message: e.message, extra_parameters: { missing_param: e.missing_param })
    end

    rescue_from Exceptions::RequestHeaderMissingError do |e|
      error_response(message: e.message, extra_parameters: { missing_header: e.missing_header })
    end
  end
end