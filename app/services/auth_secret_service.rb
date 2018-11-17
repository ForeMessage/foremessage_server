class AuthSecretService
  class RefreshTokenInvalidError < StandardError ; end
  class TokenInvalidError < StandardError ; end
  class TokenExpiredError < StandardError ; end

  def valid_refresh_token?(user, refresh_token)
    decode(refresh_token)
    raise RefreshTokenInvalidError unless user.token.refresh_token == refresh_token

    true
  end

  def create_token(user, token)
    payload = user.create_payload_hash(token)

    encode(payload)
  end

  def decode(token)
    raise TokenInvalidError unless token.include?('.')

    segments = token.split('.')
    signature = base64url_decode(segments[2])
    signing_input = segments.first(2).join('.')

    raise TokenExpiredError if expired_token?(segments[1])

    result = token_verify(@key, signing_input, signature)

    if result
      JSON.parse(base64url_decode(segments[1]))
    else
      raise TokenInvalidError
    end
  end

  private
  def initialize
    @key = 'mySe0cret1'
    @algorithm = 'HS256'
    @header = { 'typ': 'JWT',
                'alg': @algorithm }
  end

  def encode(payload)
    header = base64_data(@header)
    payload = base64_data(payload)
    signature = sign([header, payload].join('.'))

    [header, payload, signature].join('.')
  end

  def expired_token?(payload)
    expired_at = JSON.parse(base64url_decode(payload))['exp']

    Time.now < expired_at ? false : true
  end

  def base64_data(data)
    base64url_encode(JSON.generate(data))
  end

  def rbnacl_fixup(algorithm, key)
    algorithm = algorithm.sub('HS', 'SHA').to_sym

    return [] unless defined?(RbNaCl) && RbNaCl::HMAC.constants(false).include?(algorithm)

    authenticator = RbNaCl::HMAC.const_get(algorithm)

    # Fall back to OpenSSL for keys larger than 32 bytes.
    return [] if key.bytesize > authenticator.key_bytes

    [
        authenticator,
        key.bytes.fill(0, key.bytesize...authenticator.key_bytes).pack('C*')
    ]
  end

  def sign(input_data)
    authenticator, padded_key = rbnacl_fixup(@algorithm, @key)

    signature = authenticator.auth(padded_key, input_data.encode('binary'))

    base64url_encode(signature)
  end

  def base64url_encode(str)
    Base64.encode64(str).tr('+/', '-_').gsub(/[\n=]/, '')
  end

  def token_verify(key, signing_input, signature)
    begin
      authenticator, padded_key = rbnacl_fixup(@algorithm, key)

      authenticator.verify(padded_key, signature.encode('binary'), signing_input.encode('binary'))
    rescue => e
      return false
    end
  end

  def base64url_decode(str)
    str += '=' * (4 - str.length.modulo(4))
    Base64.decode64(str.tr('-_', '+/'))
  end
end