# bulletentry.py unit tests
# written by gz1573@wayne.edu

import unittest
import hashlib
import datetime
import json
from discord.bulletentry import BulletEntry, CustomBulletEntry

class BulletEntryTests(unittest.TestCase):
    def test_entry_name(self):
        entry = BulletEntry('test', 'info')
        self.assertEqual(entry.entry_name, 'test')

    def test_entry_type_info(self):
        entry = BulletEntry('test', 'info')
        self.assertEqual(entry.entry_type, 'info')
        self.assertEqual(entry.get_supertype(), 'info')
        self.assertEqual(entry.bullet_key[entry.entry_type], '-')

    def test_entry_type_note(self):
        # note is an alias of info, therefore entry.type should return 'info'
        entry = BulletEntry('test', 'note')
        self.assertEqual(entry.entry_type, 'info')
        self.assertEqual(entry.get_supertype(), 'info')
        self.assertEqual(entry.bullet_key[entry.entry_type], '-')

    def test_entry_type_task(self):
        entry = BulletEntry('test', 'task')
        self.assertEqual(entry.entry_type, 'task')
        self.assertEqual(entry.get_supertype(), 'task')
        self.assertEqual(entry.bullet_key[entry.entry_type], '•')
        assert entry.bullet_key[entry.entry_type] == '•'

    def test_entry_type_started(self):
        entry = BulletEntry('test', 'started')
        self.assertEqual(entry.entry_type, 'started')
        self.assertEqual(entry.get_supertype(), 'task')
        self.assertEqual(entry.bullet_key[entry.entry_type], '/')

    def test_entry_type_completed(self):
        entry = BulletEntry('test', 'completed')
        self.assertEqual(entry.entry_type, 'completed')
        self.assertEqual(entry.get_supertype(), 'task')
        self.assertEqual(entry.bullet_key[entry.entry_type], 'X')

    def test_entry_type_event(self):
        entry = BulletEntry('test', 'event')
        self.assertEqual(entry.entry_type, 'event')
        self.assertEqual(entry.get_supertype(), 'event')
        self.assertEqual(entry.bullet_key[entry.entry_type], '○')

    def test_invalid_entry_type(self):
        with self.assertRaises(ValueError):
            entry = BulletEntry('test', 'invalid')
    
    def test_entry_timestamp_creation(self):
        # Timestamps are stored as a UNIX timestamp in the form of a float.
        entry = BulletEntry('test', 'info')
        self.assertIsNotNone(entry.entry_timestamp)
        self.assertIsInstance(entry.entry_timestamp, float)
        # Check to see if the timestamp is reasonable.
        self.assertGreater(entry.entry_timestamp, 0)
        self.assertLess(entry.entry_timestamp, datetime.datetime.now().timestamp())

    def test_entry_ID_creation(self):
        # An entries ID is a SHA256 hash of the entry's name, type, and timestamp.
        entry = BulletEntry('test', 'info')
        self.assertIsNotNone(entry.entry_id)
        self.assertIsInstance(entry.entry_id, str)
        self.assertEqual(len(entry.entry_id), 64)
        self.assertEqual(entry.entry_id, hashlib.sha256(entry.entry_name.encode('utf-8') + entry.entry_type.encode('utf-8') + str(entry.entry_timestamp).encode('utf-8')).hexdigest())

    def test_supertypes(self):
        entry = BulletEntry('test', 'info')
        self.assertEqual(entry.get_supertype(), 'info')
        entry = BulletEntry('test', 'task')
        self.assertEqual(entry.get_supertype(), 'task')
        entry = BulletEntry('test', 'started')
        self.assertEqual(entry.get_supertype(), 'task')
        entry = BulletEntry('test', 'completed')
        self.assertEqual(entry.get_supertype(), 'task')
        entry = BulletEntry('test', 'event')
        self.assertEqual(entry.get_supertype(), 'event')
        # An invalid type should raise a ValueError on instantiation.
        with self.assertRaises(ValueError):
            entry = BulletEntry('test', 'invalid')
        
    def test_entry_JSON_payload(self):
        entry = BulletEntry('test', 'info')
        self.assertIsNotNone(entry.get_json_payload())
        self.assertIsInstance(entry.get_json_payload(), str)
        self.assertEqual(entry.get_json_payload(), json.dumps(entry.__dict__))

class CustomBulletEntryTests(unittest.TestCase):
    def test_custom_entry_type(self):
        entry = CustomBulletEntry('test', 'info', entry_bullet_char='*')
        self.assertEqual(entry.entry_type, 'info')
        self.assertEqual(entry.get_supertype(), 'info')
        self.assertEqual(entry.entry_bullet_char, '*')
        # Despite the fact that the bullet char has been overridden,
        # the bullet key mapping should still be the same.
        self.assertNotEqual(entry.bullet_key[entry.entry_type], '*')
        self.assertTrue(entry.has_overridden_bullet())

    def test_custom_entry_JSON_payload(self):
        entry = CustomBulletEntry('test', 'info', entry_bullet_char='*')
        self.assertIsNotNone(entry.get_json_payload())
        self.assertIsInstance(entry.get_json_payload(), str)
        self.assertEqual(entry.get_json_payload(), json.dumps(entry.__dict__))

if __name__ == '__main__':
    unittest.main()

# Powered by the Python unittest framework.
# https://docs.python.org/3/library/unittest.html