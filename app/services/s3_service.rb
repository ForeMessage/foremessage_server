class S3Service
  AWS_REGION = 'ap-northeast-2'
  AWS_ACCESS_KEY_ID = Rails.application.credentials[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials[:secret_access_key]

  def initialize
    s3 = Aws::S3::Resource.new(region: AWS_REGION,
                               access_key_id: AWS_ACCESS_KEY_ID,
                               secret_access_key: AWS_SECRET_ACCESS_KEY)
    @bucket = s3.bucket('foremessage')
  end

  def upload_image(image)
    obj = @bucket.object("uploads/#{image.data['baseName']}t.png")
    obj.upload_file(File.open(image.tempfile), acl:'public-read')

    Rails.logger.debug "#{image.data['baseName']}"
    obj.public_url
  end
end