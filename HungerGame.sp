#include <sourcemod>
#include <steamtools>
#include <cstrike>
#include <morecolors>
#include <cssclantags.inc>

#define LOGO "{orangered}Zexta{default}"
#define AUTHOR "Æziak"
#define FORUM "http://zexta.eu"
#define TEAM "Zexta"

new Handle:pub;
new Handle:TimerHud[MAXPLAYERS+1] = INVALID_HANDLE;

public OnPluginStart()
{
	CreateDirectory("addons/sourcemod/data/HungerGame", 3);
	HookEvent("round_start", OnRoundStart);
	HookEvent("player_spawn", Event_PlayerSpawn);
	AddCommandListener(Say, "say");
	AddCommandListener(OnSayTeam, "say_team");
	pub = CreateTimer(90.0, Timer_Pub, _, TIMER_REPEAT);
	PrecacheModel("models/player/slow/50cent/slow.mdl", true);
}



public Action:OnRoundStart(Handle:event, const String:name[], bool:dontBroadcast)
{
decl String:GameName[64]
Format(GameName, sizeof(GameName), "♫ Zexta ♫");
Steam_SetGameDescription(GameName);
}

public Action:Say(client, const String:command[], args)
{
	if (client > 0 && client <= MaxClients)
	{
		if (IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				decl String:text[128];
				decl String:Arg[256];
				GetCmdArgString(Arg, sizeof(Arg));
				StripQuotes(Arg);
				TrimString(Arg);

				GetCmdArg(1, text, sizeof(text));
				
				if(Arg[0] == '/')
			{
				return Plugin_Handled;
			}
				
				
				CPrintToChatAll("%s : {steelblue}HungerGames %N{default} : %s", LOGO, client, text);
			
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}


public Action:OnSayTeam(client, const String:command[], args)
{
	if (client > 0 && client <= MaxClients)
	{
		if (IsClientInGame(client))
		{
			if (IsPlayerAlive(client))
			{
				decl String:text[128];

				GetCmdArg(1, text, sizeof(text));
				
				CPrintToChatAll("%s : {ghostwhite}({steelblue}HungerGames{ghostwhite}){default} {steelblue}%N{default} : %s", LOGO, client, text);
			
				return Plugin_Handled;
			}
		}
	}
	return Plugin_Continue;
}


public Action:Timer_Pub(Handle:timer)
{
	switch (GetRandomInt(1, 5))
	{
		case 1:
		{
			CPrintToChatAll("%s : {LightSeaGreen}Bienvenue sur le mod HungerGames Zexta.{default}", LOGO);
		}
		
		case 2:
		{
			CPrintToChatAll("%s : {steelblue}Le serveur est en bêta test.{default}", LOGO);
		}
		
		case 3:
		{
			CPrintToChatAll("%s : {fullred}zexta.eu{default}", LOGO);
		}
		
		case 4:
		{
			CPrintToChatAll("%s : Veuillez rapporter les bugs sur le Forum.", LOGO);
		}
		
		case 5:
		{
			CPrintToChatAll("%s : {steelblue}Le HungerGames est coder par {orangered}Aeziak {default}.",  LOGO);
		}
	}

}

public Action:HudTimer(Handle:timer, any:client)
{
	new Handle:hBuffer = StartMessageOne("KeyHintText", client);
	
	
	new aim = GetClientAimTarget(client, true);
	new health = GetClientHealth(aim);
	
	if(!IsClientInGame(client))
    {
        CloseHandle(TimerHud[client]);
        return Plugin_Stop;
    }
	
	if (hBuffer == INVALID_HANDLE)
	{
		CPrintToChat(client, "INVALID_HANDLE");
	}
	else
	{
		new String:tmptext[9999];
		{
		
			{
				Format(tmptext, sizeof(tmptext), "HungerGames Zexta : \n---------------------------------------- \nVotre vie : %i \n\n----------------------------------------", health);
			}
			BfWriteByte(hBuffer, 1); 
			BfWriteString(hBuffer, tmptext); 
			EndMessage();
		}
	}
	return Plugin_Continue;
}


public Action:Timer_Dead(Handle:timer, any:client)
{
	if (IsClientInGame(client))
	{
		if (!IsPlayerAlive(client))
		{	
				{
					CS_SwitchTeam(client, 3);
					CS_RespawnPlayer(client);
					disarm(client);
					GivePlayerItem(client, "weapon_knife");
					SetEntityHealth(client, 100);
				}
			
				
		}
	}
}

public disarm(player)
{
	new wepIdx;
	for (new f = 0; f < 6; f++)
		if (f < 6 && (wepIdx = GetPlayerWeaponSlot(player, f)) != -1)  
			RemovePlayerItem(player, wepIdx);
}


public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
        new client = GetClientOfUserId(GetEventInt(event, "userid"));
        if(!IsFakeClient(client)) {
                if(GetUserFlagBits(client) & ADMFLAG_ROOT)
                        CS_SetClientClanTag(client, "H-G -");
                else if(GetUserFlagBits(client) & ADMFLAG_SLAY)
                        CS_SetClientClanTag(client, "H-G -");
                else if(GetUserFlagBits(client) & ADMFLAG_CUSTOM1)
                        CS_SetClientClanTag(client, "H-G -");
                else
                        CS_SetClientClanTag(client, "H-G -");
        }
}

public chooseskin(client)
{
	SetEntityModel(client, "models/player/slow/50cent/slow.mdl");
}



