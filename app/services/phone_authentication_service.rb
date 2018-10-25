class PhoneAuthenticationService
  AWS_REGION = 'ap-northeast-1'
  AWS_ACCESS_KEY_ID = Rails.application.credentials[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials[:secret_access_key]

  def send_message(phone_number)
    @aws.publish(phone_number: "+82#{phone_number}", message: "foremessage의 인증 번호는 #{@certification_number}입니다.")

    @certification_number
  end

  private
  def initialize
    @aws = Aws::SNS::Client.new(region: AWS_REGION,
                         access_key_id: AWS_ACCESS_KEY_ID,
                         secret_access_key: AWS_SECRET_ACCESS_KEY)

    @certification_number = rand(1000..9999)
  end
end