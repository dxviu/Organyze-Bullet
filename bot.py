import os
import discord
from discord.ext import commands

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
    
    e.add_field(name='Organyze::Bullet Command List', value = 'Type the syntax, e.g `o! help add`, or any labeled with __More Info:__ to display more information.', inline=False)
    e.add_field(name= 'o! add', value = "Add a task. More Info: `o! help add`. ", inline=False)
    e.add_field(name= 'o! delete', value = "Delete a task. More Info: `o! help delete`. ", inline=False)
    e.add_field(name= 'o! edit', value = "Edit a task/timer/event. More Info: `o! help edit`. ", inline=False)
    e.add_field(name= 'o! help', value = "Display the Command list.", inline=False)

    await ctx.send(embed=e)


bot.run(token)