module Response
  def success_response(status: :ok, message: '', extra_parameters: {})
    render json: {
        status: status,
        code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
        message: message,
        datetime: Time.now,
        timestamp: Time.now.to_i,
        data: extra_parameters.as_json
    }, status: status
  end

  def error_response(status: :bad_request, message: '', extra_parameters: {})
    render json: {
        status: status,
        code: Rack::Utils::SYMBOL_TO_STATUS_CODE[status],
        message: message,
        datetime: Time.now,
        timestamp: Time.now.to_i,
        details: extra_parameters.as_json
    }, status: status
  end
end