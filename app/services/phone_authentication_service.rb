class PhoneAuthenticationService
  AWS_REGION = 'ap-northeast-1'
  AWS_ACCESS_KEY_ID = Rails.application.credentials[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials[:secret_access_key]

  def send_message(phone_number)
    @aws.publish(phone_number: "+82#{phone_number}", message: "foremessage의 인증 번호는 #{@certification_number}입니다.")

    @certification_number
  end

  def send_message_to_unknown(phone_numbers, sender)
    phone_numbers.each do |number|
      @aws.publish(phone_number: "+82#{number}", message: "#{sender}님에게 등기메시지가 왔습니다. 확인하려면 앱을 다운로드하세요. https://www.apple.com/itunes/charts/free-apps/")
    end
  end

  private
  def initialize
    @aws = Aws::SNS::Client.new(region: AWS_REGION,
                         access_key_id: AWS_ACCESS_KEY_ID,
                         secret_access_key: AWS_SECRET_ACCESS_KEY)

    @certification_number = rand(1000..9999)
  end
end