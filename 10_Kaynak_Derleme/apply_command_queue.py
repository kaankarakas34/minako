with open(r'10_Kaynak_Derleme\TemuKO\ServerFiles\SourceFiles\GameServer\GameServerDlg.cpp', 'rb') as f:
    content = f.read().decode('cp1254', errors='ignore')

target = "uint32 CGameServerDlg::Timer_CheckGameEvents(void * lpParam)\r\n{\r\n\twhile (g_bRunning)\r\n\t{\r\n\t\tg_pMain->GameInfoNoticeTimer();\r\n\t\tg_pMain->GameServerShutDownTimer();\r\n\t\tg_pMain->GameEventMainTimer();\r\n\t\tg_pMain->CollectionRaceFinish();\r\n\t\tg_pMain->AutoOnlineCount();\r\n\r\n\t\tsleep(1 * SECOND);\r\n\t}\r\n\treturn 0;\r\n}"

replacement = """uint32 CGameServerDlg::Timer_CheckGameEvents(void * lpParam)
{
	while (g_bRunning)
	{
		g_pMain->GameInfoNoticeTimer();
		g_pMain->GameServerShutDownTimer();
		g_pMain->GameEventMainTimer();
		g_pMain->CollectionRaceFinish();
		g_pMain->AutoOnlineCount();
		g_pMain->ProcessAdminCommandQueue();

		sleep(1 * SECOND);
	}
	return 0;
}

void CGameServerDlg::ProcessAdminCommandQueue()
{
	if (g_DBAgent.m_GameDB == nullptr)
		return;

	unique_ptr<OdbcCommand> dbCommand(g_DBAgent.m_GameDB->CreateCommand());
	if (dbCommand.get() == nullptr)
		return;

	if (!dbCommand->Execute(_T("SELECT TOP 5 id, command, ISNULL(param1, ''), ISNULL(param2, ''), ISNULL(param3, ''), ISNULL(param4, ''), ISNULL(param5, ''), ISNULL(param6, '') FROM SERVER_COMMAND_QUEUE WHERE status = 0 ORDER BY id ASC")))
		return;

	struct AdminCmd {
		int id;
		std::string command;
		std::string p1, p2, p3, p4, p5, p6;
	};
	std::vector<AdminCmd> cmds;

	while (dbCommand->Fetch())
	{
		AdminCmd c;
		c.id = dbCommand->FetchInt32(1);
		dbCommand->FetchString(2, c.command);
		dbCommand->FetchString(3, c.p1);
		dbCommand->FetchString(4, c.p2);
		dbCommand->FetchString(5, c.p3);
		dbCommand->FetchString(6, c.p4);
		dbCommand->FetchString(7, c.p5);
		dbCommand->FetchString(8, c.p6);
		cmds.push_back(c);
	}

	for (auto & cmd : cmds)
	{
		std::string result_msg = "OK";
		uint8 status = 1;

		if (STRCASECMP(cmd.command.c_str(), "SPAWN") == 0)
		{
			uint16 sSid = (uint16)atoi(cmd.p1.c_str());
			uint8 byZone = (uint8)atoi(cmd.p2.c_str());
			float fX = (float)atof(cmd.p3.c_str());
			float fY = (float)atof(cmd.p4.c_str());
			float fZ = (float)atof(cmd.p5.c_str());
			uint16 sCount = (uint16)atoi(cmd.p6.c_str());
			if (sCount <= 0) sCount = 1;

			if (!cmd.p3.empty() && isalpha((unsigned char)cmd.p3[0]))
			{
				CUser *pUser = GetUserPtr(cmd.p3, TYPE_CHARACTER);
				if (pUser != nullptr && pUser->isInGame())
				{
					byZone = pUser->GetZoneID();
					fX = pUser->GetX();
					fY = pUser->GetY();
					fZ = pUser->GetZ();
				}
			}

			if (fX == 0.0f && fZ == 0.0f)
			{
				if (byZone == 0) byZone = 21;
				fX = 815.0f; fY = 0.0f; fZ = 545.0f;
			}

			SpawnEventNpc(sSid, true, byZone, fX, fY, fZ, sCount);
			result_msg = string_format("Spawned SID %d count %d at zone %d", sSid, sCount, byZone);
		}
		else if (STRCASECMP(cmd.command.c_str(), "KILL_MOBS") == 0)
		{
			uint8 byZone = (uint8)atoi(cmd.p1.c_str());
			if (byZone == 0) byZone = 21;
			CNpcThread* zoneitrThread = m_arNpcThread.GetData(byZone);
			if (zoneitrThread != nullptr)
			{
				zoneitrThread->AddRequest(new Signal(NpcThreadSignalType::NpcAllRemove));
				result_msg = string_format("All mobs removed in zone %d", byZone);
			}
			else
			{
				status = 2;
				result_msg = string_format("Zone %d NPC thread not found", byZone);
			}
		}
		else if (STRCASECMP(cmd.command.c_str(), "NOTICE") == 0)
		{
			SendNotice(cmd.p1.c_str(), Nation::ALL);
			result_msg = "Notice sent";
		}
		else if (STRCASECMP(cmd.command.c_str(), "ANNOUNCEMENT") == 0)
		{
			SendAnnouncement(cmd.p1.c_str(), Nation::ALL);
			result_msg = "Announcement sent";
		}
		else if (STRCASECMP(cmd.command.c_str(), "GIVE_ITEM") == 0)
		{
			std::string strUserId = cmd.p1;
			uint32 nItemId = (uint32)strtoul(cmd.p2.c_str(), NULL, 10);
			uint16 sCount = (uint16)atoi(cmd.p3.c_str());
			if (sCount <= 0) sCount = 1;
			CUser *pUser = GetUserPtr(strUserId, TYPE_CHARACTER);
			if (pUser != nullptr && pUser->isInGame())
			{
				if (pUser->GiveItem(nItemId, sCount, true))
					result_msg = string_format("Gave item %u (x%d) to %s", nItemId, sCount, strUserId.c_str());
				else
				{
					status = 2;
					result_msg = string_format("Failed to give item %u to %s", nItemId, strUserId.c_str());
				}
			}
			else
			{
				status = 2;
				result_msg = string_format("User %s is not online", strUserId.c_str());
			}
		}
		else if (STRCASECMP(cmd.command.c_str(), "GIVE_GOLD") == 0)
		{
			std::string strUserId = cmd.p1;
			uint32 nGold = (uint32)strtoul(cmd.p2.c_str(), NULL, 10);
			CUser *pUser = GetUserPtr(strUserId, TYPE_CHARACTER);
			if (pUser != nullptr && pUser->isInGame())
			{
				pUser->GoldGain(nGold, true, false);
				result_msg = string_format("Gave %u gold to %s", nGold, strUserId.c_str());
			}
			else
			{
				status = 2;
				result_msg = string_format("User %s is not online", strUserId.c_str());
			}
		}
		else if (STRCASECMP(cmd.command.c_str(), "KICK") == 0)
		{
			std::string strUserId = cmd.p1;
			CUser *pUser = GetUserPtr(strUserId, TYPE_CHARACTER);
			if (pUser != nullptr)
			{
				pUser->Disconnect();
				result_msg = string_format("Kicked %s", strUserId.c_str());
			}
			else
			{
				status = 2;
				result_msg = string_format("User %s is not online", strUserId.c_str());
			}
		}
		else if (STRCASECMP(cmd.command.c_str(), "TELEPORT") == 0)
		{
			std::string strUserId = cmd.p1;
			uint8 byZone = (uint8)atoi(cmd.p2.c_str());
			float fX = (float)atof(cmd.p3.c_str());
			float fZ = (float)atof(cmd.p4.c_str());
			CUser *pUser = GetUserPtr(strUserId, TYPE_CHARACTER);
			if (pUser != nullptr && pUser->isInGame())
			{
				pUser->ZoneChange(byZone, fX, fZ);
				result_msg = string_format("Teleported %s to zone %d", strUserId.c_str(), byZone);
			}
			else
			{
				status = 2;
				result_msg = string_format("User %s is not online", strUserId.c_str());
			}
		}
		else
		{
			status = 2;
			result_msg = "Unknown command";
		}

		unique_ptr<OdbcCommand> updateCmd(g_DBAgent.m_GameDB->CreateCommand());
		if (updateCmd.get() != nullptr)
		{
			updateCmd->Execute(string_format(_T("UPDATE SERVER_COMMAND_QUEUE SET status = %d, result_msg = '%s', processed_at = GETDATE() WHERE id = %d"),
				status, result_msg.c_str(), cmd.id));
		}
	}
}""".replace('\n', '\r\n')

assert target in content, 'Target not found in GameServerDlg.cpp'
content = content.replace(target, replacement)

with open(r'10_Kaynak_Derleme\TemuKO\ServerFiles\SourceFiles\GameServer\GameServerDlg.cpp', 'wb') as f:
    f.write(content.encode('cp1254', errors='ignore'))
print('GameServerDlg.cpp updated successfully!')
