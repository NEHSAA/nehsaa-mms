class SecurityIdValidator < ActiveModel::EachValidator
  SID_REGEXP = /\A([A-Z])(\d{9})\z/
  SID_FIRST = {
    'A' => '10', 'B' => '11', 'C' => '12', 'D' => '13', 'E' => '14',
    'F' => '15', 'G' => '16', 'H' => '17', 'I' => '34', 'J' => '18',
    'K' => '19', 'L' => '20', 'M' => '21', 'N' => '22', 'O' => '35', 
    'P' => '23', 'Q' => '24', 'R' => '25', 'S' => '26', 'T' => '27',
    'U' => '28', 'V' => '29', 'W' => '32', 'X' => '30', 'Y' => '31', 
    'Z' => '33'
  }
  SID_PEPPER = [1,9,8,7,6,5,4,3,2,1,1]
  SID_REGEXP_2 = /\A([A-Z])([ABCD])(\d{8})\z/

  def self.valid?(value)
    seq = if m = SID_REGEXP.match(value)
            SID_FIRST[m[1]] + m[2]
          elsif m = SID_REGEXP_2.match(value)
            SID_FIRST[m[1]] + SID_FIRST[m[2]][-1,1] + m[3]
          end
    if seq
      seq2 = [seq.each_char.to_a, SID_PEPPER].transpose
      num = seq2.reduce(0){|m,i| m + i[0].to_i * i[1] }
      (num % 10 == 0)
    else
      false
    end
  end

  def validate_each(record, attribute, value)
    record.errors.add(attribute, :invalid) unless SecurityIdValidator.valid?(value)
  end

end
