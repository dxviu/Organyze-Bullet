import os
import discord
from discord.ext import commands
import uuid

token = os.environ['organyze_token']
version_num = '0.0.1'
description = f'''**Organyze::Bullet - A structured, fun approach to bullet journaling on Discord.**
Version {version_num} | Powered by discord.py
'''
 
prefix = 'o! '

intents = discord.Intents.all()

#help_command=None removes the default help
bot = commands.Bot(command_prefix=prefix, description=description, intents=intents,  help_command=None)


bullet_key = {"info": "-", "task": "*", "event": "o", "started": "/", "complete": "X"}

task_dictionary = dict()

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name} ({bot.user.id})!')
    print('------')

@bot.command()
async def about(ctx):
    """About this bot"""
    await ctx.send(description)

@bot.command()
async def help(ctx):
    # author = ctx.message.author // to send as DM -> await author.send(embed=embed)
    
    e = discord.Embed(
      color = discord.Color.dark_gold()
    )
    
    e.add_field(name='Organyze::Bullet Command List', value = 'Type the syntax, e.g `o! help create`, or any labeled with __More Info:__ to display more information.', inline=False)
    e.add_field(name= 'o! create', value = "Create a new entry. More Info: `o! help add`. ", inline=False)
    e.add_field(name= 'o! delete', value = "Delete an entry. More Info: `o! help delete`. ", inline=False)
    e.add_field(name= 'o! edit', value = "Edit an entry/timer/event. More Info: `o! help edit`. ", inline=False)
    e.add_field(name= 'o! help', value = "Display the Command list.", inline=False)

    await ctx.send(embed=e)

@bot.command()
async def create(ctx, entry_type: str, description: str):
    # o! create event "Test event"
    entry = ""
    if entry_type in bullet_key.keys():
        entry += bullet_key[entry_type]
    entry += " "
    entry += description
    entry_id = str(uuid.uuid4())
    task_dictionary[entry_id] = entry
    response = f"Added the {entry_type}: {description}"
    await ctx.send(response)

@bot.command()
async def delete(ctx, delete_id: str):
  for i in task_dictionary.keys():
    if delete_id == i:
      deleted_entry = task_dictionary.pop(delete_id)
      await ctx.send(f"Deleted entry: {deleted_entry}")

@bot.command()
async def list_entries(ctx):
  response = f"Listing all entries\n"
  for value in task_dictionary:
    response += f"{task_dictionary[value]} ({value})\n"
  await ctx.send(response)

bot.run(token)