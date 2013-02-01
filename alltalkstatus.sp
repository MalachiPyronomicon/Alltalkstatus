#include <sourcemod>

#pragma semicolon 1

#define PLUGIN_VERSION	"0.4"


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

//  sv_alltalk
// tf_teamtalk

public OnPluginStart()
{
	CreateConVar("alltalkstatus_version", PLUGIN_VERSION, "Alltalk Status Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	g_hAlltalkStatusEnabled		= CreateConVar("alltalkstatus_enabled", "1", "turns alltalk status on and off, 1=on ,0=off");
	
	RegConsoleCmd("say", SayHook);
	RegConsoleCmd("say_team", SayHook);
	
	g_hAllTalk = FindConVar("sv_alltalk");
	g_hTeamTalk = FindConVar("tf_teamtalk");
}


public Action:SayHook(client, args)
{
	new String:message[64] = "";
	
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
	}
	return Plugin_Continue;
}
