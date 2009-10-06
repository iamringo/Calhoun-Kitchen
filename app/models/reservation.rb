class Reservation < ActiveRecord::Base
  attr_accessible :renter, :manager, :start_at, :end_at, :color
  has_event_calendar
  belongs_to :renter, :class_name => "User"
  belongs_to :manager, :class_name => "User"
  before_save :set_color
  validate :start_at_before_end_at
  validate :not_in_the_past
  validate_on_create :no_overlap

private
  def set_color
    if self.manager
      self.color = self.manager.color
    else
      self.color = "#ff0505"
    end
  end

  def not_in_the_past
    errors.add_to_base("Can't sign up for a time that has already passed!") if self.start_at <= Time.now
  end

  def start_at_before_end_at
    errors.add(:start_at, "must be earlier than end time") if (self.end_at <= self.start_at)
  end

  def no_overlap
    #inefficient as hell, but I am tired.
    c = Reservation.all.select{|s| s.start_at < self.end_at && s.end_at > self.start_at}.length
    errors.add_to_base("That time overlaps with someone else's reservation!") unless c.zero?
  end
end
