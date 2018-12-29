class S3Service
  AWS_REGION = 'ap-northeast-2'
  AWS_BUCKET_NAME = 'foremessage'
  AWS_ACCESS_KEY_ID = Rails.application.credentials[:access_key_id]
  AWS_SECRET_ACCESS_KEY = Rails.application.credentials[:secret_access_key]
  AWS_IMAGE_DIRECTORY = 'uploads'

  def initialize
    s3 = Aws::S3::Resource.new(region: AWS_REGION,
                               access_key_id: AWS_ACCESS_KEY_ID,
                               secret_access_key: AWS_SECRET_ACCESS_KEY)
    @bucket = s3.bucket(AWS_BUCKET_NAME)
  end

  def upload_image(image, file_name)
    obj = @bucket.object("#{AWS_IMAGE_DIRECTORY}/#{file_name}")
    obj.upload_file(File.open(image.tempfile), acl:'public-read')

    obj.public_url
  end

  def delete_image(file_name)
    @bucket.object("#{AWS_IMAGE_DIRECTORY}/#{file_name}").delete
  end
end