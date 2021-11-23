import datetime
import hashlib
import json
import dateutil
from dateutil.tz import gettz

tzinfos = {
    "EDT": gettz("America/Detroit")
}


class BulletEntry:
    """
    A notebok bullet entry. Entries are the building blocks of a notebook.
    :param entry_id: The unique identifier of the entry. This is a SHA256 hash of the entry name, timestamp, and parent id.
    :type entry_id: str
    :param entry_name: The entry's name.
    :type entry_name: str
    :param entry_type: The entry's type. Can have one of the following values:
        [info, task, event, started, complete]
    :type entry_type: str
    :param entry_desc: The entry's description. Can contain markdown. Can be None.
    :type entry_desc: str
    :param entry_duedate: Optional. The entry's due date as a POSIX timestamp. Can be None.
    :type entry_duedate: float
    :param entry_assigned_users: Optional. A list of user IDs that are assigned to this entry.
    :type entry_assigned_users: List[int]
    :param entry_comments: Optional. A list of comments with the following structure:
        [{
            "comment_id": int,
            "comment_user_id": int,
            "comment_text": str,
            "comment_timestamp": float
        }]
    :type entry_comments: List[dict]
    :param entry_children: Optional. A list of child entry IDs. If no children, this is None.
    :type entry_children: List[int] or None
    :param entry_parent: Optional. The parent entry ID. If no parent, this is None.
    :type entry_parent: int or None
    """
    def __init__(self,
                 entry_name,
                 entry_type,
                 entry_id=None,
                 entry_desc=None,
                 entry_duedate=None,
                 entry_assigned_users=None,
                 entry_comments=None,
                 entry_children=None,
                 entry_parent=None):
        if entry_id is None:
            self.entry_id = self.generate_id()
        else:
            self.entry_id = entry_id
        self.entry_name = entry_name
        self.entry_type = entry_type
        self.entry_desc = entry_desc
        self.entry_duedate = entry_duedate
        self.entry_assigned_users = entry_assigned_users
        self.entry_comments = entry_comments
        self.entry_children = entry_children
        self.entry_parent = entry_parent
        self.entry_timestamp = datetime.datetime.now().replace(
            tzinfo=datetime.timezone.utc).timestamp()

    bullet_key = {
        "info": "-",
        "task": "•",
        "event": "○",
        "started": "/",
        "complete": "X"
    }

    def __repr__(self) -> str:
        return f"<BulletEntry {self.entry_id} created at {self.entry_timestamp}>"

    def __str__(self) -> str:
        return f"{self.bullet_key[self.entry_type]} {self.entry_name} ({self.get_short_id()})"

    def generate_id(self) -> str:
        """Hash the entry name, timestamp, and parent id."""
        return hashlib.sha256(
            f"{self.entry_name}{self.entry_timestamp}{self.entry_parent}".
            encode()).hexdigest()

    def get_short_id(self) -> str:
        """Return the entry's ID as a short string."""
        return self.entry_id[:7]

    def get_supertype(self) -> str:
        """
        Returns the supertype of the entry.
        :return: The supertype of the entry.
        :rtype: str
        """
        if self.entry_type in ["task", "started", "complete"]:
            return "task"
        elif self.entry_type == "event":
            return "event"
        else:
            return "info"

    def is_task(self) -> bool:
        """Boolean check if the entry is a task."""
        return self.entry_type in ["task", "started", "complete"]

    def is_event(self) -> bool:
        """Boolean check if the entry is an event."""
        return self.entry_type == "event"

    def is_info(self) -> bool:
        """Boolean check if the entry is informational."""
        return self.entry_type in ["info", "note"]

    def is_started(self) -> bool:
        """Boolean check if the entry is started."""
        return self.entry_type == "started"

    def is_complete(self) -> bool:
        """Boolean check if the entry is completed."""
        return self.entry_type == "complete"

    def get_JSON_payload(self):
        """
        Get the JSON payload for the BulletEntry object.
        :return: The JSON payload.
        :rtype: dict
        """
        payload = {
            "name": self.entry_name,
            "type": self.entry_type,
            "timestamp": self.entry_timestamp,
            "entry_id": self.entry_id,
            "description": self.entry_desc,
            "due_date": self.entry_duedate,
            "assigned": self.entry_assigned_users,
            "comments": self.entry_comments,
            "children": self.entry_children,
            "parent": self.entry_parent
        }
        return json.dumps(payload, separators=(',', ':'))


class CustomBulletEntry(BulletEntry):
    """
    A custom bullet entry.
    :param entry_id: The unique identifier of the entry. This is a SHA256 hash of the entry name, timestamp, and parent id.
    :type entry_id: str
    :param entry_name: The entry's name.
    :type entry_name: str
    :param entry_type: The entry's type. Can have one of the following values:
        [info, task, event, started, complete]
    :type entry_type: str
    :param entry_desc: The entry's description. Can contain markdown. Can be None.
    :type entry_desc: str
    :param entry_duedate: Optional. The entry's due date as a POSIX timestamp. Can be None.
    :type entry_duedate: float
    :param entry_assigned_users: Optional. A list of user IDs that are assigned to this entry.
    :type entry_assigned_users: List[int]
    :param entry_comments: Optional. A list of comments with the following structure:
        [{
            "comment_id": int,
            "comment_user_id": int,
            "comment_text": str,
            "comment_timestamp": float
        }]
    :type entry_comments: List[dict]
    :param entry_children: Optional. A list of child entry IDs. If no children, this is None.
    :type entry_children: List[int] or None
    :param entry_parent: Optional. The parent entry ID. If no parent, this is None.
    :type entry_parent: int or None
    :param entry_bullet_char: The character that represents the bullet. 
                              Overrides the character set by entry_type.
    :type entry_bullet_char: str
    :param entry_orig_type: The original type of the entry. 
                            This is used to determine the supertype of the entry
                            and the bullet character tied to the entry type.
                            If entry_orig_type matches entry_type, the bullet's
                            entry_bullet_char is used instead of the bullet character
                            derived from entry_type.
    :type entry_orig_type: str
    """
    def __init__(self,
                 entry_name,
                 entry_type,
                 entry_id=None,
                 entry_desc=None,
                 entry_duedate=None,
                 entry_assigned_users=None,
                 entry_comments=None,
                 entry_children=None,
                 entry_parent=None,
                 entry_bullet_char=None,
                 entry_orig_type=None):
        super().__init__(entry_id, entry_name, entry_type, entry_desc,
                         entry_duedate, entry_assigned_users, entry_comments,
                         entry_children, entry_parent)
        self.entry_bullet_char = entry_bullet_char
        self.entry_orig_type = entry_orig_type

    def __repr__(self) -> str:
        return f"<CustomBullet {self.entry_id} created at {self.entry_timestamp}>"

    def __str__(self) -> str:
        if (self.entry_bullet_char
                and self.entry_orig_type == self.entry_type):
            return f"{self.entry_bullet_char} {self.entry_name} ({self.get_short_id()})"
        else:
            return f"{self.bullet_key[self.entry_type]} {self.entry_name} ({self.get_short_id()})"

    def has_overridden_bullet(self) -> bool:
        """
        Boolean check if the entry is overriding the bullet character.
        """
        return self.entry_bullet_char and self.entry_orig_type == self.entry_type

    def get_JSON_payload(self):
        """
        Get the JSON payload for the BulletEntry object.
        :return: The JSON payload.
        :rtype: dict
        """
        payload = {
            "name": self.entry_name,
            "type": self.entry_type,
            "timestamp": self.entry_timestamp,
            "entry_id": self.entry_id,
            "description": self.entry_desc,
            "due_date": self.entry_duedate,
            "assigned": self.entry_assigned_users,
            "comments": self.entry_comments,
            "children": self.entry_children,
            "parent": self.entry_parent,
            "bullet_char": self.entry_bullet_char,
            "orig_type": self.entry_orig_type
        }
        return json.dumps(payload, separators=(',', ':'))


class BulletFactory():
    """
    A factory class for creating BulletEntry objects.
    This factory creates objects of the BulletEntry or CustomBulletEntry class.
    """
    def __init__(self):
        self.entry_id = None
        self.entry_name = None
        self.entry_type = None
        self.entry_desc = None
        self.entry_duedate = None
        self.entry_assigned_users = None
        self.entry_comments = None
        self.entry_children = None
        self.entry_parent = None
        self.entry_bullet_char = None
        self.entry_orig_type = None

    def create_bullet(self,
                      entry_name: str,
                      entry_type: str,
                      entry_desc: str = None,
                      entry_duedate: float = None,
                      entry_assigned_users: list = None,
                      entry_comments: list = None,
                      entry_children: list = None,
                      entry_parent: int = None,
                      entry_bullet_char: str = None) -> BulletEntry:
        """
        Create a bullet entry.
        :param entry_name: The entry's name.
        :type entry_name: str
        :param entry_type: The entry's type. Can have one of the following values:
            [info, task, event, started, complete]
        :type entry_type: str
        :param entry_desc: The entry's description. Can contain markdown. Can be None.
        :type entry_desc: str
        :param entry_duedate: Optional. The entry's due date as a POSIX timestamp. Can be None.
        :type entry_duedate: float
        :param entry_assigned_users: Optional. A list of user IDs that are assigned to this entry.
        :type entry_assigned_users: List[int]
        :param entry_comments: Optional. A list of comments with the following structure:
            [{
                "comment_id": int,
                "comment_user_id": int,
                "comment_text": str,
                "comment_timestamp": float
            }]
        :type entry_comments: List[dict]
        :param entry_children: Optional. A list of child entry IDs. If no children, this is None.
        :type entry_children: List[int] or None
        :param entry_parent: Optional. The parent entry ID. If no parent, this is None.
        :type entry_parent: int or None
        :param entry_bullet_char: The character that represents the bullet. 
                                  Overrides the character set by entry_type.
        :type entry_bullet_char: str
        :param entry_orig_type: The original type of the entry. 
                                This is used to determine the supertype of the entry
                                and the bullet character tied to the entry type.
                                If entry_orig_type matches entry_type, the bullet's
                                entry_bullet_char is used instead of the bullet character
                                derived from entry_type.
        :type entry_orig_type: str
        :return: A BulletEntry object.
        :rtype: BulletEntry
        """
        self.entry_timestamp = datetime.datetime.now().replace(
            tzinfo=datetime.timezone.utc).timestamp()
        self.entry_name = entry_name
        self.entry_parent = entry_parent
        self.entry_id = hashlib.sha256(
            f"{self.entry_name}{self.entry_timestamp}{self.entry_parent}".
            encode()).hexdigest()
        self.entry_type = entry_type
        self.entry_desc = entry_desc
        self.entry_duedate = dateutil.parser.parse(entry_duedate, tzinfos=tzinfos).replace(
            tzinfo=datetime.timezone.utc).timestamp() if entry_duedate else None
        self.entry_assigned_users = entry_assigned_users
        self.entry_comments = entry_comments
        self.entry_children = entry_children
        self.entry_bullet_char = entry_bullet_char
        self.entry_orig_type = entry_type

        if entry_type == "note":
            self.entry_type = "info"

        if self.entry_bullet_char:
            return CustomBulletEntry(
                self.entry_name, self.entry_type, self.entry_id,
                self.entry_desc, self.entry_duedate, self.entry_assigned_users,
                self.entry_comments, self.entry_children, self.entry_parent,
                self.entry_bullet_char, self.entry_orig_type)
        else:
            return BulletEntry(self.entry_name, self.entry_type, self.entry_id,
                               self.entry_desc, self.entry_duedate,
                               self.entry_assigned_users, self.entry_comments,
                               self.entry_children, self.entry_parent)