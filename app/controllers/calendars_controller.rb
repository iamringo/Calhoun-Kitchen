class CalendarsController < ApplicationController

  def index
    @month = params[:month].to_i
    @year = params[:year].to_i

    @shown_month = Date.civil(@year, @month)

    @event_strips = Reservation.event_strips_for_month(@shown_month)
  end
end
