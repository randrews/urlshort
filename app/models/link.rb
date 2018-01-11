class Link < ApplicationRecord
  validates(:code, presence: true)
  validates(:url, presence: true, uniqueness: true)
  before_validation(:set_code)

  private

  def set_code
    self.code = generate_code if code.blank?
  end

  def generate_code
    code = Digest::MD5.hexdigest(SecureRandom.uuid)[0..7]
    return code unless self.class.find_by(code: code)
    generate_code
  end
end
