#include <sourcemod>

#pragma semicolon 1

#define PLUGIN_VERSION	"0.1"


new Handle:AlltalkStatusEnabled = INVALID_HANDLE;


public Plugin:myinfo = 
{
	name = "Alltalk Status",
	author = "Malachi",
	description = "prints admins to clients",
	version = PLUGIN_VERSION,
	url = "www.necrophix.com"
}


public OnPluginStart()
{
	CreateConVar("alltalkstatus_version", PLUGIN_VERSION, "Alltalk Status Version", FCVAR_PLUGIN|FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	AlltalkStatusEnabled		= CreateConVar("alltalkstatus_enabled", "1", "turns alltalk status on and off, 1=on ,0=off");
	
	RegConsoleCmd("say", SayHook);
	RegConsoleCmd("say_team", SayHook);
}


public Action:SayHook(client, args)
{
	if(GetConVarInt(AlltalkStatusEnabled) == 1)
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
//			PrintToChatAll("\x04Alltalk %s, Teamtalk %s", status1, status2);
			PrintToChatAll("\x04test");
		}
	}
	return Plugin_Continue;
}
