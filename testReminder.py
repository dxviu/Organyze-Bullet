import os
import discord
from discord.ext import commands
import uuid
# import firebase_admin as fa
import json
import aiohttp
import datetime
import asyncio 











@bot.command()
async def remind(ctx, time, *, task_id):
  def convert(time):
    time_value = ['s', 'm', 'h', 'd']

    time_dict = {"s": 1, "m": 60, "h": 3600, "d": 3600*24}

    unit = time[-1]

    if unit not in time_value:
      return -1
    try:
      user_input = int(time[:-1])
    except:
      return -2
 
    return user_input * time_dict[unit]  #returns reminder time
 
   
  converted_time = convert(time)
  
  
  if converted_time == -1:
    await ctx.send("Error. You did not enter the time correctly.")
    return
  
  if converted_time == -2:
    await ctx.send("Error, the time must be an integer.")

  await ctx.send(f"{time} reminder set for **{task_id}**.")
  await asyncio.sleep(converted_time)
  await ctx.send(f"{ctx.author.mention} this is your reminder for **{task_id}**.")