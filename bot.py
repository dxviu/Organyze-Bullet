import os
import discord
from discord.ext import commands
import uuid
# import firebase_admin as fa
import json
import aiohttp
import datetime
import asyncio
import bulletentry

token = os.environ['organyze_token']
version_num = '0.0.3'
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
    e.add_field(
        name='o! list',
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


@bot.command(name="status")
async def set_status(ctx, e_id: str, entry_type: str):
    if entry_type in bullet_key.keys():
        async with aiohttp.ClientSession() as session:
            target_ref = f"{db_ref[:-5]}/{e_id}.json"
            async with session.get(target_ref) as r:
                if r.status == 200:
                    server_json = await r.json()
                    server_json["type"] = entry_type
                    payload = json.dumps(server_json, separators=(',', ':'))
                    await session.patch(target_ref, data=payload)
                    await ctx.send(f"Set {e_id} to {entry_type}.")
                else:
                    ctx.send(f"{e_id} does not exist on the server.")
    else:
        ctx.send("""Invalid format.
Syntax: `o!status <entryID> <entryType>`
Entries can be one of the following: info, task, event, started, complete.""")


# naive implementation
@bot.command(name="complete")
async def set_complete(ctx, e_id: str):
    await set_status(ctx, e_id, "complete")


@bot.command()
async def remind(ctx, time, *, task_id):
    async with aiohttp.ClientSession() as session:
        target_ref = f"{db_ref[:-5]}/{task_id}.json"
        async with session.get(target_ref) as r:
            if r.status == 200:
                server_json = await r.json()
                task_description = server_json["name"]
                # await ctx.send(f"found the {task_description}.")
            else:
                ctx.send(f"{task_id} does not exist on the server.")

            converted_time = convert(time)

            #if converted_time == -1:
            #await ctx.send("Error. You did not enter the time correctly.")
            #return

            #if converted_time == -2:
            #await ctx.send("Error, the time must be an integer.")

            response = f"{time} reminder set for **{task_description}**."
            await ctx.send(response)
            await asyncio.sleep(converted_time)
            await ctx.send(
                f"{ctx.author.mention}, this is your reminder for **{task_description}**."
            )


def convert(time):
    time_value = ['s', 'm', 'h', 'd']

    time_dict = {"s": 1, "m": 60, "h": 3600, "d": 3600 * 24}

    unit = time[-1]

    if unit not in time_value:
        return -1
    try:
        user_input = int(time[:-1])
    except:
        return -2

    return user_input * time_dict[unit]  #returns reminder time


bot.run(token)
