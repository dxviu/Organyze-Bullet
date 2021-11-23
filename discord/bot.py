import os
import dateutil
import nextcord
from nextcord.ext import commands
import uuid
# import firebase_admin as fa
import json
import aiohttp
import datetime
import asyncio
import bulletentry as entry
from notification import notification
from dateutil import parser, tz
from typing import List, Tuple, Optional

token = os.environ['organyze_token']
version_num = '0.1.0'
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
intents = nextcord.Intents.all()

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

    e = nextcord.Embed(color=nextcord.Color.dark_gold())

    e.add_field(
        name='Organyze::Bullet Command List',
        value=
        'Type the syntax, e.g `o! help create`, or any labeled with __More Info:__ to display more information.',
        inline=False)
    e.add_field(name='o! create <entryType> "<description>"',
                value="Create a new entry. More Info: `o! help create`.",
                inline=False)
    e.add_field(
        name='o! delete <ID>',
        value="Delete an entry by its ID. More Info: `o! help delete`.",
        inline=False)
    e.add_field(
        name='o! status <entryType>',
        value="Change the status of an entry. More Info: `o! help status`.",
        inline=False)
    e.add_field(
        name='o! list',
        value="List all entries of a notebook. More Info: `o! help list`.",
        inline=False)
    e.add_field(name='o! help',
                value="Display the Command list.",
                inline=False)

    await ctx.send(embed=e)

class createFlags(commands.FlagConverter, case_insensitive=True):
    named: str
    description: Optional[str]
    due: Optional[str]
    bullet: Optional[str]
    parent: Optional[str]
    assigned: Optional[Tuple[nextcord.Member, ...]]

@bot.command()
async def create(ctx, entry_type: str, *, flags: createFlags):
    # o! create event "Test event"
    # Alias for info
    if entry_type == "note":
        entry_type = "info"
    if entry_type in bullet_key.keys():
        b_factory = entry.BulletFactory()
        # Parents/Children NYI
        en = b_factory.create_bullet(flags.named, entry_type, flags.description, flags.due, flags.assigned, None, None, None, flags.bullet)
        payload = en.get_JSON_payload()
        # entry_dict = {}
        # entry_dict["type"] = entry_type
        # entry_dict["name"] = name
        # entry_dict["timestamp"] = datetime.datetime.now().replace(
        #     tzinfo=datetime.timezone.utc).timestamp()
        # entry_dict["due_date"] = dateutil.parser.parse(flags.due).replace(
        #     tzinfo=datetime.timezone.utc).timestamp() if flags.due else None
        # payload = json.dumps(entry_dict, separators=(',', ':'))
        async with aiohttp.ClientSession() as session:
            async with session.post(db_ref, data=payload) as r:
                server_json = await r.json()
                created_id = server_json["name"]
                response = "Got it!\nAdded your "
                response += entry_type
                response += ' "{}" to your **Test** notebook.\n'.format(
                    flags.named)
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
                response += f"{server_json[e]['bullet_char'] if 'bullet_char' in server_json[e].keys() else bullet_key[server_json[e]['type']]} {server_json[e]['name']} ({e})\n"
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


@bot.command()
async def test(ctx, members: commands.Greedy[nextcord.Member]):
    await ctx.send("enter time")
    time = await bot.wait_for('message')

    await ctx.send("enter id")
    id = await bot.wait_for('message')

    notify = notification(time, id)
    

    members = ", ".join(x.mention for x in members)


    async with aiohttp.ClientSession() as session:
        target_ref = f"{db_ref[:-5]}/{id.content}.json"
        async with session.get(target_ref) as r:
            if r.status == 200:
                server_json = await r.json()
                task_description = server_json["name"]
                # await ctx.send(f"found the {task_description}.")
            else:
                ctx.send(f"{id.content} does not exist on the server.")

            #converted_time = convert(time.content)

            #if converted_time == -1:
            #await ctx.send("Error. You did not enter the time correctly.")
            #retur n

            #if converted_time == -2:
            #await ctx.send("Error, the time must be an integer.")

            response = f"{notify.time.content} reminder set for **{task_description}**."
            await ctx.send(response)
            await ctx.send(f"remaining seconds until task {notify.seconds_until_notification.content}")
            await asyncio.sleep(notify)
            await ctx.send('{} this is the reminder for {}'.format(members, task_description))
            




@bot.command()
async def remind2(ctx, member: nextcord.Member):

    mentionMember = member.mention

    await ctx.send("enter time")
    time = await bot.wait_for('message')

    await ctx.send("enter id")
    id = await bot.wait_for('message')
    

    #await ctx.send(f'the member is {mentionMember}')
    async with aiohttp.ClientSession() as session:
        target_ref = f"{db_ref[:-5]}/{id.content}.json"
        async with session.get(target_ref) as r:
            if r.status == 200:
                server_json = await r.json()
                task_description = server_json["name"]
                # await ctx.send(f"found the {task_description}.")
            else:
                ctx.send(f"{id.content} does not exist on the server.")

            converted_time = convert(time.content)

            #if converted_time == -1:
            #await ctx.send("Error. You did not enter the time correctly.")
            #retur n

            #if converted_time == -2:
            #await ctx.send("Error, the time must be an integer.")

            response = f"{time.content} reminder set for **{task_description}**."
            await ctx.send(response)
            await asyncio.sleep(converted_time)
            await ctx.send(
                f"{mentionMember}, this is your reminder for **{task_description}**."
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
