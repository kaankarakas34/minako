#include "stdafx.h"
#include "../shared/LocalClientProfile.h"

void CUser::VersionCheck(Packet & pkt)
{
	Packet result(WIZ_VERSION_CHECK);
#ifdef KNIGHTLAB_CLIENT_WIRE_VERSION
	// The supplied stock client reads this exact 2083 handshake layout.
	// Send the public key in plaintext, then require normal encrypted packets.
	result << uint8(0) << uint16(KNIGHTLAB_CLIENT_WIRE_VERSION)
		<< m_crypto.GenerateKey() << uint8(0);
	Send(&result);
	EnableCrypto();
#else
	result << uint8(0) << uint16(__VERSION) << uint8_t(0) << uint64(0) << uint64(0) << uint8(0); // 0 = success, 1 = prem error
	Send(&result);
#endif
}

void CUser::LoginProcess(Packet & pkt)
{
	// Enforce only one login request per session
	// It's common for players to spam this at the server list when a response isn't received immediately.
	if (!m_strAccountID.empty())
		return;

	if(!string_is_valid(m_strAccountID))
		return;

	Packet result(WIZ_LOGIN);
	std::string strAccountID, strPasswd;
	pkt >> strAccountID >> strPasswd;
	if (strAccountID.empty() || strAccountID.size() > MAX_ID_SIZE
		|| strPasswd.empty() || strPasswd.size() > MAX_PW_SIZE)
		goto fail_return;

	CUser * pUser = g_pMain->GetUserPtr(strAccountID, TYPE_ACCOUNT);

	if (pUser != nullptr)
	{
		if (pUser->isOfflineSystem())
		{
			pUser->m_bOfflineSystemType = false;
			pUser->m_bOfflineSystemSocketType = false;
			DateTime time;
			g_pMain->WriteOfflineSystemLog(string_format("[Offline System Disconnect - %d:%d:%d ] = %s\n", time.GetHour(), time.GetMinute(), time.GetSecond(), pUser->GetName().c_str()));
			pUser->UserDataSaveToAgent();
			pUser->Disconnect();
			goto fail_return;
		}

		if (pUser->GetSocketID() != GetSocketID())
		{
			pUser->Disconnect();
			goto fail_return;
		}
	}

	result << strPasswd;
	m_strAccountID = strAccountID;
	g_pMain->AddDatabaseRequest(result, this);
	return;

fail_return:
	result << uint8(-1);
	Send(&result);
}
