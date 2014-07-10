class Blackout < ActiveRecord::Base

  belongs_to :equipment_model
  attr_accessible :start_date, :end_date, :notice, :equipment_model_id, :blackout_type, :created_by, :set_id

  attr_accessor :days # needed for days of the week checkboxes in new_recurring

  validates :notice,
            :start_date,
            :equipment_model_id,
            :blackout_type,
            :end_date, presence: true

  validate :validate_end_date_before_start_date
  # this only matters if a user tries to inject into params because the datepicker
  # doesn't allow form submission of invalid dates

  scope :active, where("end_date >= ?", Date.today)
  scope :for_date, lambda { |date| where("end_date >= ? and start_date <= ?", date, date) }
  scope :hard, where(blackout_type: 'hard')
  scope :soft, where(blackout_type: 'notice only')

  #def self.blackouts_on_date(date)

  #def self.hard_blackout_exists_on_date(date)

  def self.create_blackout_set(params_hash)
    #generate a unique id for this blackout date set, make sure that nil reads as 0 for the first blackout
    last_blackout = Blackout.last
    params_hash[:set_id] = last_blackout ? (last_blackout.id.to_i + 1) : 0

    successful_save = nil
    date_range = params_hash[:start_date].to_date..params_hash[:end_date].to_date
    date_range.each do |date|
      if params_hash[:days].include?(date.wday.to_s) # because it's passed as a string
        @blackout = Blackout.new(params_hash.except(:days))
        @blackout.start_date = date
        @blackout.end_date = date
        successful_save = @blackout.save
      end
    end
    unless successful_save
      return 'The combination of days and dates chosen did not produce any valid blackout dates. Please change your selection and try again.'
    end
  end

  private

    def validate_end_date_before_start_date
      if end_date && start_date
        errors.add(:end_date, "Start date must be before end date.") if end_date < start_date
      end
    end

  # end private methods
end

