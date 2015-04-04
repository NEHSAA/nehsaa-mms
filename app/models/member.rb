class Member < ActiveRecord::Base
  extend Enumerize

  # Name
  validates :name, presence: true

  # Security ID
  validates :security_id, presence: true,
                          uniqueness: true,
                          security_id: true

  # Birthdate
  validates :birthdate, presence: true

  # Gender
  enumerize :gender, in: { male: 1, female: 2, other: 3 }
  validates :gender, presence: true

  # Member Type & Permanent
  enumerize :member_type, in: {
    normal_member: 1,
    teacher_member: 2,
    honor_member: 3
  }
  validates :member_type, presence: true
  validates :permanent, inclusion: { in: [true, false] }

  # Email
  validates :emails, presence: true
  validates_each :emails do |record, attribute, value|
    unless value.map{|v| ValidateEmail.valid?(v) }.reduce(:&)
      record.errors.add attribute, I18n.t(:invalid, :scope => "valid_email.validations.email")
    end
  end

  # Phone
  validates :phones, presence: true

  # Address
  validates :address, presence: true

  # Other Basic Info
  validates :occupation, :company, :education,
            { presence: true }
  # facebook can be blank

  # Association: memberships
  has_many :memberships, dependent: :delete_all

  # Graduation Information
  enumerize :grad_department, in: {
    kindergarten: 1,
    elementary: 2,
    junior_high: 3,
    senior_high: 4,
    bilingual: 5
  }
  # grad_class
  # grad_year
  # grad_id

  before_validation do
    emails.map!(&:strip).reject!(&:blank?)
    phones.map!(&:strip).reject!(&:blank?)
  end

  def age(date = Date.today)
    date.year - birthdate.year
  end

  def membership?(date = Date.today)
    flag = memberships.count > 0
    if flag
      flag = memberships.order(year: :asc).last.year >= (date.year - 2)
    end
    valid? && (age(date) < 20 || flag || permanent)
  end

end
