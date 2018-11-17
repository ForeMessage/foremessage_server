module Exceptions
  class ParameterMissingError < StandardError
    attr_reader :missing_param

    def initialize(missing_param)
      @missing_param = missing_param
      super('Missing Parameters')
    end
  end

  class RequestHeaderMissingError < StandardError
    attr_reader :missing_header

    def initialize(missing_header)
      @missing_header = missing_header
      super('Missing Headers')
    end
  end
end