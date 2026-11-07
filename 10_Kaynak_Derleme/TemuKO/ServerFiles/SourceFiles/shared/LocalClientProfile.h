#pragma once

// Isolated lab profile for the user's unmodified v24_Patch client.
// SHA256 683BEFABAE1F217296BEFDA2A824B26BD2FFF77BFF67AA72A66C219C040F12FE
// Its key initialization at VA 0x48bfa0 uses the standard KO wire key.
// Packet CRC, sequence validation and database authentication stay enabled.
#define KNIGHTLAB_CLIENT_PRIVATE_KEY 0x1207500120128966ULL
// GetVersion() at 0x4a93c0 returns 0x823 in this exact client.
// Its version handler 0x4b17a0 reads flag,u16 version,u64 key,u8 mode.
// Keep the engine's __VERSION at 2239; adapt the handshake explicitly.
#define KNIGHTLAB_CLIENT_WIRE_VERSION 2083
