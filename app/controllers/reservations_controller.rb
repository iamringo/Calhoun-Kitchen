class ReservationsController < ApplicationController
before_filter :permission_check, :except => ['new', 'create', 'index']
  def index
    @reservations = Reservation.all
  end

  def show
    @reservation = Reservation.find(params[:id])
  end

  def new
    @current_user = current_user
    @reservation = Reservation.new
  end

  def create
    @current_user = current_user
    @reservation = Reservation.new(params[:reservation])
    @reservation.renter = current_user
    @reservation.manager = User.find(params[:reservation][:manager_id]) if @reservation.manager
    if @reservation.save
      AppMailer.deliver_reservation_notification!(@reservation)
      flash[:notice] = "Successfully created reservation. "
      flash[:notice] += "Please note that since your reservation is in less than 24 hrs, we cannot guarantee the kitchen." if @reservation.start_at < Time.now + 24.hours
      redirect_to root_url
    else
      render :action => 'new'
    end
  end

  def edit
    @current_user = current_user
    @reservation = Reservation.find(params[:id])
  end

  def update
    @current_user = current_user
    @reservation = Reservation.find(params[:id])
    if @reservation.update_attributes(params[:reservation])
      @reservation.manager = User.find(params[:reservation][:manager_id])
      @reservation.save
      flash[:notice] = "Successfully updated reservation."
      redirect_to @reservation
    else
      render :action => 'edit'
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:notice] = "Successfully destroyed reservation."
    redirect_to reservations_url
  end

private
  def permission_check
    unless current_user == Reservation.find(params[:id]).renter || current_user.admin
      flash[:notice] = "You do not have access to that page"
      redirect_to root_url
    end
  end
end
