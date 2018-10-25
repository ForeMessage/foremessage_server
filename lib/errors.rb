class ForemessageError < StandardError
  def serialize
    {
        error: {
            code: @code,
            message: @message,
            detail: @detail
        }
    }
  end

  private
  def initialize(code, message, detail)
    @code = code
    @message = message
    @detail = detail
  end
end