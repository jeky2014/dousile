module ApplicationHelper
  
  def showdate(pubtime)
    pubtime.in_time_zone(+8.hours).strftime('%Y-%m-%d')
  end
  
  def showtime(pubtime)
    pubtime.in_time_zone(+8.hours).strftime('%Y-%m-%d %H:%M:%S')
  end
  
end
