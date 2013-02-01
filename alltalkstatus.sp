//	------------------------------------------------------------------------------------
//	Filename:		alltalkstatus.sp
//	Author:			Malachi
//	Version:		(see PLUGIN_VERSION)
//	Description:
//					Plugin displays the current status of alltalk and teamtalk in 
//					response to chat commands ("!alltalk") and at the beginning of a round.
//
// * Changelog (date/version/description):
// * 2013-01-15	-	0.5	-	added round start hook, still need cvar hook
// * 2013-01-18	-	0.6	-	fix for timer handle
// * 2013-01-18	-	0.7	-	Add cvar hooks, remove unneeded version cvar
//	------------------------------------------------------------------------------------


#include <sourcemod>

#pragma semicolon 1

#define PLUGIN_VERSION	"0.7"



new Handle:g_hAllTalk = INVALID_HANDLE;
new Handle:g_hTeamTalk = INVALID_HANDLE;
new Handle:g_hTimer = INVALID_HANDLE; 


public Plugin:myinfo = 
{
	name = "Alltalk Status",
	author = "Malachi",
	description = "prints alltalk settings to clients",
	version = PLUGIN_VERSION,
	url = "www.necrophix.com"
}


public OnPluginStart()
{
	AddCommandListener(Command_Say, "say");
	AddCommandListener(Command_Say, "say_team");
	
	HookEvent("teamplay_round_start", Hook_RoundStart);
	
	g_hAllTalk = FindConVar("sv_alltalk");
	if ( g_hAllTalk != INVALID_HANDLE )
	{
		HookConVarChange(g_hAllTalk, Command_Alltalk);
	}
			
	g_hTeamTalk = FindConVar("tf_teamtalk");
	if ( g_hTeamTalk != INVALID_HANDLE )
	{
		HookConVarChange(g_hTeamTalk, Command_Alltalk);
	}
			
}


public Command_Alltalk(Handle:cvar, const String:oldVal[], const String:newVal[])
{
	if (g_hTimer != INVALID_HANDLE)
	{
		KillTimer(g_hTimer);
		g_hTimer = INVALID_HANDLE;
	}
	ShowStatus();
}


public Action:Command_Say(client, const String:command[], args)
{	
	new String:text[192];
	GetCmdArgString(text, sizeof(text));
	
	new startidx = 0;
	if (text[0] == '"')
	{
		startidx = 1;
		
		new len = strlen(text);
		if (text[len-1] == '"')
		{
			text[len-1] = '\0';
		}
	}
	
	if(StrEqual(text[startidx], "!alltalk") || StrEqual(text[startidx], "/alltalk"))
	{
		ShowStatus();
	}
		
	return Plugin_Continue;
}



public Action:ShowStatus()
{
	new String:message[64] = "";
	
	if (g_hTeamTalk != INVALID_HANDLE)
	{
		if(GetConVarInt(g_hTeamTalk))
		{
			Format(message, sizeof(message), "  \x04TeamTalk is \x01ON");
		}
		else
		{
			Format(message, sizeof(message), "  \x04TeamTalk is \x01OFF");
		}
	}
	
	if (g_hAllTalk != INVALID_HANDLE)
	{
		if(GetConVarInt(g_hAllTalk))
		{
			PrintToChatAll("\x04AllTalk is \x01ON%s", message);
		}
		else
		{
			PrintToChatAll("\x04AllTalk is \x01OFF%s", message);
		}
	}
}


// func wrapper to deal w/timer handle
public Action:CallShowStatus(Handle:Timer)
{

	g_hTimer = INVALID_HANDLE;
	ShowStatus();

}


// The round start hook gets run here
public Action:Hook_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
    if (g_hTimer != INVALID_HANDLE)
    {
        KillTimer(g_hTimer);
        g_hTimer = INVALID_HANDLE;
    }
    g_hTimer = CreateTimer(30.0, CallShowStatus);
    return Plugin_Continue;
}


// Cleanup timer on map end
public OnMapEnd()
{
    if (g_hTimer != INVALID_HANDLE)
    {
        KillTimer(g_hTimer);
        g_hTimer = INVALID_HANDLE;
    }
}
