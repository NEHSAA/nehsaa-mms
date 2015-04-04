module OldWorld
  class Member < Base

    belongs_to :gender
    belongs_to :kind

    %w(emails phones addresses facebook_accounts
       educations organizations occupations
    ).each {|name|
      class_eval <<-RUBY
        class #{name.classify} < Base
          belongs_to :member
        end
        has_many :#{name}, dependent: :destroy
      RUBY
    }
    
    has_many :graduations, dependent: :destroy
    has_many :payments, dependent: :destroy#, order: 'membership_year ASC'

    def age
      2014 - self.birthday.year
    end

    def membership?(year = 2014)
      return false if birthday.blank?
      return true if age < 20 || is_lifelong
      return false if payments.count < 1
      payments.order(membership_year: :asc).last.membership_year >= (year-2)
    end

  end
end
