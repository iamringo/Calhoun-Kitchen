class AppMailer < ActionMailer::Base

  def reservation_notification(reservation)
     recipients User.admins.collect {|u| u.email}
     from       "calhounkitchen@gmail.com"
     subject    "New Reservation"
     body       :reservation => reservation
   end

    def reservation_approved_notification(reservation)
     recipients reservation.renter.email
     from       "calhounkitchen@gmail.com"
     subject    "Reservation Approved"
     body       :reservation => reservation
   end

    def reservation_changed_notification(reservation)
     recipients User.admins.collect {|u| u.email}
     from       "calhounkitchen@gmail.com"
     subject    "Reservation Changed"
     body       :reservation => reservation
   end

end
