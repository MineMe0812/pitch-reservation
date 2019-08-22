# frozen_string_literal: true

class BlackoutUpdater
  # Service Object to update blackouts in the blackouts controller
  def initialize(blackout:, params:)
    @blackout = blackout
    @blackout.assign_attributes(params)
  end

  def update
    return { result: nil, error: check_for_conflicts } if check_for_conflicts
    update_handler
  end

  private

  attr_reader :blackout

  def check_for_conflicts
    return unless conflicts.any?
    error_string
  end

  def conflicts
    @conflicts ||= Reservation.affected_by_blackout(@blackout).active
  end

  def error_string
    'The following reservation(s) will be unable to be returned: '\
    "#{conflicts_string}. Please update their due dates and try again."
  end

  def conflicts_string
    excess_chars = 2
    s = ''
    conflicts.each do |conflict|
      s = "#{conflict.md_link}, "
    end
    s[0...-excess_chars]
  end

  def update_handler
    if @blackout.save
      { result: 'Blackout was successfully updated.', error: nil }
    else
      { result: nil, error: @blackout.errors.full_messages }
    end
  end
end
