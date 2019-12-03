class AllotedNumber < ApplicationRecord

  validates_presence_of :first_name, :last_name
  validates_format_of :number, :with =>  /\d[0-9]\)*\z/ , :message => "Only positive number are allowed", allow_blank: true
  validate :valid_number

  before_validation :strip_dash_from_number
  before_create :check_availability_and_assign_number

  def check_availability_and_assign_number
    if self.number && (AllotedNumber.pluck(:number).include? self.number)
      self.number = nil
      get_available_number
    end
  end

  def strip_dash_from_number
    self.number = self.number.gsub('-', '').gsub(' ', '') if self.number
  end

  def valid_number
    return true unless self&.number
    if self.number < 1111111111 && self.number > 9999999999
      errors.add(:number, "Please enter a valid number('111-111-1111' - '999-999-9999')")
    end
  end

  def get_available_number
    alloted_numbers = AllotedNumber.pluck(:number)
    self.number = subscriber_number(alloted_numbers)
  end

  def subscriber_number(alloted_numbers)
    errors.add(:number, "All numbers are alloted!") and return if AllotedNumber.count >= 8888888889
    random_number = nil
    loop do
      random_number = rand(1111111111...9999999999).to_s
      break unless alloted_numbers.include?(random_number)
    end
    random_number
  end
end
