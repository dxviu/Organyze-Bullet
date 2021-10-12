import uuid

class task(object):

  def __init__(self):
    print("adding a task object")
    self.uniqueID()
    self.type = 'task'
    self.status = 'incomplete'
    self.dueDate = 'not available'
    self.description = 'not available'
    self.comment = 'not available' 

  def enterData(self):
    self.type = str(input("What is the type? Enter '*' for task, 'o' for event or '-' for note: "))
    self.bulletType()
    self.status = str(input("is the task complete or incomplete: "))
    self.dueDate = str(input("optional: enter due date: "))
    self.description = str (input("enter task content/description: "))
    self.comment = str (input("Optional: enter any comments: "))

    print(" ")

  
  #Function to create random + unique ID
  def uniqueID(self):
    self.id = uuid.uuid4()
    str(self.id)

  #function to create correct bullet point  
  def bulletType(self):

    if self.type == '*':
      self.type = '•'
    elif self.type == 'o':
      self.type = '○'
    else:
      self.type = '-'

  def displayTask(self):
    print("Task type: ", self.type)
    print("Task status: ", self.status)
    print("Task due date: ", self.dueDate)
    print("Task description: ", self.description)
    print("Task comment: ", self.comment)
    print("Task ID: ", self.id)

def delete(self, list, ID):
  for i in list:
    if self.id == ID:
      del object

  




#create an object list and load task objects to the list
taskList = []

for i in range(2):
  test = task()
  test.enterData()
  taskList.append(test)

#print all task objects from list
for task in taskList:
  print("---------------------------------")
  task.displayTask()
  print("---------------------------------")

