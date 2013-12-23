CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
  else
    config.storage :fog
  end
end

module CarrierWave::Uploader
  module EnvironmentStorage
    def self.for(environment)
      environment == 'production' ? :fog : :file
    end
  end
end
