module OldWorld
  class Migrator

    attr_reader :timestamp
    attr_reader :output_root

    OldMember = ::OldWorld::Member
    NewMember = ::Member

    def initialize
      @timestamp = Time.now.strftime('%Y%m%d%H%M%S%L')
      @output_root = Rails.root.join('db/backup/old_world', timestamp)
      FileUtils.mkdir_p output_root
    end

    def open_and_write_csv(path)
      CSV.open(path, "wb") do |csv|
        csv << %w(編號 姓名 畢業最高部別 畢業屆別 畢業年 會員類別 學號 出生日期 身分證統一編號 性別 戶籍地址 連絡電話 Email 職業 服務機關 最高學歷 Facebook帳號 申請日期 更新日期 2012年會費 婚姻狀況 註解 登記會員 工作人員 理監事 是否當年會員 會籍年份)
        yield csv
      end
    end

    def member_to_csv_row(member)
      has_membership = member.membership?
      member = convert_member(member) unless member.is_a? NewMember
      row = []
      row << member.id
      row << member.name
      row << (member.grad_department && member.grad_department.text)
      row << member.grad_class
      row << member.grad_year
      row << (member.member_type && member.member_type.text)
      row << member.grad_id
      row << member.birthdate
      row << member.security_id
      row << (member.gender && member.gender.text)
      row << member.address
      row << member.phones.join(',')
      row << member.emails.join(',')
      row << member.occupation
      row << member.company
      row << member.education
      row << member.facebook
      row << '' # 申請日期
      row << '' # 更新日期
      row << '' # 2012會費
      row << '' # 婚姻狀況
      row << member.errors.full_messages.join('; ') # comment
      row << '' # 登記會員
      row << '' # 工作人員
      row << '' # 理監事
      row << (has_membership ? 'true' : 'false') # 是否當年會員
      row << member.memberships.map(&:year).join('; ') # 會籍年份
      row
    end

    def convert_member(member)
      new_member = NewMember.new({
        name: member.name,
        birthdate: member.birthday,
        security_id: member.national_identification_number,
        gender: member.gender_id,
        member_type: member.kind_id,
        permanent: !!member.is_lifelong
      })
      member.graduations.each do |g|
        new_member.grad_class = g.class_number
        new_member.grad_year = g.year
        new_member.grad_id = g.school_number
        new_member.grad_department = g.department_id
      end
      member.payments.each do |p|
        new_member.memberships.build({
          year: p.membership_year
        })
      end
      new_member.emails = member.emails.each.map{|o| o.value }
      new_member.phones = member.phones.each.map{|o| o.value }
      new_member.address = member.addresses.each.map{|o| o.value }.join(';')
      new_member.facebook = member.facebook_accounts.each.map{|o| o.value }.join(';')
      new_member.occupation = member.occupations.each.map{|o| o.value }.join(';')
      new_member.company = member.organizations.each.map{|o| o.value }.join(';')
      new_member.education = member.educations.each.map{|o| o.value }.join(';')
      new_member
    end

    def puts_old_member(file, member, reason = nil)
      file.puts "#{member.id}, #{member.name}, #{member.membership?}, #{reason}"
    end

    def run
      # 1. Remove members without Security IDs
      open_and_write_csv(output_root.join('1-no-security-id.csv')) do |csv|
        OldMember.all.to_a.each do |member|
          if member.national_identification_number.blank?
            csv << member_to_csv_row(member)
            member.destroy
          end
        end
      end
      # 2. Remove members without birthdates
      open_and_write_csv(output_root.join('2-no-birthdate.csv')) do |csv|
        OldMember.all.to_a.each do |member|
          if member.birthday.blank?
            csv << member_to_csv_row(member)
            member.destroy
          end
        end
      end
      # 3. Sanitize Duplicate and merge members
      open(output_root.join('3-duplicates.txt'), 'w') do |file|
        OldMember.all.order(id: :desc).to_a.each do |member|
          query = OldMember.where national_identification_number: member.national_identification_number
          if query.count > 1
            file.puts "Member #{member.id}, #{member.name} has duplicates:"
            query.where.not(id: member.id).to_a.each do |m|
              puts_old_member(file, m)
              m.destroy
            end
          end
        end
      end
      # 4. List members with illformed security IDs
      open(output_root.join('4-illformed-security-id.txt'), 'w') do |file|
        OldMember.find_each(batch_size: 50) do |member|
          unless SecurityIdValidator.valid?(member.national_identification_number)
            puts_old_member(file, member)
          end
        end
      end
      # 5. Remove members with some illegal or missed data
      open_and_write_csv(output_root.join('5-other-field.csv')) do |csv|
        OldMember.find_each(batch_size: 50) do |member|
          new_member = convert_member(member)
          if new_member.valid?
            new_member.save!
          else
            csv << member_to_csv_row(new_member)
          end
        end
      end
    end

  end
end
