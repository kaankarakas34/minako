"""Parse the supplied stock client's F5 list, including its group separator.

Read-only binary evidence in the unmodified supplied patch client:
0x4b7e92 searches '|'; 0x4b7eb1..0x4b7f73 splits group/channel.
0x4d7119 excludes an empty group from the UI's group collection.
"""
import struct

def parse_server_list(data):
    assert len(data) >= 4 and data[0] == 0xf5
    echo = struct.unpack_from('<H', data, 1)[0]
    count = data[3]; at = 4; servers = []
    def read_string():
        nonlocal at
        assert at + 2 <= len(data)
        n = struct.unpack_from('<H', data, at)[0]; at += 2
        assert at + n <= len(data)
        value = data[at:at+n].decode('ascii'); at += n
        return value
    for _ in range(count):
        lan, ip, name = read_string(), read_string(), read_string()
        assert at + 11 <= len(data)
        users, server_id, group_id, capacity, free_capacity, flag = struct.unpack_from('<hhhhhB', data, at)
        at += 11
        notices = [read_string() for _ in range(4)]
        group, separator, channel = name.partition('|')
        if not separator: group, channel = '', name
        servers.append({'Group':group, 'Channel':channel, 'Name':name, 'IP':ip,
            'LanIP':lan, 'ServerID':server_id, 'GroupID':group_id, 'Users':users,
            'Capacity':capacity, 'FreeCapacity':free_capacity,
            'VisibleGroup':bool(group), 'Flag':flag})
    assert at == len(data), 'Unexpected server-list trailing bytes'
    return {'Echo':echo, 'Servers':servers, 'AdvertisedCount':count,
            'VisibleGroups':sorted({s['Group'] for s in servers if s['VisibleGroup']})}
