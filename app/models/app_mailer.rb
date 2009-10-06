class AppMailer < ActionMailer::Base

  def reservation_notification(reservation)
     recipients User.admins.collect {|u| u.email}
     from       "calhounkitchen@gmail.com"
     subject    "New Reservation"
     body       :reservation => reservation
   end

end
