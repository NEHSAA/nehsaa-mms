class MembersImportController < ApplicationController

  def index
  end

  def import
    uploaded = params[:file]
    @failed_members = []
    SmarterCSV.process(uploaded.path) do |chunk|
      chunk.each do |record|
        puts(record.inspect)
        sid = record[:'身分證字號']
        member = parse_record(record)
        begin
          #raise member.errors.inspect unless member.valid?
          member.save!
        rescue
          @failed_members << member
        end
      end
    end
    #redirect_to action: :index #, controller: 'members'
    render action: :index
  end

  def parse_record(record)
    member = Member.new
    member.name = record[:'姓名']
    member.security_id = record[:'身分證字號']
    member.birthdate = record[:'生日']
    member.gender = case record[:'性別']
                    when '男' then :male
                    when '女' then :female
                    end
    member.member_type = :normal_member
    member.permanent = false
    member.emails = Array(record[:'e-mail'])
    member.phones = Array(record[:'聯絡電話'])
    member.address = record[:'戶籍地址']
    member.occupation = record[:'職業']
    member.company = record[:'服務機關']
    member.education = record[:'最高學歷_(含學校系所)']
    member.facebook = record[:'facebook_帳號']
    member.grad_department = case record[:'畢業最高部別']
                             when '高中部' then :senior_high
                             when '國中部' then :junior_high
                             when '國小部' then :elementary
                             when '幼稚園部' then :kindergarten
                             when '雙語部' then :bilingual
                             end
    member.grad_year = record[:'畢業年']
    member.grad_class = record[:'畢業屆別']
    member.grad_id = record[:'學號']
    member
  end

end
