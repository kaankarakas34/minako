#include "stdafx.h"
#include "BugTrapHandler.h"

CBugTrap::CBugTrap() : g_LibraryBugTrap(nullptr)
{
	InitBugTrap();
}

bool CBugTrap::InitBugTrap(void)
{
	BT_SETAPPNAME lpfnBT_SetAppName;
	BT_SETAPPVERSION lpfnBT_SetAppVersion;
	BT_SETFLAGS lpfnBT_SetFlags;

#ifndef _WIN64
	g_LibraryBugTrap = LoadLibrary("BugTrap.dll");
#else
	g_LibraryBugTrap = LoadLibrary("BugTrap-x64.dll");
#endif
	if (!g_LibraryBugTrap)
		return false;

	lpfnBT_SetAppName = (BT_SETAPPNAME)GetProcAddress(g_LibraryBugTrap, "BT_SetAppName");
	lpfnBT_SetAppVersion = (BT_SETAPPVERSION)GetProcAddress(g_LibraryBugTrap, "BT_SetAppVersion");
	lpfnBT_SetFlags = (BT_SETFLAGS)GetProcAddress(g_LibraryBugTrap, "BT_SetFlags");

	if (lpfnBT_SetAppName && lpfnBT_SetAppVersion && lpfnBT_SetFlags)
	{
		lpfnBT_SetAppName(TEXT("System BugsTrap"));
		lpfnBT_SetAppVersion(TEXT(VERSIONSTRING));
		// Local crash details only. No screen capture or third-party contacts.
		lpfnBT_SetFlags(BugTrapFlags::DetailedMode | BugTrapFlags::AttackhReport);

		return true;
	}

	ShutdownBugTrap();
	g_LibraryBugTrap = nullptr;
	return false;
}

void CBugTrap::ShutdownBugTrap(void)
{
	if (g_LibraryBugTrap)
		FreeLibrary(g_LibraryBugTrap);
}

bool CBugTrap::IsBugTrapLoaded(void)
{
	return !!g_LibraryBugTrap;
}

CBugTrap::~CBugTrap()
{
	ShutdownBugTrap();
}
