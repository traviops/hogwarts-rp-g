#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>
/*----------------------------------------------------------------------------*/
/*
	{MACROS}
*/
stock m_string[128];

#define SendClientMessageEx(%0,%1,%2,%3) \
		format(m_string, sizeof(m_string),%2,%3) && SendClientMessage(%0, %1, m_string)
		
#define call:%1(%2) \
		forward %1(%2); \
		public %1(%2)
/*----------------------------------------------------------------------------*/
/*
	{ENUMERATOR}
*/
enum
{
    INVALID_SLOT_ID = -1,
    
    INVALID_ITEM_ID = -1,
    INVALID_AMOUNT = -1,
    
    UNAVAILABLE_SLOT = -2,
    
    SELECTED_COLOR = 0x149C2FFF,
    UNSELECTED_COLOR = -86,
    
    COLOR_RED = 0xE84F33AA,
    
    INVENTORY_PART_ITEM_INFO,
    INVENTORY_PART_MY_ITEM,
    
    DIALOG_INV_ITEM_INFO = 8888,
    
    MAX_DROP = 300,
    MAX_ITEMS = 2,
    
    BACKPACK_INDEX = 8,
    
    BACK_ESTATE_EQUIPPED = 0,
    BACK_ESTATE_STIRRING = 1,
    BACK_ITEM_DROP = 2,

    BACKPACK_TYPE_SIMPLE = 0,
    BACKPACK_TYPE_FULL = 1,

    ITEM_STATE_NONE = 0,
    ITEM_STATE_USING = 1,
    ITEM_STATE_HOLDING = 2,

    ITEM_ATTACH_INDEX = 6,
    ITEM_ACTION_ATTACH_INDEX = 7,

    TRANSACTION_TYPE_COIN = 0,
    TRANSACTION_TYPE_ITEM = 1,

    TRADE_TYPE_PERSONAL = 0,
    TRADE_TYPE_COMMERCIAL = 1,
}
//---------------------------------------------
enum E_GLOBAL_TEXT_INVENTORY
{
	Text:e_BACKGROUND[6],

	Text:e_BUTTON[12]
}

enum E_PLAYER_TEXT_INVENTORY
{
	PlayerText:e_ITEM_INFO,

	PlayerText:e_PREVIEW_SKIN,
	PlayerText:e_PREVIEW_MY_ITEM[20],
	PlayerText:e_PREVIEW_SKIN_ITEM[4],
	
	PlayerText:e_PREVIEW_LOCK[20]
}
//---------------------------------------------
enum E_GLOBAL_TEXT_TRADE
{
	Text:e_BACKGROUND[13],

	Text:e_BUTTON[3]
}
enum E_PLAYER_TEXT_TRADE
{
	PlayerText:e_DEALER_NAME,//OFERTA DE ADEJAIR

	PlayerText:e_DEALER_STATE,//NAO ESTA PRONTO PARA NEGOCIAR
	PlayerText:e_TRADE_STATE,//ESPERANDO AMBOS NEGOCIANTES MARCAREM PRONTO

	PlayerText:e_BUTTON_MAKE[2],

	PlayerText:e_PREVIEW_MY_OFFER[4],//MINHA OFERTA
	PlayerText:e_PREVIEW_DEALER_OFFER[4]//OFERTA DE ADEJAIR
}
//---------------------------------------------
enum E_GLOBAL_TEXT_INTERACTION
{
	Text:e_TEXT[5],

	Text:e_BUTTON[4]
}
enum E_PLAYER_TEXT_INTERACTION
{
	PlayerText:e_PREVIEW_ITEM
}
//---------------------------------------------
enum E_GLOBAL_TEXT_TRADE_INVITATION
{
	Text:e_BACKGROUND[17],

	Text:e_BUTTON_CLOSE,
	Text:e_BUTTON_LIST_NEXT,
	Text:e_BUTTON_LIST_PREVIOUS,

	Text:e_BUTTON_MARK_CHECKBOX[2],
	Text:e_CHECKBOX[2],

	Text:e_BUTTON_COIN_VALUE,
	Text:e_BUTTON_ITEM_FILTER,

	Text:e_BUTTON_VISUALIZE
}
enum E_PLAYER_TEXT_TRADE_INVITATION
{
	PlayerText:e_BUTTON_TRADE_TYPE[2],
	PlayerText:e_BUTTON_TRADE_TYPE_TEXT[2],
	PlayerText:e_BUTTON_SEND_INVITATION,
	PlayerText:e_BUTTON_SEND_INVITATION_TEXT,
	PlayerText:e_TRADE_INFORMATION_STATE
}
//---------------------------------------------
enum E_INV_ATTRIBUTES
{
	bool:e_INV_OPENED,
	bool:e_TRADE_OPENED,
	bool:e_BUTTON_READY_MARKED,
	e_SLOT_SELECTED
}
enum E_INV_PLAYER
{
	e_ITEM_ID[20],
	e_ITEM_AMMO[20]
}
//---------------------------------------------
enum E_ITEM_PLAYER
{
	e_ITEM_USING,
	e_ITEM_AMMO,
	e_ITEM_ACTION_STATE
}
//---------------------------------------------
enum E_INTERACTION_ITEM
{
	bool:E_INTERACTION_OPENED,
	e_INTERACTION_ITEM_ID,
	e_INTERACTION_ITEM_AMMO
}
//---------------------------------------------
enum E_TRADE_PLAYER
{
	bool:e_TRADE_MENU_OPENED,
	bool:e_TRADING_STARTED,
	e_TRADE_ID,
	e_TRADE_DEALER_ID,
	e_TRADE_TRANS_TYPE,
	e_TRADE_TRANS_TYPE_COIN_VALUE,
	e_TRADE_TRANS_TYPE_ITEM_FILTER,
	e_TRADE_TYPE
}
enum E_TRADE_PLAYER_INVITE
{
	e_PLAYER_FOUND[MAX_PLAYERS],
	e_PLAYER_FOUND_LIST[7],
	PlayerText:e_PLAYER_FOUND_TEXTDRAW[7],
	e_PLAYER_CURRENT_LIST,
	e_PLAYER_LAST_ROUND_LISTED,
	e_PLAYER_FIRST_ROUND_LISTED,
	e_VALUE_TOTAL_FOUND,
	bool:e_BUTTON_NEXT_SHOWED,
	bool:e_BUTTON_PREVIOUS_SHOWED,
	//Float:e_VALUE_INCREASE,
}
//---------------------------------------------
enum E_ARRAY_ITEMS_DATA
{
	e_ITEM_NAME[50],
	e_ITEM_DESCRIPTION[400],
	
	e_ITEM_PREVIEW_OBJECT_ID,
	
	Float:e_ITEM_PREVIEW_ROT[3],
	
	Float:e_ITEM_PREVIEW_ZOOM,
	
	Float:e_ITEM_DROPPED_POS_CFG[5],
}
//---------------------------------------------
enum E_ITEM_DROP_DATA
{
	bool:e_DROP_VALID,

    e_DROP_ITEM_ID,
    e_DROP_ITEM_AMMO,
    
    e_DROP_OBJECT_ID,
	
	e_DROP_WORLD_ID,
	e_DROP_INTERIOR_ID,
	
	Float:e_DROP_POS[3],
	
	Text3D:e_DROP_3DTEXT_ID
}
//---------------------------------------------
enum E_PLAYER_BACKPACK
{
	bool:e_BACKPACK_HAVE,
	e_BACKPACK_STATE,
	e_BACKPACK_TYPE,
	e_BACKPACK_SLOTS
}
//---------------------------------------------
enum a_info
{
	e_ATTACH_SKINID,
	e_ATTACH_INDEX,
	e_ATTACH_MODELID,
	e_ATTACH_BONE,
	Float:e_ATTACH_fOffX,
	Float:e_ATTACH_fOffY,
	Float:e_ATTACH_fOffZ,
	Float:e_ATTACH_fRX,
	Float:e_ATTACH_fRY,
	Float:e_ATTACH_fRZ,
	Float:e_ATTACH_fSX,
	Float:e_ATTACH_fSY,
	Float:e_ATTACH_fSZ,
	e_ATTACH_MAT1,
	e_ATTACH_MAT2
}
/*----------------------------------------------------------------------------*/
/*
	{VARIABELS}
*/
static
	cursorState[MAX_PLAYERS],
	myName[MAX_PLAYERS][MAX_PLAYER_NAME],

	Text:inventoryGlobalText[E_GLOBAL_TEXT_INVENTORY],
	PlayerText:inventoryPlayerText[MAX_PLAYERS][E_PLAYER_TEXT_INVENTORY],

	Text:tradeGlobalText[E_GLOBAL_TEXT_TRADE],
	PlayerText:tradePlayerText[MAX_PLAYERS][E_PLAYER_TEXT_TRADE],

	Text:interactionGlobalText[E_GLOBAL_TEXT_INTERACTION],
	PlayerText:interactionPlayerText[MAX_PLAYERS][E_PLAYER_TEXT_INTERACTION],

	Text:tradeInvitationGlobalText[E_GLOBAL_TEXT_TRADE_INVITATION],
	PlayerText:tradeInvitationPlayerText[MAX_PLAYERS][E_PLAYER_TEXT_TRADE_INVITATION],

	interactionItemPlayer[MAX_PLAYERS][E_INTERACTION_ITEM],

	inventoryAttributes[MAX_PLAYERS][E_INV_ATTRIBUTES],
	
	inventoryPlayer[MAX_PLAYERS][E_INV_PLAYER],

	itemPlayer[MAX_PLAYERS][E_ITEM_PLAYER],

	tradePlayer[MAX_PLAYERS][E_TRADE_PLAYER],

	tradePlayerInvite[MAX_PLAYERS][E_TRADE_PLAYER_INVITE],

	
	dropData[MAX_DROP][E_ITEM_DROP_DATA],
	
	backpackPlayer[MAX_PLAYERS][E_PLAYER_BACKPACK],
/*----------------------------------------------------------------------------*/
/*
	{ARRAYS}
*/
itemsData[MAX_ITEMS][E_ARRAY_ITEMS_DATA],

attachFlashlight[1/*MAX_SKINS*/][a_info] = {
	{171, 6,18641,6,0.075999,0.039999,0.023000,173.500076,6.199996,0.000000,1.000000,1.000000,1.000000,0,0}
},

attachFlashlight_effect[1][a_info] = {
	{171, 7,1559,6,-0.055999,0.144000,1.437997,-4.299995,-5.699996,-0.800000,1.697000,1.397000,1.335999,0,0}
};
/*----------------------------------------------------------------------------*/
/*
	<HOOKS>
*/
my_SelectTextDraw(playerid, hovercolor)
{
	SelectTextDraw(playerid, hovercolor);
	cursorState[playerid] = true;
}
#if defined _ALS_SelectTextDraw
	#undef SelectTextDraw
#else
	#define _ALS_SelectTextDraw
#endif
#define SelectTextDraw my_SelectTextDraw

my_CancelSelectTextDraw(playerid)
{
	cursorState[playerid] = false;
    CancelSelectTextDraw(playerid);
}
#if defined _ALS_CancelSelectTextDraw
	#undef CancelSelectTextDraw
#else
	#define _ALS_CancelSelectTextDraw
#endif
#define CancelSelectTextDraw my_CancelSelectTextDraw
/*----------------------------------------------------------------------------*/
/*
	{CALBACKS}
*/
public OnFilterScriptInit()
{
	INV_CreateGlobalTextDraws();

	INVITE_CreateGlobalTextDraws();
	TRADE_CreateGlobalTextDraws();

	INTERAC_CreateGlobalTextDraws();

	LoadListItems();
	
	print("\n-----------------------------------------");
	print("      [HOG] Inventory System loaded");
	print("-----------------------------------------\n");

	return 1;
}

public OnPlayerConnect(playerid)
{
	INV_CreatePlayerTextDraws(playerid);

	INVITE_CreatePlayerTextDraws(playerid);
	TRADE_CreatePlayerTextDraws(playerid);

	INTERAC_CreatePlayerTextDraws(playerid);
	
	static i;
	for(i = 0; i < 20; i++) ResetInventorySlot(playerid, i, .reset_var = true);

	ResetPlayerInteractionItem(playerid);
	
	GetPlayerName(playerid, myName[playerid], MAX_PLAYER_NAME);
	
	return 1;
}

public OnPlayerSpawn(playerid)
{
    GivePlayerBackpack(playerid, BACKPACK_TYPE_FULL, 10);

	LoadPlayerAnimations(playerid);
    
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(_:clickedid == INVALID_TEXT_DRAW && cursorState[playerid])
	{
	    if(InventoryPlayerIsOpened(playerid)) ClosePlayerInventory(playerid);

	    if(InteractionItemIsOpened(playerid)) ClosePlayerInteractionItem(playerid);
	}
	/*
		INVENTORY BUTTONS
							*/
	if(clickedid == inventoryGlobalText[e_BUTTON][0])//fechar
	{
		ClosePlayerInventory(playerid);
	}
	//---------
	if(clickedid == inventoryGlobalText[e_BUTTON][2])//dropar
	{
		if(InventoryPlayerIsOpened(playerid))
			DropInventorySlot(playerid);
	}
	//---------
	if(clickedid == inventoryGlobalText[e_BUTTON][3])
	{
	    if(InventoryPlayerIsOpened(playerid))
			UseInventorySlot(playerid);
	}
	//---------
	if(clickedid == inventoryGlobalText[e_BUTTON][4])//negociar
	{
		static count[MAX_PLAYERS];

		if(gettime()-count[playerid] < 3) return true;

		count[playerid] = gettime();

		StartPlayerTrade(playerid);
	}
	/*
		TRADE BUTTONS
						*/
	if(clickedid == tradeGlobalText[e_BUTTON][0])
	{
		ClosePlayerTrade(playerid);
	}
	if(clickedid == tradeGlobalText[e_BUTTON][1])
	{
		static bool:clicked;
		
		clicked = inventoryAttributes[playerid][e_BUTTON_READY_MARKED];

		if(clicked) TextDrawHideForPlayer(playerid, tradeGlobalText[e_BUTTON][2]);
		else TextDrawShowForPlayer(playerid, tradeGlobalText[e_BUTTON][2]);
		
		inventoryAttributes[playerid][e_BUTTON_READY_MARKED] = !clicked;
	}
	/*
		INTERACTION ITEMS BUTTONS
									*/
	if(clickedid == interactionGlobalText[e_BUTTON][0])//usar
	{
		if(interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID] != INVALID_ITEM_ID ||
			interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO] != INVALID_AMOUNT)
		{
			OnPlayerUseItemAction(playerid, interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID]);
		}
		
		ClosePlayerInteractionItem(playerid);
	}
	if(clickedid == interactionGlobalText[e_BUTTON][1])//dropar
	{
		DropInteractionItem(playerid);

		ClosePlayerInteractionItem(playerid);
	}
	if(clickedid == interactionGlobalText[e_BUTTON][2])//guardar
	{
		StoreItemOnHandInInventory(playerid);

		ClosePlayerInteractionItem(playerid);
	}
	if(clickedid == interactionGlobalText[e_BUTTON][3])//transferir
	{
		

		ClosePlayerInteractionItem(playerid);
	}
	/*
		INVITATION TRADE
						*/
	if(clickedid == tradeInvitationGlobalText[e_BUTTON_CLOSE])
	{
		HidePlayerInvitationTrade(playerid);
	}
	if(clickedid == tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0] && tradePlayer[playerid][e_TRADE_TRANS_TYPE] != TRANSACTION_TYPE_COIN)
	{
		tradePlayer[playerid][e_TRADE_TRANS_TYPE] = TRANSACTION_TYPE_COIN;

		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][0]);
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][1]);
	}
	if(clickedid == tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1] && tradePlayer[playerid][e_TRADE_TRANS_TYPE] != TRANSACTION_TYPE_ITEM)
	{
		tradePlayer[playerid][e_TRADE_TRANS_TYPE] = TRANSACTION_TYPE_ITEM;

		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][1]);
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][0]);
	}
	if(clickedid == tradeInvitationGlobalText[e_BUTTON_LIST_NEXT])/*próximo*/
	{
		//if(!(1 <= tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]+1 <= 7)) return false;

		TradeFindPlayer_ShowList(playerid, tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]+1, 0);
	}
	if(clickedid == tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS])/*anterior*/
	{
		//if(!(1 <= tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]-1 <= 7)) return false;

		TradeFindPlayer_ShowList(playerid, tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]-1, 1);
	}
    
	return 1;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    /*
		INVENTORY BUTTONS
							*/
	static i;

	if(playertextid == inventoryPlayerText[playerid][e_ITEM_INFO])
	{
	    static cap[76], info[800], name[50], rename[16], ammo, slot, item_id;
		
		slot = inventoryAttributes[playerid][e_SLOT_SELECTED];
		item_id = inventoryPlayer[playerid][e_ITEM_ID][slot];
		
		format(name, 50, itemsData[item_id][e_ITEM_NAME]);
		format(rename, 16, itemsData[item_id][e_ITEM_NAME]);
		ammo = inventoryPlayer[playerid][e_ITEM_AMMO][slot];

        if(strlen(rename) >= 12)
		{
			for(i = 14; i > 14-3; i--)
			{
				rename[i] = '.';
			}
		}

		format(rename, 16, rename);

	    format(cap, 76, "INFORMAÇÕES ITEM {E84F33}%s", rename);//Blablablabla12
	    format(info, 800,"\
		Nome: {E84F33}%s\n{A9C4E4}\
 		Gênero: {E84F33}%s\n{A9C4E4}\
 		Quantidade: {E84F33}%d\n{A9C4E4}\
		%s", name, ("Indisponível"), ammo, AlignMyText(itemsData[item_id][e_ITEM_DESCRIPTION]));

        CancelSelectTextDraw(playerid);
        
		ShowPlayerDialog(playerid, DIALOG_INV_ITEM_INFO, DIALOG_STYLE_MSGBOX, cap, info, "Confirmar", "");
	}
	/*
		PREVIEW ITEMS BUTTONS
								*/
    for(i = 0; i < 20; i++)
    {
		if(playertextid == inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i])
		{
		    if(inventoryPlayer[playerid][e_ITEM_ID][i] == INVALID_ITEM_ID) break;
		    
			if(inventoryAttributes[playerid][e_SLOT_SELECTED] == i) UnSelectInventorySlot(playerid);
			else
			{
			    UnSelectInventorySlot(playerid);
				SelectInventorySlot(playerid, i);
			}
            break;
		}
	}
	/*
		TRADE INVITATION
						*/
	if(playertextid == tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0] && tradePlayer[playerid][e_TRADE_TYPE] != TRADE_TYPE_PERSONAL)
	{
		tradePlayer[playerid][e_TRADE_TYPE] = TRADE_TYPE_PERSONAL;

		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0xFFA500FF);
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], -1);

		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1]);
	}
	if(playertextid == tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1] && tradePlayer[playerid][e_TRADE_TYPE] != TRADE_TYPE_COMMERCIAL)
	{
		tradePlayer[playerid][e_TRADE_TYPE] = TRADE_TYPE_COMMERCIAL;

		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], -1);
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0xFFA500FF);

		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0]);
		PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1]);
	}

	
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys & KEY_YES)
	{
	    if(!InventoryPlayerIsOpened(playerid)) OpenPlayerInventory(playerid);
	}
	
	if(newkeys & KEY_NO)
	{
		if(!OnPlayerUseItemAction(playerid, itemPlayer[playerid][e_ITEM_USING])) GetItemNear(playerid);
	}

	if(newkeys & KEY_CTRL_BACK)
	{
		if(InteractionItemIsOpened(playerid)) ClosePlayerInteractionItem(playerid);
		else OpenPlayerInteractionItem(playerid);
	}

	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case DIALOG_INV_ITEM_INFO: SelectTextDraw(playerid, 0xDDDDDDAA);
	}
	return 1;
}
/*----------------------------------------------------------------------------*/
/*
	{MY CALLBACKS}
*/
call:Back_OpenInventory(playerid)
{
	SetPVarInt(playerid,"openingInventory", false);
    OpenPlayerInventory(playerid);
}
call:Back_CloseInventory(playerid)
{
	inventoryAttributes[playerid][e_INV_OPENED] = false;
	SetPVarInt(playerid,"closingInventory", false);
}
call:Continue_DropInventorySlot(item, index, modelid, Float:pos_x, Float:pos_y, Float:pos_z, Float:rot_x, Float:rot_y, Float:rot_z, worldid, intid)
{
	static i, name[50+16], player_size;
	
	format(name, sizeof(name), "%s{FFFFFF}[%02d]", itemsData[item][e_ITEM_NAME], dropData[index][e_DROP_ITEM_AMMO]);
	
	dropData[index][e_DROP_OBJECT_ID] = CreateDynamicObject(modelid, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, worldid, intid);
	dropData[index][e_DROP_3DTEXT_ID] = CreateDynamic3DTextLabel(name, 0xCCFF00FF, pos_x, pos_y, pos_z, 15.0, .worldid = worldid, .interiorid = intid);

	player_size = GetPlayerPoolSize();
	
	for(i = 0; i <= player_size; i++) if(IsPlayerInRangeOfPoint(i, 15.0, pos_x, pos_y, pos_z)) Streamer_UpdateEx(i, pos_x, pos_y, pos_z, worldid, intid);

	SetTimerEx("Continue_ValidateDropItem", 1000, false, "i", index);
}
call:Continue_ValidateDropItem(index)
{
	dropData[index][e_DROP_VALID] = true;
}
//--------------------
call:Continue_DeleteAndGiveItem(playerid, index, slot)
{
    DestroyDynamicObject(dropData[index][e_DROP_OBJECT_ID]);

	GiveItemToPlayer(playerid, slot, dropData[index][e_DROP_ITEM_ID], dropData[index][e_DROP_ITEM_AMMO]);
}
//--------------------
call:OnPlayerUseInventoryItem(playerid, slot, item)
{
	if(itemPlayer[playerid][e_ITEM_USING] != INVALID_ITEM_ID)
	{
		SendClientMessage(playerid, COLOR_RED, "{FFFFFF} Você já está com algum item em mãos!");
		return;
	}

	static 
		skinid,
		bool:success;
	
	success = false;

	switch(item)
	{
    	case 0://Lanterna
		{
			skinid = FindSkinInArray(GetPlayerSkin(playerid));

			if(!~skinid) goto validate_success;

			SetPlayerAttachedObject(playerid, attachFlashlight[skinid][e_ATTACH_INDEX], attachFlashlight[skinid][e_ATTACH_MODELID],
				attachFlashlight[skinid][e_ATTACH_BONE], attachFlashlight[skinid][e_ATTACH_fOffX], attachFlashlight[skinid][e_ATTACH_fOffY],
				attachFlashlight[skinid][e_ATTACH_fOffZ], attachFlashlight[skinid][e_ATTACH_fRX], attachFlashlight[skinid][e_ATTACH_fRY],
				attachFlashlight[skinid][e_ATTACH_fRZ], attachFlashlight[skinid][e_ATTACH_fSX], attachFlashlight[skinid][e_ATTACH_fSY],
				attachFlashlight[skinid][e_ATTACH_fSZ], attachFlashlight[skinid][e_ATTACH_MAT1], attachFlashlight[skinid][e_ATTACH_MAT2]);
		
			success = true;
		}
	}

	validate_success:

    if(success)
	{
		itemPlayer[playerid][e_ITEM_USING] = inventoryPlayer[playerid][e_ITEM_ID][slot];
		itemPlayer[playerid][e_ITEM_AMMO] = inventoryPlayer[playerid][e_ITEM_AMMO][slot];
		itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_HOLDING;

		if(inventoryPlayer[playerid][e_ITEM_AMMO][slot] > 1)
		{
	    	inventoryPlayer[playerid][e_ITEM_AMMO][slot]--;
	    }
	    else
	    {
			inventoryPlayer[playerid][e_ITEM_ID][slot] = INVALID_ITEM_ID;
	    	inventoryPlayer[playerid][e_ITEM_AMMO][slot] = INVALID_AMOUNT;
	    }

	    if(InventoryPlayerIsOpened(playerid))
			UpdateInventoryPlayer(playerid, INVENTORY_PART_MY_ITEM, true, slot);
		
	}
	else SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Este item não possui uma utilidade, não foi possível usá-lo");
}
call:OnPlayerUseItemAction(playerid, itemID)
{
	static 
		skinid,
		bool:success;

	success = true;

	if(itemPlayer[playerid][e_ITEM_ACTION_STATE] == ITEM_STATE_NONE ||
		itemPlayer[playerid][e_ITEM_USING] == INVALID_ITEM_ID ||
		itemPlayer[playerid][e_ITEM_AMMO] == INVALID_AMOUNT)
	{
		success = false;
		goto end;
	}

	switch(itemID)
	{
		case 0://Lanterna
		{
			switch(itemPlayer[playerid][e_ITEM_ACTION_STATE])
			{
				//ITEM_STATE_NONE | ITEM_STATE_USING | ITEM_STATE_HOLDING
				case ITEM_STATE_USING:
				{
					RemovePlayerAttachedObject(playerid, ITEM_ACTION_ATTACH_INDEX);
					itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_HOLDING;
				}
				case ITEM_STATE_HOLDING:
				{
					SetPlayerAttachedObject(playerid, attachFlashlight_effect[skinid][e_ATTACH_INDEX], attachFlashlight_effect[skinid][e_ATTACH_MODELID],
						attachFlashlight_effect[skinid][e_ATTACH_BONE], attachFlashlight_effect[skinid][e_ATTACH_fOffX], attachFlashlight_effect[skinid][e_ATTACH_fOffY],
						attachFlashlight_effect[skinid][e_ATTACH_fOffZ], attachFlashlight_effect[skinid][e_ATTACH_fRX], attachFlashlight_effect[skinid][e_ATTACH_fRY],
						attachFlashlight_effect[skinid][e_ATTACH_fRZ], attachFlashlight_effect[skinid][e_ATTACH_fSX], attachFlashlight_effect[skinid][e_ATTACH_fSY],
						attachFlashlight_effect[skinid][e_ATTACH_fSZ], attachFlashlight_effect[skinid][e_ATTACH_MAT1], attachFlashlight_effect[skinid][e_ATTACH_MAT2]);
				

					itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_USING;
				}
			}
		}
		default: success = false;
	}

	end:
	if(!success) return false;

	return true;
}
call:ForceStopAnimation(playerid, bool:type)
{
	if(!type) ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 1, 1, 0, 1, 1);
	else ApplyAnimation(playerid, "BD_FIRE", "BD_Fire1", 4.1, 0, 1, 1, 0, 1, 1);
}
/*----------------------------------------------------------------------------*/
/*
	{COMMANDS}
*/
CMD:inv(playerid)
{
    if(InventoryPlayerIsOpened(playerid)) ClosePlayerInventory(playerid);
    else OpenPlayerInventory(playerid);

	return 1;
}
CMD:set(playerid, params[])
{
	static slot, item, ammo;
	
	if(sscanf(params, "ddd", slot, item, ammo)) return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Use: /set <slot id> <item id> <amount>");
	
	if(!(1 <= slot <= 20)) return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Slot fora dos padrões (1 a 20)");
	if(!(0 <= item <= sizeof(itemsData)-1)) return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Item inexistente!");
	if(!(1 <= ammo <= 9999)) return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Quantia irregular! (1 a 9999)");
	
	slot--;
	
	if(inventoryPlayer[playerid][e_ITEM_ID][slot] == UNAVAILABLE_SLOT)
	{
		return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Impossível trabalhar com este slot! O mesmo não está disponível.");
	}
	
    inventoryPlayer[playerid][e_ITEM_ID][slot] = item;
    inventoryPlayer[playerid][e_ITEM_AMMO][slot] = ammo;
    
    UpdateInventoryPlayer(playerid, INVENTORY_PART_MY_ITEM, inventoryAttributes[playerid][e_INV_OPENED], slot);
    
    return 1;
}
CMD:give_backpack(playerid, params[])
{
	static id, type, slots;

	if(sscanf(params, "udd", id, type, slots)) return SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Use: /give_backpack <player id> <tipo> <slots>");

	if(!IsPlayerConnected(id)) return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Este usuário não se encontra conectado!");
	if(!(0 <= type <= 1)) return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Tipos: 0 (BACK_PACK_SIMPLE) | 1 (BACK_PACK_FULL)");
	if(!(1 <= slots <= 20)) return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Slots fora dos padrões (1 a 20)");

	RemovePlayerBackpack(id);

	GivePlayerBackpack(id, type, slots);

	return 1;
}
CMD:remove_backpack(playerid, params[])
{
	static id;
	
	id = strval(params);
	
	if(isnull(params)) return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Use: /remove_bp <player id>");
	if(!IsPlayerConnected(id)) return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Este usuário não se encontra conectado!");
	if(!PlayerHaveBackpack(id))return  SendClientMessage(playerid, COLOR_RED, !"<!> {FFFFFF}Este usuário não possui um inventário!");

	RemovePlayerBackpack(id);
	
    return 1;
}
CMD:lock(playerid)
{
	static i;

	for(i = 0; i < 20; i++) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][i]);
	
	return 1;
}
CMD:ab(playerid)
{
	SetPlayerPos(playerid, 1824.2908,-1102.1575,24.0420);

	return 1;
}
CMD:t(playerid)
{
	TradeFindPlayersNext(playerid);
	TradeFindPlayer_ShowList(playerid, 1, 0);

	return 1;
}
/*----------------------------------------------------------------------------*/
/*
	{FUNCTIONS}
*/
/*-------------------------------
		{GLOBAL FUNCTIONS}		*/
LoadListItems()
{
	static 
		i,
		result[12][400],
		itemsListFile[514*MAX_ITEMS];//514 por linha de cada item

	for(i = 0; i < sizeof(itemsData); i++)
	{
	    format(itemsData[i][e_ITEM_NAME], 50, "");
	    format(itemsData[i][e_ITEM_DESCRIPTION], 400, "");

     	itemsData[i][e_ITEM_PREVIEW_OBJECT_ID] 	= -1;

     	itemsData[i][e_ITEM_PREVIEW_ROT][0] 	= 0.0;
     	itemsData[i][e_ITEM_PREVIEW_ROT][1] 	= 0.0;
     	itemsData[i][e_ITEM_PREVIEW_ROT][2] 	= 0.0;

     	itemsData[i][e_ITEM_PREVIEW_ZOOM] 		= 0.0;
     	itemsData[i][e_ITEM_DROPPED_POS_CFG][0] 	= 0.0;
     	itemsData[i][e_ITEM_DROPPED_POS_CFG][1] 	= 0.0;
     	itemsData[i][e_ITEM_DROPPED_POS_CFG][2] 	= 0.0;
     	itemsData[i][e_ITEM_DROPPED_POS_CFG][3] 	= 0.0;
     	itemsData[i][e_ITEM_DROPPED_POS_CFG][4] 	= 0.0;
	}
	//TEMP:
	new count = GetTickCount();

	new File: file = fopen("inventory/listItems.cfg", io_read);
	if(!fexist("inventory/listItems.cfg"))
	{
		printf("<!> O arquivo ''%s'' não existe.", "inventory/listItems.cfg");
		return;
	}

	printf("\n  > Loading ListItems from ''%s''", "inventory/listItems.cfg");

	if (file)
	{
	    i = 0;
	    while(i < MAX_ITEMS/*sizeof(itemsData)*/)
		{
		    fread(file, itemsListFile);
		    split(itemsListFile, result, '|');

            strmid(itemsData[i][e_ITEM_NAME], result[0], 0, strlen(result[0]), 50);
            strmid(itemsData[i][e_ITEM_DESCRIPTION], result[1], 0, strlen(result[1]), 400);
	     	itemsData[i][e_ITEM_PREVIEW_OBJECT_ID] 	= strval(result[2]);
	     	itemsData[i][e_ITEM_PREVIEW_ROT][0] 	= floatstr(result[3]);
	     	itemsData[i][e_ITEM_PREVIEW_ROT][1] 	= floatstr(result[4]);
	     	itemsData[i][e_ITEM_PREVIEW_ROT][2] 	= floatstr(result[5]);
	     	itemsData[i][e_ITEM_PREVIEW_ZOOM] 		= floatstr(result[6]);
	     	itemsData[i][e_ITEM_DROPPED_POS_CFG][0] 	= floatstr(result[7]);
	     	itemsData[i][e_ITEM_DROPPED_POS_CFG][1] 	= floatstr(result[8]);
	     	itemsData[i][e_ITEM_DROPPED_POS_CFG][2] 	= floatstr(result[9]);
	     	itemsData[i][e_ITEM_DROPPED_POS_CFG][3] 	= floatstr(result[10]);
	     	itemsData[i][e_ITEM_DROPPED_POS_CFG][4] 	= floatstr(result[11]);
			i++;
		}
	}
	fclose(file);

	printf("  * All items loaded in %dms", GetTickCount() - count);
}
/*-------------------------------
	{INVENTORY FUNCTIONS} 		*/
OpenPlayerInventory(playerid)
{
	if(!PlayerHaveBackpack(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Você não possui um inventário!");
		return;
	}

	if(GetPVarInt(playerid,"openingInventory") || GetPVarInt(playerid,"closingInventory") || GetPVarInt(playerid, "endingInteractionDrop")) return;
	
    SetPVarInt(playerid,"openingInventory", true);

    if(backpackPlayer[playerid][e_BACKPACK_STATE] != BACK_ESTATE_STIRRING)
	{
		BackpackSetAction(playerid, BACK_ESTATE_STIRRING);
        return;
	}
	//-----------------------------------
	ConfigurePlayerInventory(playerid);
	//-----------------------------------
	SelectTextDraw(playerid, 0xDDDDDDAA);

	static i;

	for(i = 0; i < 6; i++) TextDrawShowForPlayer(playerid, inventoryGlobalText[e_BACKGROUND][i]);

	for(i = 0; i < 12; i++) TextDrawShowForPlayer(playerid, inventoryGlobalText[e_BUTTON][i]);

	PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_ITEM_INFO]);

	PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN]);

	for(i = 0; i < 20; i++) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i]);

	for(i = 0; i < 4; i++) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][i]);
	
	if(backpackPlayer[playerid][e_BACKPACK_SLOTS] < 20)
	{
	    for(i = backpackPlayer[playerid][e_BACKPACK_SLOTS]; i < 20; i++)
	    {
	        PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][i]);
	    }
	}
	//-----------------------------------
	inventoryAttributes[playerid][e_INV_OPENED] = true;
	SetPVarInt(playerid,"openingInventory", false);
}
ClosePlayerInventory(playerid)
{
	ClosePlayerTrade(playerid);

	CancelSelectTextDraw(playerid);

	static i;

	for(i = 0; i < 6; i++) TextDrawHideForPlayer(playerid, inventoryGlobalText[e_BACKGROUND][i]);

	for(i = 0; i < 12; i++) TextDrawHideForPlayer(playerid, inventoryGlobalText[e_BUTTON][i]);


	PlayerTextDrawHide(playerid, inventoryPlayerText[playerid][e_ITEM_INFO]);

	PlayerTextDrawHide(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN]);


	for(i = 0; i < 20; i++)
		PlayerTextDrawHide(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i]),
	    PlayerTextDrawHide(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][i]);

	for(i = 0; i < 4; i++) PlayerTextDrawHide(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][i]);
	//------------
	BackpackSetAction(playerid, BACK_ESTATE_EQUIPPED);
}
InventoryPlayerIsOpened(playerid) return inventoryAttributes[playerid][e_INV_OPENED];

SelectInventorySlot(playerid, slot)
{
	if(0 > slot > 19) return;
	
	//static str[74], item_id, item_ammo;
	
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot], SELECTED_COLOR);
	PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot]);
	
	UpdateInventoryPlayer(playerid, INVENTORY_PART_ITEM_INFO, true, slot);

	inventoryAttributes[playerid][e_SLOT_SELECTED] = slot;
}
UnSelectInventorySlot(playerid, bool:show = true)
{
	if(inventoryAttributes[playerid][e_SLOT_SELECTED] == INVALID_SLOT_ID) return;
	
	static slot;

	slot = inventoryAttributes[playerid][e_SLOT_SELECTED];
	
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot], UNSELECTED_COLOR);
 	PlayerTextDrawSetString(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], "item: ~r~-");
 	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], false);
	
	if(show)
		PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot]),
		PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_ITEM_INFO]);

	inventoryAttributes[playerid][e_SLOT_SELECTED] = INVALID_SLOT_ID;
}
ConfigurePlayerInventory(playerid)
{
	static i, item_id;
	
	for(i = 0; i < 20; i++)
	{
	    ResetInventorySlot(playerid, i);
	    
	    if(i >= backpackPlayer[playerid][e_BACKPACK_SLOTS])
	    {
	        inventoryPlayer[playerid][e_ITEM_ID][i] = inventoryPlayer[playerid][e_ITEM_AMMO][i] = UNAVAILABLE_SLOT;
            
            PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i], false);
            continue;
	    }
	    
	    item_id = inventoryPlayer[playerid][e_ITEM_ID][i];
	    
	    if(0 > item_id > sizeof(itemsData)-1)
		{
            inventoryPlayer[playerid][e_ITEM_ID][i] = INVALID_ITEM_ID;
            inventoryPlayer[playerid][e_ITEM_AMMO][i] = INVALID_AMOUNT;
			continue;
	    }
	    
	    if(item_id != INVALID_ITEM_ID)
	    {
    		PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i], itemsData[item_id][e_ITEM_PREVIEW_OBJECT_ID]);
			PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i], itemsData[item_id][e_ITEM_PREVIEW_ROT][0], itemsData[item_id][e_ITEM_PREVIEW_ROT][1], itemsData[item_id][e_ITEM_PREVIEW_ROT][2], itemsData[item_id][e_ITEM_PREVIEW_ZOOM]);
		}
	}
	
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], GetPlayerSkin(playerid));
	
	UnSelectInventorySlot(playerid, false);

    inventoryAttributes[playerid][e_BUTTON_READY_MARKED] = false;
}
ResetInventorySlot(playerid, slot, show = false, bool:reset_var = false)
{
	if(!(0 <= slot <= 19)) return;
	
	if(reset_var)
	{
	    if(inventoryPlayer[playerid][e_ITEM_ID][slot] != UNAVAILABLE_SLOT)
			inventoryPlayer[playerid][e_ITEM_ID][slot] = INVALID_ITEM_ID,
			inventoryPlayer[playerid][e_ITEM_AMMO][slot] = INVALID_AMOUNT;
	}
	
    PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot], true);

	if(show) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][slot]);
}
UpdateInventoryPlayer(playerid, partid, bool:show = false, aux = -1)
{
	static i, str[74];

	switch(partid)
	{
	    case INVENTORY_PART_ITEM_INFO:
	    {
	        static slot, item_id, item_ammo, name[50];
			
			slot = aux;//inventoryAttributes[playerid][e_SLOT_SELECTED];
			
			item_id = inventoryPlayer[playerid][e_ITEM_ID][slot];
			item_ammo = inventoryPlayer[playerid][e_ITEM_AMMO][slot];
	    
	        if(slot != INVALID_TEXT_DRAW || slot != UNAVAILABLE_SLOT)
	        {
	            format(name, 50, itemsData[item_id][e_ITEM_NAME]);
	            
	            if(strlen(name) >= 17)
	            {
	                for(i = 17; i > 17-3; i--)
	                {
	                    name[i] = '.';
	                }
	            }
	            
	            format(name, 19, name);
	            
				format(str, 74, "item: ~r~%s~w~(%02d)", name, item_ammo);
				PlayerTextDrawSetString(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], ConvertToGameText(str));
 				PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], true);
			}
			else
				PlayerTextDrawSetString(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], "item: ~r~-"),
				PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], false);
			
			if(InventoryPlayerIsOpened(playerid) && show) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_ITEM_INFO]);
		}
		case INVENTORY_PART_MY_ITEM:
		{
			static item_id;
			
		    if(aux == -1)//all
		    {
				for(i = 0; i < 20; i++)
				{
					if(inventoryPlayer[playerid][e_ITEM_ID][i] == INVALID_ITEM_ID ||
					inventoryPlayer[playerid][e_ITEM_AMMO][i] == INVALID_AMOUNT || inventoryPlayer[playerid][e_ITEM_ID][i] != UNAVAILABLE_SLOT)
					{
						ResetInventorySlot(playerid, i);
					}
					else
					{
					    item_id = inventoryPlayer[playerid][e_ITEM_ID][i];
					    
						PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i], itemsData[item_id][e_ITEM_PREVIEW_OBJECT_ID]);
						PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i], itemsData[item_id][e_ITEM_PREVIEW_ROT][0], itemsData[item_id][e_ITEM_PREVIEW_ROT][1], itemsData[item_id][e_ITEM_PREVIEW_ROT][2], itemsData[item_id][e_ITEM_PREVIEW_ZOOM]);
					}
					if(inventoryAttributes[playerid][e_SLOT_SELECTED] == i) UnSelectInventorySlot(playerid, show);

					if(show) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][i]);
				}
				
		        return;
		    }

			if(inventoryPlayer[playerid][e_ITEM_ID][aux] == INVALID_ITEM_ID ||
			inventoryPlayer[playerid][e_ITEM_AMMO][aux] == INVALID_AMOUNT || inventoryPlayer[playerid][e_ITEM_ID][aux] == UNAVAILABLE_SLOT)
			{
				ResetInventorySlot(playerid, aux);
			}
			else
			{
				item_id = inventoryPlayer[playerid][e_ITEM_ID][aux];

				PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][aux], itemsData[item_id][e_ITEM_PREVIEW_OBJECT_ID]);
				PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][aux], itemsData[item_id][e_ITEM_PREVIEW_ROT][0], itemsData[item_id][e_ITEM_PREVIEW_ROT][1], itemsData[item_id][e_ITEM_PREVIEW_ROT][2], itemsData[item_id][e_ITEM_PREVIEW_ZOOM]);
			}
			if(inventoryAttributes[playerid][e_SLOT_SELECTED] == aux) UnSelectInventorySlot(playerid, show);

			if(show) PlayerTextDrawShow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][aux]);
		}
	}
}
/*-------------------------------
	{DROP FUNCTIONS}			*/
DropInventorySlot(playerid)
{
    static slot, item;

	slot = inventoryAttributes[playerid][e_SLOT_SELECTED];
	item = inventoryPlayer[playerid][e_ITEM_ID][slot];
	
	if(slot == INVALID_TEXT_DRAW || item == INVALID_ITEM_ID) return;
	//----------------------------------
	static i, ammo, modelid, worldid, interiorid, Float:pos[3], Float:angle, Float:dropped_cfg[5];
	
	ammo = inventoryPlayer[playerid][e_ITEM_AMMO][slot];
	
	modelid = itemsData[item][e_ITEM_PREVIEW_OBJECT_ID];
	
	worldid = GetPlayerVirtualWorld(playerid);
	interiorid = GetPlayerInterior(playerid);
	
	dropped_cfg[0] = itemsData[item][e_ITEM_DROPPED_POS_CFG][0];
	dropped_cfg[1] = itemsData[item][e_ITEM_DROPPED_POS_CFG][1];
	dropped_cfg[2] = itemsData[item][e_ITEM_DROPPED_POS_CFG][2];
	dropped_cfg[3] = itemsData[item][e_ITEM_DROPPED_POS_CFG][3];
	dropped_cfg[4] = itemsData[item][e_ITEM_DROPPED_POS_CFG][4];
	
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, angle);
	
	//----------------------------------
	GetXYInFrontOfPlayer(playerid, pos[0], pos[1], dropped_cfg[0]);//0.5

	i = GetDropIndexEmpty();

	if(!~i)
	{
	    SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Ocorreu um erro ao Dropar este item, contate um Administrador");
		return;
	}
	
	inventoryPlayer[playerid][e_ITEM_ID][slot] = INVALID_ITEM_ID;
    inventoryPlayer[playerid][e_ITEM_AMMO][slot] = INVALID_AMOUNT;

    if(InventoryPlayerIsOpened(playerid))
		UpdateInventoryPlayer(playerid, INVENTORY_PART_MY_ITEM, true, slot);
	//----------------------------------
    dropData[i][e_DROP_ITEM_ID] = item;
    dropData[i][e_DROP_ITEM_AMMO] = ammo;
    dropData[i][e_DROP_POS][0] = pos[0];
    dropData[i][e_DROP_POS][1] = pos[1];
    dropData[i][e_DROP_POS][2] = pos[2];
    dropData[i][e_DROP_WORLD_ID] = worldid;
    dropData[i][e_DROP_INTERIOR_ID] = interiorid;
	//----------------------------------
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0, 1);

	SetTimerEx("Continue_DropInventorySlot", 600, false, "iiiffffffii", item, i, modelid, pos[0], pos[1], pos[2]+dropped_cfg[1], dropped_cfg[2],dropped_cfg[3],angle+dropped_cfg[4], worldid,interiorid);
}
DropInteractionItem(playerid)
{
    static itemID, itemAMMO;

	itemID = interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID];
	itemAMMO = interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO];
	
	if(itemID == INVALID_ITEM_ID || itemAMMO == INVALID_AMOUNT)
	{
		SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Não foi possível dropar este item, tente novamente!");
		return;
	}
	//----------------------------------
	static i, modelid, worldid, interiorid, Float:pos[3], Float:angle, Float:dropped_cfg[5];
	
	modelid = itemsData[itemID][e_ITEM_PREVIEW_OBJECT_ID];
	
	worldid = GetPlayerVirtualWorld(playerid);
	interiorid = GetPlayerInterior(playerid);
	
	dropped_cfg[0] = itemsData[itemID][e_ITEM_DROPPED_POS_CFG][0];
	dropped_cfg[1] = itemsData[itemID][e_ITEM_DROPPED_POS_CFG][1];
	dropped_cfg[2] = itemsData[itemID][e_ITEM_DROPPED_POS_CFG][2];
	dropped_cfg[3] = itemsData[itemID][e_ITEM_DROPPED_POS_CFG][3];
	dropped_cfg[4] = itemsData[itemID][e_ITEM_DROPPED_POS_CFG][4];
	
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerFacingAngle(playerid, angle);
	//----------------------------------
	GetXYInFrontOfPlayer(playerid, pos[0], pos[1], dropped_cfg[0]);//0.5

	i = GetDropIndexEmpty();

	if(!~i)
	{
	    SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Ocorreu um erro ao Dropar este item.");
		return;
	}
	
	RemovePlayerAttachedObject(playerid, ITEM_ATTACH_INDEX);
	RemovePlayerAttachedObject(playerid, ITEM_ACTION_ATTACH_INDEX);

	itemPlayer[playerid][e_ITEM_USING] = interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID] = INVALID_ITEM_ID;
	itemPlayer[playerid][e_ITEM_AMMO] = interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO] = INVALID_AMOUNT;
	itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_NONE;

	ClosePlayerInteractionItem(playerid);
	//----------------------------------
    dropData[i][e_DROP_ITEM_ID] = itemID;
    dropData[i][e_DROP_ITEM_AMMO] = itemAMMO;
    dropData[i][e_DROP_POS][0] = pos[0];
    dropData[i][e_DROP_POS][1] = pos[1];
    dropData[i][e_DROP_POS][2] = pos[2];
    dropData[i][e_DROP_WORLD_ID] = worldid;
    dropData[i][e_DROP_INTERIOR_ID] = interiorid;
	//----------------------------------
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 0, 0, 1, 600, 1);
	SetTimerEx("ForceStopAnimation", 700, false, "ib", playerid, false);

	SetTimerEx("Continue_DropInventorySlot", 500/*600*/, false, "iiiffffffii", itemID, i, modelid, pos[0], pos[1], pos[2]+dropped_cfg[1], dropped_cfg[2],dropped_cfg[3],angle+dropped_cfg[4], worldid,interiorid);
}
GetDropIndexEmpty()
{
	static i;

    for(i = 0; i < sizeof(dropData); i++)
 	{
  		if(!dropData[i][e_DROP_VALID])
    	{
    	    return i;
		}
	}
	return -1;
}

GetItemNear(playerid)
{
    if(GetPVarInt(playerid,"openingInventory") || GetPVarInt(playerid,"closingInventory")) return;
    
	static slot, worldid, interiorid, drop_index;

	worldid = GetPlayerVirtualWorld(playerid);
	interiorid = GetPlayerInterior(playerid);
	
	drop_index = GetDropSlotMoreNear(playerid);
	
	if(!~drop_index || worldid != dropData[drop_index][e_DROP_WORLD_ID] || interiorid != dropData[drop_index][e_DROP_INTERIOR_ID]) return;
	
 	slot = FindEmptySlot(playerid, dropData[drop_index][e_DROP_ITEM_ID]);

	if(!~slot)
	{
		SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Você não possui mais espaço em seu invetário!");
		return;
	}

	ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 0, 0, 1, 700, 1);
	SetTimerEx("ForceStopAnimation", 700, false, "ib", playerid, false);
	//----------------------------------
	SetTimerEx("Continue_DeleteAndGiveItem", 500, false, "iii", playerid, drop_index, slot);
	//----------------------------------
	DestroyDynamic3DTextLabel(dropData[drop_index][e_DROP_3DTEXT_ID]);

	dropData[drop_index][e_DROP_POS][0] = 0.0;
	dropData[drop_index][e_DROP_POS][1] = 0.0;
	dropData[drop_index][e_DROP_POS][2] = 0.0;

	dropData[drop_index][e_DROP_VALID] = false;
	//----------------------------------
}

GetDropSlotMoreNear(playerid)
{
	static i, Float:dis, Float:more, more_index;

    more = 4.0;
	more_index = -1;
	
    for(i = 0; i < sizeof(dropData); i++)
    {
        if(!IsPlayerInRangeOfPoint(playerid, 2.0, dropData[i][e_DROP_POS][0], dropData[i][e_DROP_POS][1], dropData[i][e_DROP_POS][2])) continue;
        
        if(!dropData[i][e_DROP_VALID]) continue;//if(dropData[i][e_DROP_POS][0] | dropData[i][e_DROP_POS][1] | dropData[i][e_DROP_POS][2] == 0.0) continue;
        
  		dis = GetPlayerDistanceFromPoint(playerid, dropData[i][e_DROP_POS][0], dropData[i][e_DROP_POS][1], dropData[i][e_DROP_POS][2]);

		if(dis < more) more = dis, more_index = i;
	}
	
	return more_index;
}
/*-------------------------------
	{STORE ITEMS FUNCTIONS}		*/
StoreItemOnHandInInventory(playerid)
{
	static itemID, itemAMMO, slot;

	itemID = itemPlayer[playerid][e_ITEM_USING];
	itemAMMO = itemPlayer[playerid][e_ITEM_AMMO];

	if(itemID == INVALID_ITEM_ID || itemAMMO == INVALID_AMOUNT)
	{
		SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Erro ao guardar item no invetário!");
		return;
	}

	slot = FindEmptySlot(playerid, itemID);

	if(!~slot)
	{
		SendClientMessage(playerid, COLOR_RED, "<!>{FFFFFF} Você não possui mais espaço em seu invetário!");
		return;
	}
	ApplyAnimation(playerid, "PED", "PHONE_IN", 4.0, 1, 0, 0, 0, 300);

	SetTimerEx("Continue_StoreItem", 250, false, "iiiii", 0, playerid, slot, itemID, itemAMMO);

	itemPlayer[playerid][e_ITEM_USING] = interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID] = INVALID_ITEM_ID;
	itemPlayer[playerid][e_ITEM_AMMO] = interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO] = INVALID_AMOUNT;
	itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_NONE;

	SetPVarInt(playerid, "endingInteractionDrop", true);

	return;
}
call:Continue_StoreItem(type, playerid, slot, itemID, itemAMMO)
{
	if(type)
	{
		SetPVarInt(playerid, "endingInteractionDrop", false);
		return;
	}

	GiveItemToPlayer(playerid, slot, itemID, itemAMMO);

	RemovePlayerAttachedObject(playerid, ITEM_ATTACH_INDEX);
	RemovePlayerAttachedObject(playerid, ITEM_ACTION_ATTACH_INDEX);

	SetTimerEx("Continue_StoreItem", 350, false, "iiiii", 1, playerid, slot, itemID, itemAMMO);
}
/*-------------------------------
	{USE FUNCTIONS}				*/
UseInventorySlot(playerid)
{
	static slot, item;
	
	slot = inventoryAttributes[playerid][e_SLOT_SELECTED];
	item = inventoryPlayer[playerid][e_ITEM_ID][slot];

	if(slot == INVALID_TEXT_DRAW || slot == UNAVAILABLE_SLOT || item == INVALID_ITEM_ID) return;
	
	OnPlayerUseInventoryItem(playerid, slot, item);
}

FindSkinInArray(skinid)
{
	static i;

	for(i = 0; i < sizeof(attachFlashlight); i++)
	{
	    if(skinid == attachFlashlight[i][e_ATTACH_SKINID]) return i;
	}
	
	return -1;
}
/*-------------------------------
	{INTERACTION ITEM FUNCTIONS}*/
OpenPlayerInteractionItem(playerid)
{
	if(InteractionItemIsOpened(playerid) || GetPVarInt(playerid, "endingInteractionDrop") || GetPVarInt(playerid,"openingInventory")) return false;

	static i, itemID, itemAMMO;

	itemID = itemPlayer[playerid][e_ITEM_USING];
	itemAMMO = itemPlayer[playerid][e_ITEM_AMMO];

	if(itemID == INVALID_ITEM_ID || itemAMMO == INVALID_AMOUNT) return false;

	SelectTextDraw(playerid, 0xDDDDDDAA);

	for(i = 0; i < 7; i++)
	{
		TextDrawShowForPlayer(playerid, interactionGlobalText[e_TEXT][i]);
		
		if(i != 4) TextDrawShowForPlayer(playerid, interactionGlobalText[e_BUTTON][i]);
	}

	PlayerTextDrawSetPreviewModel(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], itemsData[itemID][e_ITEM_PREVIEW_OBJECT_ID]);
	PlayerTextDrawSetPreviewRot(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], itemsData[itemID][e_ITEM_PREVIEW_ROT][0], itemsData[itemID][e_ITEM_PREVIEW_ROT][1], itemsData[itemID][e_ITEM_PREVIEW_ROT][2], itemsData[itemID][e_ITEM_PREVIEW_ZOOM]);

	PlayerTextDrawShow(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM]);
	
	interactionItemPlayer[playerid][E_INTERACTION_OPENED] = true;

	interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID] = itemID;
	interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO] = itemAMMO;

	return true;
}
ClosePlayerInteractionItem(playerid)
{
	if(!InteractionItemIsOpened(playerid)) return false;

	static i;

	CancelSelectTextDraw(playerid);

	for(i = 0; i < 7; i++)
	{
		TextDrawHideForPlayer(playerid, interactionGlobalText[e_TEXT][i]);
	
		if(i != 4) TextDrawHideForPlayer(playerid, interactionGlobalText[e_BUTTON][i]);
	}

	PlayerTextDrawHide(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM]);
	
	interactionItemPlayer[playerid][E_INTERACTION_OPENED] = false;

	interactionItemPlayer[playerid][e_INTERACTION_ITEM_ID] = INVALID_ITEM_ID;
	interactionItemPlayer[playerid][e_INTERACTION_ITEM_AMMO] = INVALID_AMOUNT;

	return true;
}
InteractionItemIsOpened(playerid) return interactionItemPlayer[playerid][E_INTERACTION_OPENED];
ResetPlayerInteractionItem(playerid)
{
	itemPlayer[playerid][e_ITEM_USING] = INVALID_ITEM_ID;
	itemPlayer[playerid][e_ITEM_AMMO] = INVALID_AMOUNT;
	itemPlayer[playerid][e_ITEM_ACTION_STATE] = ITEM_STATE_NONE;
}
/*-------------------------------
	{GIVE/REMOVE ITEM FUNCTIONS}*/
GiveItemToPlayer(playerid, slot, itemid, ammo)
{
    if(inventoryPlayer[playerid][e_ITEM_AMMO][slot] == INVALID_AMOUNT)
        inventoryPlayer[playerid][e_ITEM_AMMO][slot] = 0;

	inventoryPlayer[playerid][e_ITEM_ID][slot] = itemid;
	inventoryPlayer[playerid][e_ITEM_AMMO][slot] += ammo;

    if(InventoryPlayerIsOpened(playerid))
		UpdateInventoryPlayer(playerid, INVENTORY_PART_MY_ITEM, true, slot);
}
FindEmptySlot(playerid, itemID = -1)
{
	static i;

	if(itemID != -1)
	{
		for(i = 0; i < 20; i++)
	    {
	    	if(inventoryPlayer[playerid][e_ITEM_ID][i] == UNAVAILABLE_SLOT) continue;

			if(itemID == inventoryPlayer[playerid][e_ITEM_ID][i]) return i;
		}
	}

	for(i = 0; i < 20; i++)
    {
        if(inventoryPlayer[playerid][e_ITEM_ID][i] == UNAVAILABLE_SLOT) continue;
        
        //if(itemID != -1 && itemID == inventoryPlayer[playerid][e_ITEM_ID][i]) return i;
        
        if(inventoryPlayer[playerid][e_ITEM_ID][i] == INVALID_ITEM_ID ||
        inventoryPlayer[playerid][e_ITEM_AMMO][i] == INVALID_AMOUNT)
        {
            return i;
        }
	}
	return INVALID_ITEM_ID;
}
/*-------------------------------
	{TRADE FUNCTIONS} 	      	*/
StartPlayerTrade(playerid)
{
	if(PlayerIsInTradeMenu(playerid))
	{
		SendClientMessage(playerid, COLOR_RED, "<!> {FFFFFF}Você já está com o menu de negociação em aberto!");
		return false;
	}
	ShowPlayerInvitationTrade(playerid);

	return true;
}
PlayerIsInTradeMenu(playerid) return tradePlayer[playerid][e_TRADE_MENU_OPENED];
ShowPlayerInvitationTrade(playerid)
{
	static i;

	for(i = 0; i < 17; i++)
	{
		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BACKGROUND][i]);
		switch(i)
		{
			case 12: TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_COIN_VALUE]);
			case 13: TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER]);
			case 15: TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_VISUALIZE]);
		}
	}

	TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0]);
	TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1]);
	if(tradePlayer[playerid][e_TRADE_TRANS_TYPE] == TRANSACTION_TYPE_COIN)
	{
		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][0]);
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][1]);
	}
	else
	{
		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][1]);
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][0]);
	}

	if(tradePlayer[playerid][e_TRADE_TYPE] == TRADE_TYPE_PERSONAL)
	{
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0xFFA500FF);
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], -1);
	}
	else
	{
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], -1);
		PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0xFFA500FF);
	}

	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0]);
	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1]);
	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0]);
	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1]);

	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION]);
	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT]);

	TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_CLOSE]);
	TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_NEXT]);

	PlayerTextDrawShow(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE]);

	tradePlayer[playerid][e_TRADE_MENU_OPENED] = true;
}
HidePlayerInvitationTrade(playerid)
{
	if(!PlayerIsInTradeMenu(playerid)) return false;

	static i;

	for(i = 0; i < 17; i++)
	{
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BACKGROUND][i]);
	}

	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_COIN_VALUE]);
	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER]);
	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_VISUALIZE]);

	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0]);
	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][0]);

	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1]);
	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_CHECKBOX][1]);

	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0]);
	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1]);
	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0]);
	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1]);

	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION]);
	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT]);

	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_CLOSE]);
	TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_NEXT]);

	PlayerTextDrawHide(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE]);

	tradePlayer[playerid][e_TRADE_MENU_OPENED] = false;

	return true;
}
TradeFindPlayersNext(playerid)//parei aqui acho, sei la mó fuzue
{
	TradeFindPlayer_RESET(playerid);

	static i, player_size, Float:pos[3];

	player_size = GetPlayerPoolSize();
	
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);

	for(i = 0; i <= player_size; i++)
	{
		if(IsPlayerInRangeOfPoint(i, 10.0, pos[0], pos[1], pos[2]) && i != playerid)
		{
			TradeFindPlayer_Add(playerid, i);
		}
	}

	return true;
}
TradeFindPlayer_ShowList(playerid, listID, type)
{
	#define TYPE_NEXT 		0
	#define TYPE_PREVIOUS	1

	//if(!(1 <= listID <= 7)) return false;
	if(listID < 1) return false;

	static Float:total_found, list_pages, ultimateRound, i, id;

	total_found = tradePlayerInvite[playerid][e_VALUE_TOTAL_FOUND];

	if(total_found < 1) return false;

	list_pages = floatround(total_found/7, floatround_ceil);

	if(listID > list_pages) return false;

	tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST] = listID;

	ultimateRound = tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED];

	SendClientMessageEx(playerid, -1, "total_found = %.2f | list_pages = %d | ultimateRound = %d", total_found, list_pages, ultimateRound);

	TradeFindPlayer_RemoveListNames(playerid);

	static bool:removeButtonNext;

	removeButtonNext = false;

	if(type == TYPE_NEXT)
	{
		if(!tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED])
		{
			tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED] = true;
		}

		tradePlayerInvite[playerid][e_PLAYER_FIRST_ROUND_LISTED] = ultimateRound;

		//TEMP:
		SendClientMessage(playerid, -1, "__________________");
		SendClientMessage(playerid, -1, "DEBUG: TYPE_NEXT");

		for(i = ultimateRound; i < listID*7; i++)
		{
			id = tradePlayerInvite[playerid][e_PLAYER_FOUND][i];

			tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED] = i+1;

			SendClientMessageEx(playerid, -1, "id = %d", id);
			if(!~id)
			{
				removeButtonNext = true;

				continue;
			}
			SendClientMessageEx(playerid, -1, "> %d ok", id);

			TradeFindPlayer_CreateTextDraw(playerid, id, true);

			if(i == (listID*7)-1) tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED] = i+1;

			if(removeButtonNext)
			{
				removeButtonNext = false;
			}
		}

		//TEMP:
		SendClientMessage(playerid, -1, "__________________");
	}
	else if(type == TYPE_PREVIOUS)
	{
		static firstRound;

		if(!tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED])
		{
			TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_NEXT]);
			tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED] = true;
		}

		firstRound = tradePlayerInvite[playerid][e_PLAYER_FIRST_ROUND_LISTED];

		//TEMP:
		SendClientMessage(playerid, -1, "_______________________");
		SendClientMessage(playerid, -1, "DEBUG: TYPE_PREVIOUS");

		for(i = firstRound-7; i < firstRound+1; i++)
		{
			id = tradePlayerInvite[playerid][e_PLAYER_FOUND][i];

			SendClientMessageEx(playerid, -1, "{PREV} id = %d", id);
			if(!~id) continue;

			SendClientMessageEx(playerid, -1, "{PREV} > %d ok", id);

			TradeFindPlayer_CreateTextDraw(playerid, id, true);

			if(i == firstRound) tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED] = firstRound, tradePlayerInvite[playerid][e_PLAYER_FIRST_ROUND_LISTED] = firstRound-7;
		}

		//TEMP:
		SendClientMessage(playerid, -1, "_______________________");
	}

	if(removeButtonNext && tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED])
	{
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_NEXT]);
		tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED] = false;
	}
	else
	{
		/*
			//parei aqui: removendo botão 'Próximo' quando acabar a lista; falta colocar o loop de volta, pois o próximo player da
			lista pode não estar online enquanto os demais estão...mas mesmo inserindo o loop, numa probabilidade muito pequena,
			todos os próximos 7 da lista poderão estar offline também ou longe, então será necessário fazer uma nova função para
			renovar a lista validando se os players estão online e próximos.
		*/
		/*TradeFindPlayer_ShowList(playerid, tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]+1, 0);
		TradeFindPlayer_ShowList(playerid, listID 											   , type)*/
		static _listID, Float:_total_found, _list_pages, _ultimateRound, _id;

		/*------------------------------------------------------------*/
		_listID = tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST]+1;
		/*------------------------------------------------------------*/
		_total_found = tradePlayerInvite[playerid][e_VALUE_TOTAL_FOUND];

		if(_total_found < 1) goto _removeButtonNext;

		_list_pages = floatround(_total_found/7, floatround_ceil);

		if(_listID > _list_pages) goto _removeButtonNext;

		_ultimateRound = tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED];

		_id = tradePlayerInvite[playerid][e_PLAYER_FOUND][_ultimateRound];

		if(!~_id)
		{
			_removeButtonNext:

			TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_NEXT]);
			tradePlayerInvite[playerid][e_BUTTON_NEXT_SHOWED] = false;
		}
	}
	/*------------------------------------------------------------*/
	if(listID > 1 && !tradePlayerInvite[playerid][e_BUTTON_PREVIOUS_SHOWED])
	{
		TextDrawShowForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS]);
		tradePlayerInvite[playerid][e_BUTTON_PREVIOUS_SHOWED] = true;
	}

	if(listID <= 1 && tradePlayerInvite[playerid][e_BUTTON_PREVIOUS_SHOWED])
	{
		TextDrawHideForPlayer(playerid, tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS]);
		tradePlayerInvite[playerid][e_BUTTON_PREVIOUS_SHOWED] = false;
	}

	return true;
}
TradeFindPlayer_RESET(playerid)
{
	static i;

	tradePlayerInvite[playerid][e_VALUE_TOTAL_FOUND] = 0;

	tradePlayerInvite[playerid][e_PLAYER_CURRENT_LIST] = 0;
	tradePlayerInvite[playerid][e_PLAYER_LAST_ROUND_LISTED] = 0;

	for(i = 0; i < MAX_PLAYERS; i++)
	{
		tradePlayerInvite[playerid][e_PLAYER_FOUND][i] = -1;
	}

	for(i = 0; i < 7; i++)
	{
		tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i] = -1;
	}

	TradeFindPlayer_CreateListNames(playerid);
}
TradeFindPlayer_CreateListNames(playerid)
{
	static i, Float:value;

	value = 180.083404;

	for(i = 0; i < 7; i ++)
	{
		tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i] = CreatePlayerTextDraw(playerid, 461.764831, value, "-");
		PlayerTextDrawTextSize(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 461.764831+123.0, 4.5);
		PlayerTextDrawLetterSize(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 0.167059, 0.654995);
		PlayerTextDrawAlignment(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 1);
		PlayerTextDrawColor(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], -1);
		PlayerTextDrawSetShadow(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 0);
		PlayerTextDrawSetOutline(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 0);
		PlayerTextDrawBackgroundColor(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 255);
		PlayerTextDrawFont(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 2);
		PlayerTextDrawSetProportional(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 1);
		PlayerTextDrawSetShadow(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], 0);
		PlayerTextDrawSetSelectable(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], true);

		value += 6.0;
	}
}
TradeFindPlayer_DeleteListNames(playerid)
{
	static i;

	for(i = 0; i < 7; i ++)
	{
		if(!~tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i]) continue;
		PlayerTextDrawDestroy(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i]);
		tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i] = -1;
	}
}
TradeFindPlayer_RemoveListNames(playerid)
{
	static i;

	for(i = 0; i < 7; i ++)
	{
		if(!~tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i]) continue;
		PlayerTextDrawSetString(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][i], "");
		tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i] = -1;
	}
}
TradeFindPlayer_WasAdded(playerid, playerFound)
{
	static i;

	for(i = 0; i < MAX_PLAYERS; i++)
	{
		if(tradePlayerInvite[playerid][e_PLAYER_FOUND][i] == playerFound) return true;
	}
	return false;
}
TradeFindPlayer_Add(playerid, playerFound)
{
	if(TradeFindPlayer_WasAdded(playerid, playerFound)) return;

	static valueTotal;

	valueTotal = tradePlayerInvite[playerid][e_VALUE_TOTAL_FOUND];

	if(!(0 <= valueTotal < MAX_PLAYERS)) return;

	tradePlayerInvite[playerid][e_PLAYER_FOUND][valueTotal] = playerFound;
	tradePlayerInvite[playerid][e_VALUE_TOTAL_FOUND]++;
}
TradeFindPlayer_CreateTextDraw(playerid, playerFound, bool:show)//parei aqui: Falta apenas agora testar as páginas Próxima e Anterior; E grifar a TextDraw que foi selecionada.
{
	if(!TradeFindPlayer_WasAdded(playerid, playerFound)) return false;
	
	static i, positionList;

	positionList = -1;
	for(i = 0; i < 7; i++)
	{
		if(!~tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][i])
		{
			positionList = i;
			break;
		}
	}
	if(!~positionList) return false;

	PlayerTextDrawSetString(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][positionList], myName[playerFound]);

	if(show) PlayerTextDrawShow(playerid, tradePlayerInvite[playerid][e_PLAYER_FOUND_TEXTDRAW][positionList]);

	tradePlayerInvite[playerid][e_PLAYER_FOUND_LIST][positionList] = playerFound;

	SendClientMessageEx(playerid, -1, "%d mostrada", playerFound);

	return true;
}
/*-------------------------------------------------------------------------------------------------------------*/
OpenPlayerTrade(playerid)
{
	static i;

	for(i = 0; i < 13; i++) TextDrawShowForPlayer(playerid, tradeGlobalText[e_BACKGROUND][i]);

	TextDrawShowForPlayer(playerid, tradeGlobalText[e_BUTTON][0]);
	TextDrawShowForPlayer(playerid, tradeGlobalText[e_BUTTON][1]);


	PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_DEALER_NAME]);

	PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_DEALER_STATE]);

	PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_TRADE_STATE]);


	PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0]);
	PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1]);


	for(i = 0; i < 4; i++) PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][i]);

	for(i = 0; i < 4; i++) PlayerTextDrawShow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][i]);
	
	inventoryAttributes[playerid][e_TRADE_OPENED] = true;
}
ClosePlayerTrade(playerid)
{
	static i;

	for(i = 0; i < 13; i++) TextDrawHideForPlayer(playerid, tradeGlobalText[e_BACKGROUND][i]);

	TextDrawHideForPlayer(playerid, tradeGlobalText[e_BUTTON][0]);
	TextDrawHideForPlayer(playerid, tradeGlobalText[e_BUTTON][1]);
	TextDrawHideForPlayer(playerid, tradeGlobalText[e_BUTTON][2]);


	PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_DEALER_NAME]);

	PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_DEALER_STATE]);

	PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_TRADE_STATE]);


	PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0]);
	PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1]);


	for(i = 0; i < 4; i++) PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][i]);

	for(i = 0; i < 4; i++) PlayerTextDrawHide(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][i]);
	
	inventoryAttributes[playerid][e_TRADE_OPENED] = false;
}
InventoryTradeIsOpened(playerid) return inventoryAttributes[playerid][e_TRADE_OPENED];
/*-------------------------------
	{BACKPACK}                  */
GivePlayerBackpack(playerid, type, slots)
{
	if(type == BACKPACK_TYPE_FULL)
		SetPlayerAttachedObject(playerid, BACKPACK_INDEX,19559,1,0.101000,-0.034000,0.000000,0.000000,88.099990,0.000000,1.000000,1.000000,1.000000);
	else
		SetPlayerAttachedObject(playerid, BACKPACK_INDEX,3026,1,-0.168999,-0.094999,-0.008999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);
	
	backpackPlayer[playerid][e_BACKPACK_HAVE] = true;
	backpackPlayer[playerid][e_BACKPACK_TYPE] = type;
	backpackPlayer[playerid][e_BACKPACK_SLOTS] = slots;
	
	backpackPlayer[playerid][e_BACKPACK_STATE] = BACK_ESTATE_EQUIPPED;
}
RemovePlayerBackpack(playerid)
{
	if(!PlayerHaveBackpack(playerid)) return;
	
	RemovePlayerAttachedObject(playerid, BACKPACK_INDEX);

    backpackPlayer[playerid][e_BACKPACK_HAVE] = false;

    static i;

    for(i = 0; i < 20; i++)
	{
		inventoryPlayer[playerid][e_ITEM_ID][i] = INVALID_ITEM_ID;
		inventoryPlayer[playerid][e_ITEM_AMMO][i] = INVALID_AMOUNT;
	}
            
}
PlayerHaveBackpack(playerid) return backpackPlayer[playerid][e_BACKPACK_HAVE];

BackpackSetAction(playerid, actionid)
{
	RemovePlayerAttachedObject(playerid, BACKPACK_INDEX);

	backpackPlayer[playerid][e_BACKPACK_STATE] = actionid;

    if(actionid == BACK_ESTATE_STIRRING)
    {
        if(backpackPlayer[playerid][e_BACKPACK_TYPE] == BACKPACK_TYPE_FULL)
			SetPlayerAttachedObject(playerid, BACKPACK_INDEX,19559,9,-0.153999,0.398000,0.348999,-2.399999,-90.199974,-8.399995,1.000000,1.000000,1.000000);
        else
			SetPlayerAttachedObject(playerid, BACKPACK_INDEX,3026,9,0.132999,0.327999,0.388999,14.100000,0.600000,-168.900070,1.000000,1.000000,1.000000);

        ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.1, 0, 1, 1, 1, 0, 1);
        SetTimerEx("Back_OpenInventory", 800, false, "i", playerid);

		return;
	}
    //BACK_ESTATE_EQUIPPED:
    if(backpackPlayer[playerid][e_BACKPACK_TYPE] == BACKPACK_TYPE_FULL)
		SetPlayerAttachedObject(playerid, BACKPACK_INDEX,19559,1,0.101000,-0.034000,0.000000,0.000000,88.099990,0.000000,1.000000,1.000000,1.000000);
    else
		SetPlayerAttachedObject(playerid, BACKPACK_INDEX,3026,1,-0.168999,-0.094999,-0.008999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000);

    ApplyAnimation(playerid, "BOMBER", "BOM_Plant_2Idle", 4.1, 0, 1, 1, 0, 1, 1);

    SetPVarInt(playerid,"closingInventory", true);
	SetTimerEx("Back_CloseInventory", 1200, false, "i", playerid);
}
/*-------------------------------
	{MY COMPLEMENTS} 	      	*/
AlignMyText(string[]/*, mySize = sizeof(myString)*/)//Especialidade: {E84F33}
{
	//new myString[] = "Especialidade: {E84F33}Olá mundo, este é apenas o primeiro texto de muitos. Eu realmente sempre quis assim, como posso dizer, \"Brilar\" né, então agradeço muito a todos que sempre apoiaram.";

	static i, size, myString[300+24], mySize;

	format(myString, sizeof(myString), "Especialidade: {E84F33}%s", string);

	mySize = sizeof(myString);

	if(strlen(myString) > 46)
	{
	    for(i = 46; i < mySize; i++)
		{
			if(myString[i] == 0x20/*' '*/)
			{
			    myString[i] = '\n';
			    break;
			}
		}
	}
	else return myString;

	size = strlen(myString)/38;

	for(i = 1; i < size+1; i++)
	{
	    for(new a = i*38+46; a < mySize; a++)
		{
			if(myString[a] == 0x20/*' '*/)
			{
			    myString[a] = '\n';
			    break;
			}
		}
	}

	return myString;
}
LoadPlayerAnimations(playerid)
{
    ApplyAnimation(playerid, "BOMBER", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "DEALER", "null", 0.0, 0, 0, 0, 0, 0);
    ApplyAnimation(playerid, "BD_FIRE", "null", 0.0, 0, 0, 0, 0, 0);
}
ConvertToGameText(in[])
{
    new i, string[256];
    for(i = 0; in[i]; ++i)
    {
        string[i] = in[i];
        switch(string[i])
        {
            case 0xC0 .. 0xC3: string[i] -= 0x40;
            case 0xC7 .. 0xC9: string[i] -= 0x42;
            case 0xD2 .. 0xD5: string[i] -= 0x44;
            case 0xD9 .. 0xDC: string[i] -= 0x47;
            case 0xE0 .. 0xE3: string[i] -= 0x49;
            case 0xE7 .. 0xEF: string[i] -= 0x4B;
            case 0xF2 .. 0xF5: string[i] -= 0x4D;
            case 0xF9 .. 0xFC: string[i] -= 0x50;
            case 0xC4, 0xE4: string[i] = 0x83;
            case 0xC6, 0xE6: string[i] = 0x84;
            case 0xD6, 0xF6: string[i] = 0x91;
            case 0xD1, 0xF1: string[i] = 0xEC;
            case 0xDF: string[i] = 0x96;
            case 0xBF: string[i] = 0xAF;
        }
    }
    return string;
}
GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)//BY: unknown
{
    new Float:a;
    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);
    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}
split(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
	    if(strsrc[i]==delimiter || i==strlen(strsrc)){
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
}
/*-------------------------------
	{CREATE MY TEXTDRAWS}       */
INV_CreateGlobalTextDraws()
{
	/*
		BACKGROUND
					*/
	inventoryGlobalText[e_BACKGROUND][0] = TextDrawCreate(163.652618, 149.750000, "box");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][0], 0.000000, 22.047061);
	TextDrawTextSize(inventoryGlobalText[e_BACKGROUND][0], 444.358306, 0.000000);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][0], 1);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][0], -1);
	TextDrawUseBox(inventoryGlobalText[e_BACKGROUND][0], 1);
	TextDrawBoxColor(inventoryGlobalText[e_BACKGROUND][0], 102);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][0], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][0], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][0], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][0], 0);

	inventoryGlobalText[e_BACKGROUND][1] = TextDrawCreate(161.580902, 147.050079, "LD_PLAN:tvbase");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BACKGROUND][1], 284.973419, 17.103338);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][1], 1);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][1], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][1], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][1], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][1], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][1], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][1], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][1], 0);

	inventoryGlobalText[e_BACKGROUND][2] = TextDrawCreate(267.711914, 190.400131, "LD_PLAN:tvbase");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][2], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BACKGROUND][2], 157.114364, 148.353454);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][2], 1);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][2], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][2], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][2], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][2], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][2], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][2], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][2], 0);

	inventoryGlobalText[e_BACKGROUND][3] = TextDrawCreate(210.458908, 318.515747, "LD_POOL:ball");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][3], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BACKGROUND][3], 50.941143, 21.750005);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][3], 1);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][3], 824979967);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][3], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][3], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][3], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][3], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][3], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][3], 0);

	inventoryGlobalText[e_BACKGROUND][4] = TextDrawCreate(165.264831, 168.900177, "LD_PLAN:tvbase");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BACKGROUND][4], 40.408424, 158.270156);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][4], 1);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][4], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][4], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][4], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][4], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][4], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][4], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][4], 0);

	inventoryGlobalText[e_BACKGROUND][5] = TextDrawCreate(303.717315, 148.000061, "INVENTARIO");
	TextDrawLetterSize(inventoryGlobalText[e_BACKGROUND][5], 0.400000, 1.600000);
	TextDrawAlignment(inventoryGlobalText[e_BACKGROUND][5], 2);
	TextDrawColor(inventoryGlobalText[e_BACKGROUND][5], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][5], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BACKGROUND][5], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BACKGROUND][5], 255);
	TextDrawFont(inventoryGlobalText[e_BACKGROUND][5], 1);
	TextDrawSetProportional(inventoryGlobalText[e_BACKGROUND][5], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BACKGROUND][5], 0);
	/*
		BUTTONS
				*/
	inventoryGlobalText[e_BUTTON][0] = TextDrawCreate(430.976470, 148.333480, "LD_BEAT:cross");//close
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][0], 14.235260, 15.333327);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][0], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][0], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][0], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][0], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][0], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][0], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][0], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][0], 0);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][0], true);

	inventoryGlobalText[e_BUTTON][1] = TextDrawCreate(165.394287, 328.849975, "LD_PLAN:tvbase");//dropar
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][1], 40.408424, 15.446840);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][1], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][1], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][1], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][1], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][1], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][1], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][1], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][1], 0);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][1], true);

	inventoryGlobalText[e_BUTTON][2] = TextDrawCreate(270.176635, 320.900024, "LD_SPAC:white");//DROPAR
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][2], 59.882339, 15.333310);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][2], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][2], -353437185);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][2], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][2], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][2], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][2], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][2], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][2], 0);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][2], true);

	inventoryGlobalText[e_BUTTON][3] = TextDrawCreate(331.352783, 320.900024, "LD_SPAC:white");//USAR
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][3], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][3], 29.294086, 15.333310);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][3], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][3], -353437185);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][3], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][3], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][3], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][3], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][3], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][3], 0);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][3], true);

	inventoryGlobalText[e_BUTTON][4] = TextDrawCreate(361.941162, 320.900024, "LD_SPAC:white");//NEGOCIAR
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][4], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][4], 59.882339, 15.333310);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][4], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][4], -353437185);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][4], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][4], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][4], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][4], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][4], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][4], 0);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][4], true);
	//-----------------------------------------------------------------------------------------------------
	inventoryGlobalText[e_BUTTON][5] = TextDrawCreate(166.877136, 329.799804, "dropar");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][5], 0.229175, 1.273331);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][5], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][5], -1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][5], 340);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][5], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][5], 0);
	TextDrawFont(inventoryGlobalText[e_BUTTON][5], 2);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][5], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][5], 340);

	inventoryGlobalText[e_BUTTON][6] = TextDrawCreate(283.111907, 322.649810, "DROPAR");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][6], 0.229175, 1.273331);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][6], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][6], 824979967);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][6], 340);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][6], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][6], 0);
	TextDrawFont(inventoryGlobalText[e_BUTTON][6], 2);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][6], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][6], 340);

	inventoryGlobalText[e_BUTTON][7] = TextDrawCreate(333.935821, 322.466522, "USAR");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][7], 0.229175, 1.273331);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][7], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][7], 824979967);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][7], 340);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][7], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][7], 0);
	TextDrawFont(inventoryGlobalText[e_BUTTON][7], 2);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][7], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][7], 340);

	inventoryGlobalText[e_BUTTON][8] = TextDrawCreate(369.229370, 322.649810, "NEGOCIAR");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][8], 0.229175, 1.273331);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][8], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][8], 824979967);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][8], 340);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][8], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][8], 0);
	TextDrawFont(inventoryGlobalText[e_BUTTON][8], 2);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][8], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][8], 340);
	
	inventoryGlobalText[e_BUTTON][9] = TextDrawCreate(414.106292/*-2.0*/, 144.983398, "LD_BEAT:chit");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][9], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][9], 19.921169, 21.960035);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][9], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][9], 255);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][9], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][9], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][9], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][9], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][9], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][9], 0);

	inventoryGlobalText[e_BUTTON][10] = TextDrawCreate(415.247528/*-2.0*/, 146.400192, "LD_BEAT:chit");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][10], 0.000000, 0.000000);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][10], 17.381111, 19.079969);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][10], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][10], 1111244031);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][10], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][10], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][10], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][10], 4);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][10], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][10], 0);
	//TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][10], true);

	inventoryGlobalText[e_BUTTON][11] = TextDrawCreate(424.117736, 146.833358, "...");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][11], 0.278587, 1.360831);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][11], 2);
	TextDrawColor(inventoryGlobalText[e_BUTTON][11], -2119510017);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][11], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][11], 1);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][11], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][11], 14.000000, 14.000000);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][11], true);
	/*inventoryGlobalText[e_BUTTON][11] = TextDrawCreate(419.041351*-2.0*, 146.833358, "...");
	TextDrawLetterSize(inventoryGlobalText[e_BUTTON][11], 0.278588, 1.360832);
	TextDrawAlignment(inventoryGlobalText[e_BUTTON][11], 1);
	TextDrawColor(inventoryGlobalText[e_BUTTON][11], -2119510017);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawSetOutline(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawBackgroundColor(inventoryGlobalText[e_BUTTON][11], 255);
	TextDrawFont(inventoryGlobalText[e_BUTTON][11], 1);
	TextDrawSetProportional(inventoryGlobalText[e_BUTTON][11], 1);
	TextDrawSetShadow(inventoryGlobalText[e_BUTTON][11], 0);
	TextDrawTextSize(inventoryGlobalText[e_BUTTON][11], 430.000000, 20.000000);
	TextDrawSetSelectable(inventoryGlobalText[e_BUTTON][11], true);*/
}
INV_CreatePlayerTextDraws(playerid)
{
	/*
		ITEM NAME
					*/
	inventoryPlayerText[playerid][e_ITEM_INFO] = CreatePlayerTextDraw(playerid, 267.711853, /*179*/178.016693, "item: ~r~-");//item: ~r~varinha~w~(02)
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 0.238588, 1.162497);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 425.711853, 10.000000);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 1);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 255);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 2);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], 0);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_ITEM_INFO], false);
	/*
		PREVIEW SKIN
					*/
	inventoryPlayerText[playerid][e_PREVIEW_SKIN] = CreatePlayerTextDraw(playerid, 168.529602, 180.666687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 134.705810, 157.666641);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN], 0.000000, 0.000000, 0.000000, 1.000000);
	/*
		MAIN ITEMS
					*/
	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0] = CreatePlayerTextDraw(playerid, 270.176391, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][0], true);
	
	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1] = CreatePlayerTextDraw(playerid, 300.764465, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][1], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2] = CreatePlayerTextDraw(playerid, 331.352478, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][2], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3] = CreatePlayerTextDraw(playerid, 361.940490, 194.649963, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][3], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4] = CreatePlayerTextDraw(playerid, 392.769622, 194.549942, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][4], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5] = CreatePlayerTextDraw(playerid, 270.176391, 226.166595, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][5], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6] = CreatePlayerTextDraw(playerid, 300.764465, 226.166610, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][6], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7] = CreatePlayerTextDraw(playerid, 331.352478, 226.166656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][7], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8] = CreatePlayerTextDraw(playerid, 361.940490, 226.166687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][8], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9] = CreatePlayerTextDraw(playerid, 392.769622, 226.049911, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][9], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10] = CreatePlayerTextDraw(playerid, 270.176391, 257.666564, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][10], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11] = CreatePlayerTextDraw(playerid, 300.764465, 257.666595, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][11], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12] = CreatePlayerTextDraw(playerid, 331.352478, 257.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][12], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13] = CreatePlayerTextDraw(playerid, 362.111053, 257.650146, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][13], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14] = CreatePlayerTextDraw(playerid, 392.769622, 257.549957, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][14], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15] = CreatePlayerTextDraw(playerid, 270.176391, 289.166534, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][15], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16] = CreatePlayerTextDraw(playerid, 300.764465, 289.166564, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][16], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17] = CreatePlayerTextDraw(playerid, 331.352478, 289.166687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][17], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18] = CreatePlayerTextDraw(playerid, 362.111053, 289.150177, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][18], true);

	inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19] = CreatePlayerTextDraw(playerid, 392.769622, 289.049865, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], UNSELECTED_COLOR);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_MY_ITEM][19], true);
	/*
		PREIVEW ITEMS LOCK
		                    */
    inventoryPlayerText[playerid][e_PREVIEW_LOCK][0] = CreatePlayerTextDraw(playerid, 270.176391, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][0], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][1] = CreatePlayerTextDraw(playerid, 300.764465, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][1], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][2] = CreatePlayerTextDraw(playerid, 331.352478, 194.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][2], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][3] = CreatePlayerTextDraw(playerid, 361.940490, 194.649963, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][3], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][4] = CreatePlayerTextDraw(playerid, 392.769622, 194.549942, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][4], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][5] = CreatePlayerTextDraw(playerid, 270.176391, 226.166595, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][5], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][6] = CreatePlayerTextDraw(playerid, 300.764465, 226.166610, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][6], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][7] = CreatePlayerTextDraw(playerid, 331.352478, 226.166656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][7], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][8] = CreatePlayerTextDraw(playerid, 361.940490, 226.166687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][8], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][9] = CreatePlayerTextDraw(playerid, 392.769622, 226.049911, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][9], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][10] = CreatePlayerTextDraw(playerid, 270.176391, 257.666564, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][10], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][11] = CreatePlayerTextDraw(playerid, 300.764465, 257.666595, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][11], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][12] = CreatePlayerTextDraw(playerid, 331.352478, 257.666656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][12], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][13] = CreatePlayerTextDraw(playerid, 362.111053, 257.650146, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][13], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][14] = CreatePlayerTextDraw(playerid, 392.769622, 257.549957, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][14], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][15] = CreatePlayerTextDraw(playerid, 270.176391, 289.166534, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][15], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][16] = CreatePlayerTextDraw(playerid, 300.764465, 289.166564, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][16], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][17] = CreatePlayerTextDraw(playerid, 331.352478, 289.166687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][17], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][18] = CreatePlayerTextDraw(playerid, 362.111053, 289.150177, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][18], 0.000000, 0.000000, 0.000000, 1.377025);

	inventoryPlayerText[playerid][e_PREVIEW_LOCK][19] = CreatePlayerTextDraw(playerid, 392.769622, 289.049865, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 29.294075, 29.976650);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 255);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0);
	PlayerTextDrawSetOutline(playerid,inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 104);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 19804);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_LOCK][19], 0.000000, 0.000000, 0.000000, 1.377025);
	/*
		PREVIEW SKIN ITEMS
							*/
	inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0] = CreatePlayerTextDraw(playerid, 167.588241, 171.916687, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 35.411727, 36.916645);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 255);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][0], true);

	inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1] = CreatePlayerTextDraw(playerid, 167.588241, 210.416671, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 35.411727, 36.916645);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 255);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][1], true);

	inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2] = CreatePlayerTextDraw(playerid, 167.588241, 248.916671, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 35.411727, 36.916645);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 255);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][2], true);

	inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3] = CreatePlayerTextDraw(playerid, 167.588241, 287.416656, "");
	PlayerTextDrawLetterSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 35.411727, 36.916645);
	PlayerTextDrawAlignment(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 1);
	PlayerTextDrawColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], -1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 0);
	PlayerTextDrawSetOutline(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 0);
	PlayerTextDrawBackgroundColor(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 255);
	PlayerTextDrawFont(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 5);
	PlayerTextDrawSetProportional(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 1);
	PlayerTextDrawSetShadow(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 0);
	PlayerTextDrawSetPreviewModel(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 19461);
	PlayerTextDrawSetPreviewRot(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], 0.000000, 0.000000, 90.000000, 0.100000);
	PlayerTextDrawSetSelectable(playerid, inventoryPlayerText[playerid][e_PREVIEW_SKIN_ITEM][3], true);
}
/*------------------------------------------------------------------------------------------------------------------------*/
INVITE_CreateGlobalTextDraws()
{
	tradeInvitationGlobalText[e_BACKGROUND][0] = TextDrawCreate(455.887817, 149.816589, "box");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][0], 0.000000, 22.047061);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][0], 589.299377, 0.000000);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][0], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][0], -125);
	TextDrawUseBox(tradeInvitationGlobalText[e_BACKGROUND][0], 1);
	TextDrawBoxColor(tradeInvitationGlobalText[e_BACKGROUND][0], 102);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][0], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][0], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][0], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][0], 0);

	tradeInvitationGlobalText[e_BACKGROUND][1] = TextDrawCreate(453.816253, 147.050079, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][1], 137.087875, 17.103338);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][1], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][1], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][1], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][1], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][1], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][1], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][1], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][1], 0);

	tradeInvitationGlobalText[e_BUTTON_CLOSE] = TextDrawCreate(575.445922, 148.333480, "LD_CHAT:thumbdn");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_CLOSE], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_CLOSE], 14.235260, 15.333327);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_CLOSE], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_CLOSE], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_CLOSE], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_CLOSE], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_CLOSE], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_CLOSE], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_CLOSE], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_CLOSE], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_CLOSE], true);

	tradeInvitationGlobalText[e_BACKGROUND][2] = TextDrawCreate(523.952514, 148.000061, "NEGOCIAR");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][2], 0.400000, 1.600000);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][2], 2);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][2], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][2], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][2], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][2], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][2], 1);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][2], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][2], 0);

	tradeInvitationGlobalText[e_BACKGROUND][3] = TextDrawCreate(460.682403, 167.750076, "encontrar_negociante");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][3], 0.238588, 1.162497);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][3], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][3], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][3], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][3], 1);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][3], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][3], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][3], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][3], 0);

	tradeInvitationGlobalText[e_BACKGROUND][4] = TextDrawCreate(459.492675, 179.333358, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][4], 126.264305, 52.416740);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][4], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][4], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][4], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][4], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][4], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][4], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][4], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][4], 0);

	tradeInvitationGlobalText[e_BUTTON_LIST_NEXT] = TextDrawCreate(461.764831, 224.416610, ConvertToGameText("próximo >"));
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 461.764831+38.0, 6.0);//123.0
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 0.167059, 0.654995);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], -5963521);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_LIST_NEXT], true);

	tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS] = TextDrawCreate(543.646606, 224.416610, "< anterior");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 0.167059, 0.654995);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], -5963521);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_LIST_PREVIOUS], true);

	tradeInvitationGlobalText[e_BACKGROUND][5] = TextDrawCreate(459.492675, 239.416702, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][5], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][5], 57.087837, 0.943341);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][5], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][5], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][5], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][5], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][5], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][5], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][5], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][5], 0);

	tradeInvitationGlobalText[e_BACKGROUND][6] = TextDrawCreate(519.176391, 232.583389, "?");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][6], 0.393882, 1.494999);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][6], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][6], 255);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][6], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][6], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][6], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][6], 3);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][6], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][6], 0);

	tradeInvitationGlobalText[e_BACKGROUND][7] = TextDrawCreate(528.734313, 239.416702, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][7], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][7], 57.087837, 0.943341);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][7], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][7], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][7], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][7], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][7], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][7], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][7], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][7], 0);

	tradeInvitationGlobalText[e_BACKGROUND][8] = TextDrawCreate(460.682403, 248.833343, "Especificacoes");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][8], 0.238588, 1.162497);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][8], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][8], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][8], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][8], 1);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][8], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][8], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][8], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][8], 0);

	tradeInvitationGlobalText[e_BACKGROUND][9] = TextDrawCreate(459.492675, 260.316711, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][9], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][9], 126.264305, 34.916728);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][9], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][9], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][9], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][9], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][9], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][9], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][9], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][9], 0);

	tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0] = TextDrawCreate(461.235321, 262.916687, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 5.764688, 5.999996);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][0], true);

	tradeInvitationGlobalText[e_CHECKBOX][0] = TextDrawCreate(462.035369, 263.516845, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_CHECKBOX][0], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_CHECKBOX][0], 4.352931, 4.249995);
	TextDrawAlignment(tradeInvitationGlobalText[e_CHECKBOX][0], 1);
	TextDrawColor(tradeInvitationGlobalText[e_CHECKBOX][0], 824979967);
	TextDrawSetShadow(tradeInvitationGlobalText[e_CHECKBOX][0], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_CHECKBOX][0], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_CHECKBOX][0], 255);
	TextDrawFont(tradeInvitationGlobalText[e_CHECKBOX][0], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_CHECKBOX][0], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_CHECKBOX][0], 0);

	tradeInvitationGlobalText[e_BACKGROUND][10] = TextDrawCreate(467.882568, 262.333251, "transacao_de_moedas");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][10], 0.167059, 0.654995);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][10], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][10], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][10], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][10], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][10], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][10], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][10], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][10], 0);

	tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1] = TextDrawCreate(461.235321, 271.083343, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 5.764688, 5.999996);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_MARK_CHECKBOX][1], true);

	tradeInvitationGlobalText[e_CHECKBOX][1] = TextDrawCreate(462.035369, 271.683654, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_CHECKBOX][1], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_CHECKBOX][1], 4.352931, 4.249995);
	TextDrawAlignment(tradeInvitationGlobalText[e_CHECKBOX][1], 1);
	TextDrawColor(tradeInvitationGlobalText[e_CHECKBOX][1], 824979967);
	TextDrawSetShadow(tradeInvitationGlobalText[e_CHECKBOX][1], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_CHECKBOX][1], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_CHECKBOX][1], 255);
	TextDrawFont(tradeInvitationGlobalText[e_CHECKBOX][1], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_CHECKBOX][1], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_CHECKBOX][1], 0);

	tradeInvitationGlobalText[e_BACKGROUND][11] = TextDrawCreate(467.882537, 270.500091, "transacao_de_itens");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][11], 0.167059, 0.654995);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][11], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][11], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][11], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][11], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][11], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][11], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][11], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][11], 0);

	tradeInvitationGlobalText[e_BUTTON_COIN_VALUE] = TextDrawCreate(550.505798, 262.816680, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 23.102365, 6.056615);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_COIN_VALUE], true);

	tradeInvitationGlobalText[e_BACKGROUND][12] = TextDrawCreate(550.976562, 262.066680, "valor");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][12], 0.158588, 0.684161);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][12], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][12], 824979967);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][12], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][12], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][12], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][12], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][12], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][12], 0);

	tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER] = TextDrawCreate(541.705871, 270.700042, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 28.211879, 6.316658);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_ITEM_FILTER], true);

	tradeInvitationGlobalText[e_BACKGROUND][13] = TextDrawCreate(542.706115, 270.233276, "filtrar");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][13], 0.158588, 0.684161);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][13], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][13], 824979967);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][13], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][13], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][13], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][13], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][13], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][13], 0);

	tradeInvitationGlobalText[e_BACKGROUND][14] = TextDrawCreate(461.764923, 278.666809, "tipo:");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][14], 0.167059, 0.654995);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][14], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][14], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][14], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][14], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][14], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][14], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][14], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][14], 0);

	tradeInvitationGlobalText[e_BUTTON_VISUALIZE] = TextDrawCreate(459.353057, 297.916656, "LD_SPAC:white");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 126.235321, 11.833317);
	TextDrawAlignment(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], 0);
	TextDrawSetSelectable(tradeInvitationGlobalText[e_BUTTON_VISUALIZE], true);

	tradeInvitationGlobalText[e_BACKGROUND][15] = TextDrawCreate(522.641601, 297.133087, "visualizar");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][15], 0.229175, 1.273331);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][15], 2);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][15], 824979967);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][15], 340);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][15], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][15], 0);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][15], 2);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][15], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][15], 340);

	tradeInvitationGlobalText[e_BACKGROUND][16] = TextDrawCreate(459.492675, 315.250030, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeInvitationGlobalText[e_BACKGROUND][16], 0.000000, 0.000000);
	TextDrawTextSize(tradeInvitationGlobalText[e_BACKGROUND][16], 126.264366, 0.943341);
	TextDrawAlignment(tradeInvitationGlobalText[e_BACKGROUND][16], 1);
	TextDrawColor(tradeInvitationGlobalText[e_BACKGROUND][16], -1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][16], 0);
	TextDrawSetOutline(tradeInvitationGlobalText[e_BACKGROUND][16], 0);
	TextDrawBackgroundColor(tradeInvitationGlobalText[e_BACKGROUND][16], 255);
	TextDrawFont(tradeInvitationGlobalText[e_BACKGROUND][16], 4);
	TextDrawSetProportional(tradeInvitationGlobalText[e_BACKGROUND][16], 1);
	TextDrawSetShadow(tradeInvitationGlobalText[e_BACKGROUND][16], 0);
}
INVITE_CreatePlayerTextDraws(playerid)
{
	/*tradeInvitationPlayerText[playerid][e_LIST_PLAYERS] = CreatePlayerTextDraw(playerid, 461.764831, 180.083404, "Bruno_13");//~n~Adejair_junior~n~Misterix~n~ips_lion~n~ips_bruno~n~Felipe_Smith~n~Joao_Embriao
	PlayerTextDrawTextSize(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 461.764831+123.0, 4.5);//6.0
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 0.167059, 0.654995);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], -1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 2);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], 0);
	PlayerTextDrawSetSelectable(playerid, tradeInvitationPlayerText[playerid][e_LIST_PLAYERS], true);*/
	//-------------------------------------------------------------------------
	tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0] = CreatePlayerTextDraw(playerid, 461.705993, 285.666473, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 36.352947, 7.166662);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], -1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 4);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], 0);
	PlayerTextDrawSetSelectable(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][0], true);

	tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1] = CreatePlayerTextDraw(playerid, 501.705780, 285.666473, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 47.176486, 7.166656);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], -1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 4);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], 0);
	PlayerTextDrawSetSelectable(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE][1], true);

	tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0] = CreatePlayerTextDraw(playerid, 462.706146, 285.083282, "pessoal");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 0.272646, 0.794992);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 824979967);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 3);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][0], 0);

	tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1] = CreatePlayerTextDraw(playerid, 502.705932, 285.083282, "comercial");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 0.272646, 0.794992);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 824979967);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 3);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_TRADE_TYPE_TEXT][1], 0);
	//-------------------------------------------------------------------------
	tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION] = CreatePlayerTextDraw(playerid, 461.235504, 320.899963, "LD_SPAC:white");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 122.470626, 15.333310);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 1);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 8388863);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 4);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], 0);
	PlayerTextDrawSetSelectable(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION], true);

	tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT] = CreatePlayerTextDraw(playerid, 522.770324, 322.649810, "ENVIAR_CONVITE");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 0.229175, 1.273331);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 2);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], -1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 340);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 0);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 2);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_BUTTON_SEND_INVITATION_TEXT], 340);
	//-------------------------------------------------------------------------
	tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE] = CreatePlayerTextDraw(playerid, 521.953063, 337.616973, "Aguardando resposta do~n~negociante.");
	PlayerTextDrawLetterSize(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 0.167059, 0.649164);
	PlayerTextDrawAlignment(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 2);
	PlayerTextDrawColor(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], -1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 0);
	PlayerTextDrawSetOutline(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 0);
	PlayerTextDrawBackgroundColor(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 255);
	PlayerTextDrawFont(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 2);
	PlayerTextDrawSetProportional(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 1);
	PlayerTextDrawSetShadow(playerid, tradeInvitationPlayerText[playerid][e_TRADE_INFORMATION_STATE], 0);
}
/*------------------------------------------------------------------------------------------------------------------------*/
TRADE_CreateGlobalTextDraws()
{
	/*
		BACKGROUND
					*/
	tradeGlobalText[e_BACKGROUND][0] = TextDrawCreate(455.887817, 149.816589, "box");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][0], 0.000000, 22.047061);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][0], 589.299377, 0.000000);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][0], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][0], -1);
	TextDrawUseBox(tradeGlobalText[e_BACKGROUND][0], 1);
	TextDrawBoxColor(tradeGlobalText[e_BACKGROUND][0], 102);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][0], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][0], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][0], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][0], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][0], 0);

	tradeGlobalText[e_BACKGROUND][1] = TextDrawCreate(453.816253, 147.050079, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][1], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][1], 137.087875, 17.103338);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][1], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][1], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][1], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][1], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][1], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][1], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][1], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][1], 0);

	tradeGlobalText[e_BACKGROUND][2] = TextDrawCreate(523.952514, 148.000061, "NEGOCIAR");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][2], 0.400000, 1.600000);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][2], 2);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][2], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][2], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][2], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][2], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][2], 1);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][2], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][2], 0);

	tradeGlobalText[e_BACKGROUND][3] = TextDrawCreate(460.682403, 167.750076/*460.682403, 168.333404*/, "sua_oferta");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][3], 0.238588, 1.162497);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][3], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][3], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][3], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][3], 1);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][3], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][3], 2);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][3], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][3], 0);

	tradeGlobalText[e_BACKGROUND][4] = TextDrawCreate(459.492675, 179.333358, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][4], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][4], 126.264305, 36.083393);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][4], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][4], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][4], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][4], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][4], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][4], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][4], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][4], 0);

	tradeGlobalText[e_BACKGROUND][5] = TextDrawCreate(459.492675, 217.833358, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][5], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][5], 126.264305, 13.776677);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][5], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][5], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][5], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][5], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][5], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][5], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][5], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][5], 0);

	tradeGlobalText[e_BACKGROUND][6] = TextDrawCreate(470.705902, 218.000045, "Marque_esta_caixa_quando~n~estiver_pronto_para_negociar.");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][6], 0.167059, 0.654997/*0.167059, 0.649164*/);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][6], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][6], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][6], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][6], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][6], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][6], 2);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][6], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][6], 0);

	tradeGlobalText[e_BACKGROUND][7] = TextDrawCreate(459.492675, 239.416702, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][7], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][7], 57.087837, 0.943341);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][7], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][7], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][7], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][7], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][7], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][7], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][7], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][7], 0);

	tradeGlobalText[e_BACKGROUND][8] = TextDrawCreate(517.705810, 234.250015, "hud:radar_gangN");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][8], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][8], 9.529400, 11.249982);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][8], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][8], 255);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][8], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][8], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][8], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][8], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][8], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][8], 0);

	tradeGlobalText[e_BACKGROUND][9] = TextDrawCreate(528.734313, 239.416702, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][9], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][9], 57.087837, 0.943341);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][9], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][9], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][9], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][9], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][9], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][9], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][9], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][9], 0);

	tradeGlobalText[e_BACKGROUND][10] = TextDrawCreate(459.492675, 260.316711, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][10], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][10], 126.264305, 36.083393);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][10], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][10], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][10], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][10], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][10], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][10], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][10], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][10], 0);

	tradeGlobalText[e_BACKGROUND][11] = TextDrawCreate(459.492675, 299.033447, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][11], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][11], 126.264305, 9.693346);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][11], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][11], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][11], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][11], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][11], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][11], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][11], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][11], 0);

	tradeGlobalText[e_BACKGROUND][12] = TextDrawCreate(459.492675, 315.249938, "LD_PLAN:tvbase");
	TextDrawLetterSize(tradeGlobalText[e_BACKGROUND][12], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BACKGROUND][12], 126.264358, 0.943341);
	TextDrawAlignment(tradeGlobalText[e_BACKGROUND][12], 1);
	TextDrawColor(tradeGlobalText[e_BACKGROUND][12], -1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][12], 0);
	TextDrawSetOutline(tradeGlobalText[e_BACKGROUND][12], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BACKGROUND][12], 255);
	TextDrawFont(tradeGlobalText[e_BACKGROUND][12], 4);
	TextDrawSetProportional(tradeGlobalText[e_BACKGROUND][12], 1);
	TextDrawSetShadow(tradeGlobalText[e_BACKGROUND][12], 0);
	/*
		BUTTONS
				*/
	tradeGlobalText[e_BUTTON][0] = TextDrawCreate(575.445922, 148.333480, "LD_CHAT:thumbdn");
	TextDrawLetterSize(tradeGlobalText[e_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BUTTON][0], 14.235260, 15.333327);
	TextDrawAlignment(tradeGlobalText[e_BUTTON][0], 1);
	TextDrawColor(tradeGlobalText[e_BUTTON][0], -1);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][0], 0);
	TextDrawSetOutline(tradeGlobalText[e_BUTTON][0], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BUTTON][0], 255);
	TextDrawFont(tradeGlobalText[e_BUTTON][0], 4);
	TextDrawSetProportional(tradeGlobalText[e_BUTTON][0], 1);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][0], 0);
	TextDrawSetSelectable(tradeGlobalText[e_BUTTON][0], true);

	tradeGlobalText[e_BUTTON][1] = TextDrawCreate(461.235321, 219.750030, "LD_SPAC:white");
	TextDrawLetterSize(tradeGlobalText[e_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BUTTON][1], 8.117630, 10.083329);
	TextDrawAlignment(tradeGlobalText[e_BUTTON][1], 1);
	TextDrawColor(tradeGlobalText[e_BUTTON][1], -1);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][1], 0);
	TextDrawSetOutline(tradeGlobalText[e_BUTTON][1], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BUTTON][1], 255);
	TextDrawFont(tradeGlobalText[e_BUTTON][1], 4);
	TextDrawSetProportional(tradeGlobalText[e_BUTTON][1], 1);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][1], 0);
	TextDrawSetSelectable(tradeGlobalText[e_BUTTON][1], true);

	tradeGlobalText[e_BUTTON][2] = TextDrawCreate(462.035369, 220.350067, "LD_SPAC:white");
	TextDrawLetterSize(tradeGlobalText[e_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(tradeGlobalText[e_BUTTON][2], 6.705873, 8.333330);
	TextDrawAlignment(tradeGlobalText[e_BUTTON][2], 1);
	TextDrawColor(tradeGlobalText[e_BUTTON][2], 824979967);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][2], 0);
	TextDrawSetOutline(tradeGlobalText[e_BUTTON][2], 0);
	TextDrawBackgroundColor(tradeGlobalText[e_BUTTON][2], 255);
	TextDrawFont(tradeGlobalText[e_BUTTON][2], 4);
	TextDrawSetProportional(tradeGlobalText[e_BUTTON][2], 1);
	TextDrawSetShadow(tradeGlobalText[e_BUTTON][2], 0);
}
TRADE_CreatePlayerTextDraws(playerid)
{
	/*
		NEGOTIATOR NAME
						*/
	tradePlayerText[playerid][e_DEALER_NAME] = CreatePlayerTextDraw(playerid, 460.682403, 248.833343/*460.682403, 249.416671*/, "oferta de ~r~Adejair");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_DEALER_NAME], 0.238588, 1.162497);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_DEALER_NAME], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_DEALER_NAME], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_DEALER_NAME], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_DEALER_NAME], 1);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_DEALER_NAME], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_DEALER_NAME], 2);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_DEALER_NAME], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_DEALER_NAME], 0);
	/*
		SITUATION NEGOTIATION
								*/
	tradePlayerText[playerid][e_DEALER_STATE] = CreatePlayerTextDraw(playerid, 522.752868, 300.283477, "NAO_ESTA_PRONTO_PARA_NEGOCIAR.");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_DEALER_STATE], 0.167059, 0.649164);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_DEALER_STATE], 2);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_DEALER_STATE], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_DEALER_STATE], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_DEALER_STATE], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_DEALER_STATE], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_DEALER_STATE], 2);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_DEALER_STATE], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_DEALER_STATE], 0);

	tradePlayerText[playerid][e_TRADE_STATE] = CreatePlayerTextDraw(playerid, 521.953063, 337.616973, "ambos_negociantes_estao~n~prontos.");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_TRADE_STATE], 0.167059, 0.649164);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_TRADE_STATE], 2);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_TRADE_STATE], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_TRADE_STATE], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_TRADE_STATE], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_TRADE_STATE], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_TRADE_STATE], 2);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_TRADE_STATE], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_TRADE_STATE], 0);
	/*
		BUTTON MAKE BUSINESS
							*/
	tradePlayerText[playerid][e_BUTTON_MAKE][0] = CreatePlayerTextDraw(playerid, 461.235504, 320.900024, "LD_SPAC:white");//BUTTON 'FAZER NEGOCIO'
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 121.058860, 15.333310);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 8388863);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 4);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][0], true);

	tradePlayerText[playerid][e_BUTTON_MAKE][1] = CreatePlayerTextDraw(playerid, 486.064575, 322.649810, "FAZER_NEGOCIO");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 0.229175, 1.273331);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 340);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 0);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 2);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_BUTTON_MAKE][1], 340);
	/*
		MY OFFER
				*/
	tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0] = CreatePlayerTextDraw(playerid, 461.705535, 182.416564, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][0], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1] = CreatePlayerTextDraw(playerid, 492.293640, 182.416564, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][1], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2] = CreatePlayerTextDraw(playerid, 522.881530, 182.416564, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][2], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3] = CreatePlayerTextDraw(playerid, 553.469299, 182.416564, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_MY_OFFER][3], 0.000000, 0.000000, 90.000000, 0.100000);
	/*
		NEGOTIATOR OFFER
						*/
	tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0] = CreatePlayerTextDraw(playerid, 461.705535, 263.499938, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][0], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1] = CreatePlayerTextDraw(playerid, 492.293640, 263.500000, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][1], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2] = CreatePlayerTextDraw(playerid, 522.881530, 263.499847, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][2], 0.000000, 0.000000, 90.000000, 0.100000);

	tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3] = CreatePlayerTextDraw(playerid, 553.469299, 263.499877, "");
	PlayerTextDrawLetterSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 29.294075, 29.916648);
	PlayerTextDrawAlignment(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 1);
	PlayerTextDrawColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], -1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 0);
	PlayerTextDrawSetOutline(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 0);
	PlayerTextDrawBackgroundColor(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 255);
	PlayerTextDrawFont(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 5);
	PlayerTextDrawSetProportional(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 1);
	PlayerTextDrawSetShadow(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 0);
	PlayerTextDrawSetSelectable(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], true);
	PlayerTextDrawSetPreviewModel(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 19461);
	PlayerTextDrawSetPreviewRot(playerid, tradePlayerText[playerid][e_PREVIEW_DEALER_OFFER][3], 0.000000, 0.000000, 90.000000, 0.100000);
}
/*------------------------------------------------------------------------------------------------------------------------*/
INTERAC_CreateGlobalTextDraws()
{
	interactionGlobalText[e_TEXT][0] = TextDrawCreate(348.352752, 230.833496, "O_que_fazer_com_este_item?");
	TextDrawLetterSize(interactionGlobalText[e_TEXT][0], 0.190586, 1.185829);
	TextDrawAlignment(interactionGlobalText[e_TEXT][0], 1);
	TextDrawColor(interactionGlobalText[e_TEXT][0], -1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][0], 0);
	TextDrawSetOutline(interactionGlobalText[e_TEXT][0], 1);
	TextDrawBackgroundColor(interactionGlobalText[e_TEXT][0], 255);
	TextDrawFont(interactionGlobalText[e_TEXT][0], 2);
	TextDrawSetProportional(interactionGlobalText[e_TEXT][0], 1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][0], 0);

	interactionGlobalText[e_BUTTON][0] = TextDrawCreate(347.352752, 243.666961, "LD_SPAC:white");
	TextDrawLetterSize(interactionGlobalText[e_BUTTON][0], 0.000000, 0.000000);
	TextDrawTextSize(interactionGlobalText[e_BUTTON][0], 120.588249, 12.416647);
	TextDrawAlignment(interactionGlobalText[e_BUTTON][0], 1);
	TextDrawColor(interactionGlobalText[e_BUTTON][0], -1523963137);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][0], 0);
	TextDrawSetOutline(interactionGlobalText[e_BUTTON][0], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_BUTTON][0], 255);
	TextDrawFont(interactionGlobalText[e_BUTTON][0], 4);
	TextDrawSetProportional(interactionGlobalText[e_BUTTON][0], 1);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][0], 0);
	TextDrawSetSelectable(interactionGlobalText[e_BUTTON][0], true);

	interactionGlobalText[e_TEXT][1] = TextDrawCreate(407.646850, 243.083297, "usar");
	TextDrawLetterSize(interactionGlobalText[e_TEXT][1], 0.219291, 1.372498);
	TextDrawAlignment(interactionGlobalText[e_TEXT][1], 2);
	TextDrawColor(interactionGlobalText[e_TEXT][1], -1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][1], 0);
	TextDrawSetOutline(interactionGlobalText[e_TEXT][1], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_TEXT][1], 255);
	TextDrawFont(interactionGlobalText[e_TEXT][1], 2);
	TextDrawSetProportional(interactionGlobalText[e_TEXT][1], 1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][1], 0);

	interactionGlobalText[e_BUTTON][1] = TextDrawCreate(347.352752, 257.066772, "LD_SPAC:white");
	TextDrawLetterSize(interactionGlobalText[e_BUTTON][1], 0.000000, 0.000000);
	TextDrawTextSize(interactionGlobalText[e_BUTTON][1], 120.588249, 12.416647);
	TextDrawAlignment(interactionGlobalText[e_BUTTON][1], 1);
	TextDrawColor(interactionGlobalText[e_BUTTON][1], -1523963137);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][1], 0);
	TextDrawSetOutline(interactionGlobalText[e_BUTTON][1], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_BUTTON][1], 255);
	TextDrawFont(interactionGlobalText[e_BUTTON][1], 4);
	TextDrawSetProportional(interactionGlobalText[e_BUTTON][1], 1);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][1], 0);
	TextDrawSetSelectable(interactionGlobalText[e_BUTTON][1], true);

	interactionGlobalText[e_TEXT][2] = TextDrawCreate(407.646850, 256.500000, "dropar");
	TextDrawLetterSize(interactionGlobalText[e_TEXT][2], 0.219291, 1.372498);
	TextDrawAlignment(interactionGlobalText[e_TEXT][2], 2);
	TextDrawColor(interactionGlobalText[e_TEXT][2], -1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][2], 0);
	TextDrawSetOutline(interactionGlobalText[e_TEXT][2], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_TEXT][2], 255);
	TextDrawFont(interactionGlobalText[e_TEXT][2], 2);
	TextDrawSetProportional(interactionGlobalText[e_TEXT][2], 1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][2], 0);

	interactionGlobalText[e_BUTTON][2] = TextDrawCreate(347.352752, 270.483551, "LD_SPAC:white");
	TextDrawLetterSize(interactionGlobalText[e_BUTTON][2], 0.000000, 0.000000);
	TextDrawTextSize(interactionGlobalText[e_BUTTON][2], 120.588249, 12.416647);
	TextDrawAlignment(interactionGlobalText[e_BUTTON][2], 1);
	TextDrawColor(interactionGlobalText[e_BUTTON][2], -1523963137);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][2], 0);
	TextDrawSetOutline(interactionGlobalText[e_BUTTON][2], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_BUTTON][2], 255);
	TextDrawFont(interactionGlobalText[e_BUTTON][2], 4);
	TextDrawSetProportional(interactionGlobalText[e_BUTTON][2], 1);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][2], 0);
	TextDrawSetSelectable(interactionGlobalText[e_BUTTON][2], true);

	interactionGlobalText[e_TEXT][3] = TextDrawCreate(407.646850, 269.916809, "guardar");
	TextDrawLetterSize(interactionGlobalText[e_TEXT][3], 0.219291, 1.372498);
	TextDrawAlignment(interactionGlobalText[e_TEXT][3], 2);
	TextDrawColor(interactionGlobalText[e_TEXT][3], -1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][3], 0);
	TextDrawSetOutline(interactionGlobalText[e_TEXT][3], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_TEXT][3], 255);
	TextDrawFont(interactionGlobalText[e_TEXT][3], 2);
	TextDrawSetProportional(interactionGlobalText[e_TEXT][3], 1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][3], 0);

	interactionGlobalText[e_BUTTON][3] = TextDrawCreate(347.352752, 283.900360, "LD_SPAC:white");
	TextDrawLetterSize(interactionGlobalText[e_BUTTON][3], 0.000000, 0.000000);
	TextDrawTextSize(interactionGlobalText[e_BUTTON][3], 120.588249, 12.416647);
	TextDrawAlignment(interactionGlobalText[e_BUTTON][3], 1);
	TextDrawColor(interactionGlobalText[e_BUTTON][3], -1523963137);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][3], 0);
	TextDrawSetOutline(interactionGlobalText[e_BUTTON][3], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_BUTTON][3], 255);
	TextDrawFont(interactionGlobalText[e_BUTTON][3], 4);
	TextDrawSetProportional(interactionGlobalText[e_BUTTON][3], 1);
	TextDrawSetShadow(interactionGlobalText[e_BUTTON][3], 0);
	TextDrawSetSelectable(interactionGlobalText[e_BUTTON][3], true);

	interactionGlobalText[e_TEXT][4] = TextDrawCreate(407.646850, 283.333679, "transferir");
	TextDrawLetterSize(interactionGlobalText[e_TEXT][4], 0.219291, 1.372498);
	TextDrawAlignment(interactionGlobalText[e_TEXT][4], 2);
	TextDrawColor(interactionGlobalText[e_TEXT][4], -1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][4], 0);
	TextDrawSetOutline(interactionGlobalText[e_TEXT][4], 0);
	TextDrawBackgroundColor(interactionGlobalText[e_TEXT][4], 255);
	TextDrawFont(interactionGlobalText[e_TEXT][4], 2);
	TextDrawSetProportional(interactionGlobalText[e_TEXT][4], 1);
	TextDrawSetShadow(interactionGlobalText[e_TEXT][4], 0);
}
INTERAC_CreatePlayerTextDraws(playerid)
{
	interactionPlayerText[playerid][e_PREVIEW_ITEM] = CreatePlayerTextDraw(playerid, 324.764526, 223.250091, "");
	PlayerTextDrawLetterSize(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 24.588232, 25.833332);
	PlayerTextDrawAlignment(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 1);
	PlayerTextDrawColor(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], -1);
	PlayerTextDrawSetShadow(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0);
	PlayerTextDrawSetOutline(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0);
	PlayerTextDrawBackgroundColor(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0);
	PlayerTextDrawFont(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 5);
	PlayerTextDrawSetProportional(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 1);
	PlayerTextDrawSetShadow(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0);
	PlayerTextDrawSetPreviewModel(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 371);
	PlayerTextDrawSetPreviewRot(playerid, interactionPlayerText[playerid][e_PREVIEW_ITEM], 0.000000, 0.000000, 0.000000, 0.800000);
}

/*
SetPlayerAttachedObject(playerid,0,3026,1,-0.168999,-0.094999,-0.008999,0.000000,0.000000,0.000000,1.000000,1.000000,1.000000) // Simple
SetPlayerAttachedObject(playerid,0,19559,1,0.101000,-0.034000,0.000000,0.000000,88.099990,0.000000,1.000000,1.000000,1.000000) // FULL

FOOT:
SetPlayerAttachedObject(playerid,0,3026,9,0.132999,0.327999,0.388999,14.100000,0.600000,-168.900070,1.000000,1.000000,1.000000) // Simple
SetPlayerAttachedObject(playerid,0,19559,9,-0.153999,0.398000,0.348999,-2.399999,-90.199974,-8.399995,1.000000,1.000000,1.000000) // FULL
*/
