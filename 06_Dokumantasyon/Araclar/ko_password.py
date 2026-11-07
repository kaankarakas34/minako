"""ASCII test-password encoding used by the supplied stock KO client.

Ported from dbo.HashPasswordString in the user's original v24xx SQL backup.
This is a legacy wire/storage format, not a modern password KDF.
"""
PERMUTATION = bytes.fromhex('1a1f110a1e1018021d08140f1c0b0d041317000c0e1b06121503090716011905')
ALPHABET = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ'

def encode_password(password):
    raw = password.encode('ascii')
    if not 1 <= len(raw) <= 16:
        raise ValueError('Local ASCII test password must contain 1..16 characters')
    result = []
    for at in range(0, len(raw), 4):
        value = int.from_bytes(raw[at:at+4], 'little') + 1000
        encoded = sum(1 << target for source, target in enumerate(PERMUTATION) if value & (1 << source)) & 0xffffffff
        for _ in range(7):
            encoded, digit = divmod(encoded, 36)
            result.append(ALPHABET[digit])
    return ''.join(result)
