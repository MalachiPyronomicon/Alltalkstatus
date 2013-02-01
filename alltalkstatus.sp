//	------------------------------------------------------------------------------------
//	Filename:		alltalkstatus.sp
//	Author:			Malachi
//	Version:		0.5 
//	Description:
//					Plugin displays the current status of alltalk and teamtalk in 
//					response to chat commands ("!alltalk") and at the beginning of a round.
//
// * Changelog (date/version/description):
// * 2013-01-15	-	0.5	-	added round start hook, still need cvar hook
//	------------------------------------------------------------------------------------


#include <sourcemod>

#pragma semicolon 1

#define PLUGIN_VERSION	"0.5"


new Handle:g_hAlltalkStatusEnabled = INVALID_HANDLE;
new Handle:g_hAllTalk = INVALID_HANDLE;
new Handle:g_hTeamTalk = INVALID_HANDLE;


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
	CreateConVar("alltalkstatus_version", PLUGIN_VERSION, "Alltalk Status Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	g_hAlltalkStatusEnabled		= CreateConVar("alltalkstatus_enabled", "1", "turns alltalk status on and off, 1=on ,0=off");
	
	RegConsoleCmd("say", SayHook);
	RegConsoleCmd("say_team", SayHook);
	
	HookEvent("teamplay_round_start", Hook_RoundStart);
	
	g_hAllTalk = FindConVar("sv_alltalk");
	g_hTeamTalk = FindConVar("tf_teamtalk");
}


public Action:SayHook(client, args)
{	
	if(GetConVarInt(g_hAlltalkStatusEnabled) == 1)
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
			ShowStatus(INVALID_HANDLE);
		}
	}
		
	return Plugin_Continue;
}



public Action:ShowStatus(Handle:Timer)
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
	
	return Plugin_Continue;
}


public Action:Hook_RoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
	new Handle:hTimer = INVALID_HANDLE; 

	// Wait 10 seconds
	hTimer = CreateTimer(30.0, ShowStatus, 0, TIMER_FLAG_NO_MAPCHANGE | TIMER_HNDL_CLOSE);
	return Plugin_Continue;	// Do we need this?
}
