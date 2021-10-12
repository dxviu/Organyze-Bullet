import os
import discord
from discord.ext import commands
import uuid

class Entry:
  def __init__(self, type, description):
    self.type = type
    self.bulletType()
    self.description = description 

  #function to create correct bullet point  
  def bulletType(self):

    if self.type == '*':
      self.type = '•'
    elif self.type == 'o':
      self.type = '○'
    else:
      self.type = '-'

 #Function to create random + unique ID
  def uniqueID(self):
    self.id = uuid.uuid4()
    str(self.id)

  def displayTask(self):
    print("Task type: ", self.type)
    print("Task description: ", self.description)

def delete(self, list, ID):
  for i in list:
    if self.id == ID:
      del object


@bot.command()
async def create(ctx, type: str, description: str):
  await 





  

  




