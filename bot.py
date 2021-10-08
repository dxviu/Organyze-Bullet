import os
import discord
from discord.ext import commands

token = os.environ['organyze_token']
version_num = '0.0.1'
description = f'''Organyze::Bullet - A structured, fun approach to bullet journaling on Discord.
Version {version_num} | Powered by discord.py
'''
DEFAULT_PREFIX = 'org!'
prefix = DEFAULT_PREFIX

intents = discord.Intents.all()

bot = commands.Bot(command_prefix=prefix, description=description, intents=intents)

bullet_key = {"info": "-", "task": "*", "event": "o", "started": "/", "complete": "X"}

@bot.event
async def on_ready():
    print(f'Logged in as {bot.user.name} ({bot.user.id})!')
    print('------')

@bot.command()
async def about(ctx):
    """About this bot"""
    await ctx.send(description)

bot.run(token)
