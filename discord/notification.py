from datetime import datetime
from dateutil import parser, tz


class notification:
    """
     In a context menu next to a bullet in a notebook, or by using a Discord bot command, a user can specify how they would like to be reminded (via Push Notifications, a connected Discord Bot, or through a collaborator). Users can assign multiple reminders to a bullet.
     
    :param target: The target for the notification
    :type target: list

    :param time: The notification time as a POSIX timestamp.
    :type time: float

    :param task_id: The ID number associated with the task.
    :type task_id: str

    :param notif_id: The ID number associated with the notification
    :type notif_id: str

    
    """

    def __init__(self, time: float, task_id: str, target: list=None):
        self.time = time
        self.task_id = task_id
        self.target = target
      
    def get_time(self, time: float):
        parsed_time = parser.parse(time)
        parsed_time = parsed_time.replace(
        tzinfo=datetime.timezone.utc).timestamp()
    
        return parsed_time

    def calculate_time_difference(self):        
        currentTimestamp = self.time.time()            #time and current time (UTC). This will be used for the                                                              asyncio.sleep method found in the notify method
        timeDelta = self.time - currentTimestamp  
        return timeDelta

    def convert_time(self, date: float):
      #will input date/time from user and return readable date time
      date_stamp = parser.parse(date)
      return date_stamp

    def current_datetime(self):
        timestamp = self.time.time()       
        date_time = datetime.fromtimestamp(timestamp)
        return date_time


    def notify(self, time: float, task_id: str, target: list=None):
        notification_timestamp = self.get_time(time)                       
        seconds_until_notification = self.calculate_time_difference()

        if target is None:
            return seconds_until_notification
      

    


    

  

  

    

    





    

    
      
            

    

    

    
