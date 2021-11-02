import os
import discord
from discord.ext import commands
import uuid
# import firebase_admin as fa
import json
import aiohttp
import datetime

token = os.environ['organyze_token']
version_num = '0.0.2'
description = f'''**Organyze::Bullet - A structured, fun approach to bullet journaling on Discord.**
Version {version_num} | Powered by discord.py
'''

# cred_file = json.loads(os.environ['fa_creds'])
# cred_obj = fa.credentials.Certificate(cred_file)
# firebase_app = fa.initialize_app(cred_obj, {
# 	'databaseURL': 'https://organyze-bullet-default-rtdb.firebaseio.com/'
#	})

firebase_key = os.environ['firebase_key']

# hardcoded for demo
db_ref = "https://organyze-bullet-default-rtdb.firebaseio.com/Users/-MnT6JQIenweIdXRoH8d/Notebooks/Demo/entries.json"

prefix = 'o! '
intents = discord.Intents.all()

#help_command=None removes the default help
bot = commands.Bot(command_prefix=prefix,
                   description=description,
                   intents=intents,
                   help_command=None)

bullet_key = {
    "info": "-",
    "task": "•",
    "event": "○",
    "started": "/",
    "complete": "X"
}

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

    e = discord.Embed(color=discord.Color.dark_gold())

    e.add_field(
        name='Organyze::Bullet Command List',
        value=
        'Type the syntax, e.g `o! help create`, or any labeled with __More Info:__ to display more information.',
        inline=False)
    e.add_field(name='o! create',
                value="Create a new entry. More Info: `o! help create`. ",
                inline=False)
    e.add_field(name='o! delete',
                value="Delete an entry. More Info: `o! help delete`. ",
                inline=False)
    e.add_field(name='o! edit',
                value="Edit an entry/timer/event. More Info: `o! help edit`. ",
                inline=False)
    e.add_field(name='o! list',
                value="List all entries of a notebook. More Info: `o! help edit`. ",
                inline=False)
    e.add_field(name='o! help',
                value="Display the Command list.",
                inline=False)

    await ctx.send(embed=e)


@bot.command()
async def create(ctx, entry_type: str, description: str):
    # o! create event "Test event"
    if entry_type in bullet_key.keys():
        entry_dict = {}
        entry_dict["type"] = entry_type
        entry_dict["name"] = description
        entry_dict["timestamp"] = datetime.datetime.now().timestamp()
        entry_dict["due_date"] = None
        payload = json.dumps(entry_dict, separators=(',', ':'))
        async with aiohttp.ClientSession() as session:
            async with session.post(db_ref, data=payload) as r:
                server_json = await r.json()
                created_id = server_json["name"]
                response = "Got it!\nAdded your "
                response += entry_type
                response += ' "{}" to your **Test** notebook.\n'.format(
                    description)
                response += f"*ID: {created_id}*"
                await ctx.send(response)
    else:
        await ctx.send("""Invalid format.
Syntax: `o!create <entryType> <description>`
Entries can be one of the following: info, task, event, started, complete.""")


@bot.command()
async def delete(ctx, delete_id: str):
    async with aiohttp.ClientSession() as session:
        async with session.get(db_ref) as r:
            server_json = await r.json()
            if delete_id in server_json.keys():
                delete_ref = f"https://organyze-bullet-default-rtdb.firebaseio.com/Users/-MnT6JQIenweIdXRoH8d/Notebooks/Demo/entries/{delete_id}.json"
                await session.delete(delete_ref)
                await ctx.send(f"Deleted entry {delete_id}.")


@bot.command(name="list")
async def list_entries(ctx):
    response = "__Notebook: **Test**__\n"
    async with aiohttp.ClientSession() as session:
        async with session.get(db_ref) as r:
            server_json = await r.json()
            ordered_entries = sorted(server_json,
                                     key=lambda x:
                                     (server_json[x]['timestamp']))
            for e in ordered_entries:
                response += f"{bullet_key[server_json[e]['type']]} {server_json[e]['name']} ({e})\n"
    await ctx.send(response)


bot.run(token)
