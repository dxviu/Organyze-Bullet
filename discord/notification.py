from datetime import datetime
from dateutil import parser, tz


class Notification:
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
        self.time = parsed_time             #store the parsed_time as reference before converting it to timestamp
        parsed_time = parsed_time.replace(
        tzinfo=datetime.timezone.utc).timestamp()
    
        return parsed_time

    def calculate_time_difference(self):        #This function will return time difference between notifciation

        currentTimestamp = self.time.time()            #time and current time (UTC). This will be used for the                                                              asyncio.sleep method found in the notify method
        timeDelta = self.time - currentTimestamp  
        return timeDelta

    def notify(self, time: float, task_id: str, target: list=None):
      notification_timestamp = get_time(time)                       
      seconds_until_notification = calculate_time_difference()

      if target is None:
        return seconds_until_notification
      


      """"
        notification_timestamp = get_time(time)                       
        seconds_until_notification = calculate_time_difference()

        members = ", ".join(x.mention for x in target)      #formmatted to mention each target that was entered
        
        async with aiohttp.ClientSession() as session:
            target_ref = f"{db_ref[:-5]}/{task_id}.json"
            async with session.get(target_ref) as r:
                if r.status == 200:
                    server_json = await r.json()
                    task_description = server_json["name"]
                else:
                    ctx.send(f"{task_id} does not exist on the server.")


                await ctx.send('{} setting reminder for {} on {}'.format(members, task_description, self.time))
                await asyncio.sleep(seconds_until_notification)
                await ctx.send('{} this is the reminder for {}'.format(members, task_description))  
      """"

  

  

    

    





    

    
      
            

    

    

    
