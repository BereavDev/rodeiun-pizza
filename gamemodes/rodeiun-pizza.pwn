// pizzada çalışmak - rodeiun

#pragma compat 1
#pragma dynamic 500000

#pragma warning disable 239
#pragma warning disable 214
#pragma warning disable 217

#include <a_samp>
#include <fix>
#include <a_mysql>
#include <streamer>
#include <sqlitei>
#include <YSF>
#include <sscanf2>
#include <streamer>
#include <YSI\y_iterate>
#include <YSI\y_bit>
#include <foreach>
#include <easyDialog>
#include <string>
#include <mSelection>
#include <zcmd>
#include <cuffs>
#include <garage_block>
#pragma tabsize 0

main()
{
	print("\n---------------------------------------");
	print("Running Grand Larceny - by the SA-MP team\n");
	print("---------------------------------------\n");
}
new stock g_arrVehicleNames[][] = {
    "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel", "Dumper", "Firetruck", "Trashmaster",
    "Stretch", "Manana", "Infernus", "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
    "Esperanto", "Taxi", "Washington", "Bobcat", "Whoopee", "BF Injection", "Hunter", "Premier", "Enforcer",
    "Securicar", "Banshee", "Predator", "Bus", "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach",
    "Cabbie", "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral", "Squalo", "Seasparrow",
    "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder", "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair",
    "Berkley's RC Van", "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale", "Oceanic",
    "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy", "Hermes", "Sabre", "Rustler", "ZR-350", "Walton",
    "Regina", "Comet", "BMX", "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper", "Rancher",
    "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking", "Blista Compact", "Police Maverick",
    "Boxville", "Benson", "Mesa", "RC Goblin", "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher",
    "Super GT", "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropduster", "Stunt", "Tanker", "Roadtrain",
    "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra", "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck",
    "Fortune", "Cadrona", "SWAT Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer", "Remington", "Slamvan",
    "Blade", "Streak", "Freight", "Vortex", "Vincent", "Bullet", "Clover", "Sadler", "Firetruck", "Hustler", "Intruder",
    "Primo", "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite", "Windsor", "Monster", "Monster",
    "Uranus", "Jester", "Sultan", "Stratum", "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
    "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper", "Broadway", "Tornado", "AT-400", "DFT-30",
    "Huntley", "Stafford", "BF-400", "News Van", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
    "Freight Box", "Trailer", "Andromada", "Dodo", "RC Cam", "Launch", "LSPD Car", "SFPD Car", "LVPD Car",
    "Police Rancher", "Picador", "S.W.A.T", "Alpha", "Phoenix", "Glendale", "Sadler", "Luggage", "Luggage", "Stairs",
    "Boxville", "Tiller", "Utility Trailer"
};

#undef MAX_PLAYERS
#define MAX_PLAYERS 100
enum pData
{
	pID,
	pSkor,
	pCash,
	pAdmin,
	pMeslek,
	pMaas,
	InsideHome
}
#define MAX_SIPARIS		150
new PlayerData[MAX_PLAYERS][pData];
new YukTimer[MAX_PLAYERS], PizzaTimer[MAX_PLAYERS];
new bool:Yukluyo[MAX_PLAYERS];
new TedarikYuk[MAX_VEHICLES];
new aSiparis[MAX_VEHICLES][MAX_SIPARIS];
enum MeslekData
{
	meslekAd[50],
	meslekSayi,
	meslekMax
}
new ToplamMalzeme;
new ToplamAraba;
enum SiparisData
{
	bool:sExists,
	sAdres[50],
	bool:sHazir,
	bool:sPaket,
	sKurye,
	PizzaSayi,
	bool:sOnay
}
new Siparisler[MAX_SIPARIS][SiparisData];
// sipariş havuzu vardır bu havuz dakikada 2 tane eklenir sipariş onaylandıktan sonra hazırlanır ve teslim edilir

#define MAX_EV		500
enum evleraga
{
	bool:evExists,
	evID,
	evAdres[60],
	evSahip,
	Float:evPos[3],
	Text3D:evText,
	evPickup,
	//bool:evKilit
}
new EvData[MAX_EV][evleraga];
#define MESLEK_SAYI 7
new Meslekler[MESLEK_SAYI][MeslekData];
new Flatbedler[4];
new Faggiolar[7];
new Maas;
new PizzaDG;
new bool:SiparisAlimi;
/*
enum intKoku
{
	Float:evX,
	Float:evY,
	Float:evZ,
	evBoyut
}
new Interiorlar[][intKoku] = 
{
	{223.20, 1287.08, 1082.14, 0},
	{2283.04, -1140.28, 1050.90, 0},
	{2233.64, -1115.26, 1050.88, 0},
	{266.50, 304.90, 999.15, 0},
	{2259.38, -1135.77, 1050.64, 0},
	{2324.53, -1149.54, 1050.71, 1},
	{140.17, 1366.07, 1083.65, 2},
	{226.30, 1114.24, 1080.99, 2},
	{2495.98, -1692.08, 1014.74, 2}
};*/
#define MesajGonder(%0,%1) \
	SendClientMessageEx(%0, 0x00DD00AA, "[!]{F5F5F5} "%1)

#define BilgiMesajGonder(%0,%1) \
	SendClientMessageEx(%0, 0x00DD00AA, "[!]{F5F5F5} "%1)

#define HataMesajGonder(%0,%1) \
	SendClientMessageEx(%0, 0xCC0000AA, "[!] "%1)

#define PIZZA_MALZEME		5
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_DEPARTMENT  (0xF0CC00FF)
#define COLOR_GREEN 0x33AA33AA
#define COLOR_LIGHTGREEN  (0x9ACD32FF)
#define COLOR_RED 0xAA3333AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_WHITE 0xFFFFFFAA
#define COLOR_BLUE 0x0000BBAA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_ORANGE 0xFF9900AA
#define COLOR_RED 0xAA3333AA
#define COLOR_LIME 0x10F441AA
#define COLOR_MAGENTA 0xFF00FFFF
#define COLOR_NAVY 0x000080AA
#define COLOR_AQUA 0xF0F8FFAA
#define COLOR_CRIMSON 0xDC143CAA
#define COLOR_RADIO       (0x8D8DFFFF)
#define COLOR_PURPLE      (0xD0AEEBFF)
#define COLOR_FLBLUE 0x6495EDAA
#define COLOR_BISQUE 0xFFE4C4AA
#define COLOR_BLACK 0x000000AA
#define COLOR_CHARTREUSE 0x7FFF00AA
#define COLOR_BROWN 0XA52A2AAA
#define COLOR_CORAL 0xFF7F50AA
#define COLOR_GOLD 0xB8860BAA
#define COLOR_GREENYELLOW 0xADFF2FAA
#define COLOR_INDIGO 0x4B00B0AA
#define COLOR_IVORY 0xFFFF82AA
#define COLOR_LAWNGREEN 0x7CFC00AA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_MIDNIGHTBLUE 0X191970AA
#define COLOR_MAROON 0x800000AA
#define COLOR_OLIVE 0x808000AA
#define COLOR_ORANGERED   (0xFF4500AA)
#define COLOR_PINK        (0xFFC0CBAA)
#define COLOR_SEAGREEN 	  (0x2E8B57AA)
#define COLOR_SPRINGGREEN (0x00FF7FAA)
#define COLOR_LIGHTRED    (0xFF6347AA)
#define COLOR_ADMINCHATT  (0x33EE33FF)
#define COLOR_CLIENT      (0xAAC4E5FF)
#define COLOR_CYAN        (0xC2A2DAAA)
#define COLOR_ADMINCHAT   (0xAA3333AA)
#define COLOR_DEPARTMENT  (0xF0CC00FF)
#define COLOR_DARKBLUE    (0x1394BFFF)
	
/* ============================ [MySQL Bilgileri] =========================== */

#define MYSQL_HOST 													 "localhost"
#define MYSQL_USER 														  "root"
#define MYSQL_PASS 											  		  "Can3465!"
#define MYSQL_BASE 												  		 "pizza"

new MySQL:pizza;

/*============================================================================*/
/*new VehicleNames[212][] = {
{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
{"Utility Trailer"}};
*/
AntiDeAMX()
{
    new Rodeiunn[][] =
    {
        "Unarmed (Fist)",
        "Brass K"
    };
    #pragma unused Rodeiunn
}
WasteDeAMXersTime()
{
    new
		Rodeiun;
    #emit load.pri Rodeiun
    #emit stor.pri Rodeiun
}
stock Spawnla(playerid)
{
	SetPVarInt(playerid, "Logged", 1);
	TogglePlayerSpectating(playerid, 0);
    SetPlayerInterior(playerid,0);
    SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559);
    SetPlayerFacingAngle(playerid, 350.8630);
    SetPlayerVirtualWorld(playerid,0);
    SetPlayerSkin(playerid, 23);
    SetCameraBehindPlayer(playerid);
    SpawnPlayer(playerid);
    return 1;
}
//----------------------------------------------------------

public OnPlayerFinishedDownloading(playerid, virtualworld)
{
    //SendClientMessage(playerid,COLOR_WHITE,"Downloads finished.");
	return 1;
}

//----------------------------------------------------------
public OnPlayerDisconnect(playerid, reason)
{
	Meslekler[PlayerData[playerid][pMeslek]][meslekSayi]--;
	new query[340];
	mysql_format(pizza, query, 340, "UPDATE `oyuncular` SET `Skor` = '%d', `Para` = '%d', `Admin` = '%d', `pMaas` = '%d' WHERE `ID` = '%d'",
	    PlayerData[playerid][pSkor],
	    PlayerData[playerid][pCash],
	    PlayerData[playerid][pAdmin],
		PlayerData[playerid][pMaas],
	    PlayerData[playerid][pID]);
	mysql_query(pizza, query, false);
}
stock GetIP(playerid)
{
	new pip[16];
	GetPlayerIp(playerid, pip, sizeof(pip));
	return pip;
}
stock ReturnDate()
{
	static
	    date[36];

	getdate(date[2], date[1], date[0]);
	gettime(date[3], date[4], date[5]);

	format(date, sizeof(date), "%02d/%02d/%d, %02d:%02d", date[0], date[1], date[2], date[3], date[4]);
	return date;
}
stock IsNumeric(const str[])
{
	for (new i = 0, l = strlen(str); i != l; i ++)
	{
	    if (i == 0 && str[0] == '-')
			continue;

	    else if (str[i] < '0' || str[i] > '9')
			return 0;
	}
	return 1;
}
public OnPlayerConnect(playerid)
{
	GameTextForPlayer(playerid,"~w~Pizza ~r~Hayati",3000,4);
	SetPVarInt(playerid, "Logged", 0);
	PlayerData[playerid][InsideHome] = -1;
	PlayerData[playerid][pMeslek] = -1;
	Yukluyo[playerid] = false;
	KillTimer(YukTimer[playerid]);
	KillTimer(PizzaTimer[playerid]);
	new dr[300], Cache:c1c;
	mysql_format(pizza, dr, 300, "SELECT * FROM `bans` WHERE `banYiyen` = '%s' OR `banIP` = '%s'", ReturnName(playerid), GetIP(playerid));
	c1c = mysql_query(pizza, dr);
	if(cache_num_rows())
	{
	    new ykisi[25], bansure, sebep[51];
	    cache_get_value_name(0, "banAtan", ykisi, 25);
	    cache_get_value_name(0, "banSebep", sebep, 51);
	    cache_get_value_name_int(0, "banSure", bansure);
		if(bansure == 0)
		{
			Dialog_Show(playerid, Yasakli, DIALOG_STYLE_MSGBOX, "Yasaklandınız!", "{ffffff}Bu sunucudan yasaklandınız.\n{ffffff}Yasaklayan Yetkili: {cccccc}%s\n{ffffff}Yasaklanma Sebebi: {cccccc}%s\n{ffffff}Kalan Süre: {cccccc}Sınırsız\n{ffffff}Eğer bu yasaklanmanın hatalı olduğunu düşünüyorsanız 'www.discord.gg/discord' adresimizden bize ulaşabilirsiniz.", "Tamam", "", ykisi, sebep);
			return SetTimerEx("OyundanAt", 500, false, "d", playerid);
		}
 		if(bansure != 0 && bansure > gettime())
    	{
	  		new secs = bansure - gettime(), klngun, klnsaat, klndk;
			klngun = floatround(secs / 86400);
			secs = secs - klngun*86400;
			klnsaat = floatround(secs / 3600);
		    secs = secs - klnsaat*3600;
   			klndk = floatround(secs / 60);
		    secs = secs - klndk*60;
			Dialog_Show(playerid, Yasakli, DIALOG_STYLE_MSGBOX, "Yasaklandınız!", "{ffffff}Bu sunucudan yasaklandınız.\n{ffffff}Yasaklayan Yetkili: {cccccc}%s\n{ffffff}Yasaklanma Sebebi: {cccccc}%s\n{ffffff}Kalan Süre: {cccccc}%d gün %d saat %d dakika\n{ffffff}Eğer bu yasaklanmanın hatalı olduğunu düşünüyorsanız 'www.discord.gg/discord' adresimizden bize ulaşabilirsiniz.", "Tamam", "", ykisi, sebep, klngun, klnsaat, klndk);
			return SetTimerEx("OyundanAt", 1500, false, "d", playerid);
		}
	}
	cache_delete(c1c);
	mysql_format(pizza, dr, 300, "SELECT * FROM `oyuncular` WHERE `Isim` = '%s'", ReturnName(playerid));
	c1c = mysql_query(pizza, dr);
	if(!cache_num_rows()) return Dialog_Show(playerid, Kayit, DIALOG_STYLE_INPUT, "Pizza Hayatı - Kayıt Ol", "{ffffff}Sunucumuza hoşgeldin, {cccccc}%s. {ffffff}\nVeritabanında kayıtlı bir hesabın bulunamadı.\nKayıt olmak için şifreni aşağıya gir:", "Tamam", "Çıkış", ReturnName(playerid));
	if(cache_num_rows() > 0) return Dialog_Show(playerid, Giris, DIALOG_STYLE_PASSWORD, "Pizza Hayatı - Giriş Yap", "{ffffff}Tekrardan sunucumuza hoşgeldin, {cccccc}%s {ffffff}\nVeritabanında kayıtlı bir hesabın bulundu.\nLütfen oyuna girebilmek için şifreni gir:", "Tamam", "Çıkış", ReturnName(playerid));
	cache_delete(c1c);
    return 1;
}
Dialog:Kayit(playerid, response, listitem, inputtext[])
{
	if(!response) Kick(playerid);
	if(response)
	{
		if(strlen(inputtext) > MAX_PLAYER_NAME) return Dialog_Show(playerid, Kayit, DIALOG_STYLE_INPUT, "Pizza Hayatı - Kayıt Ol", "{ffffff}Sunucumuza hoşgeldin, {cccccc}%s. {ffffff}\nVeritabanında kayıtlı bir hesabın bulunamadı.\nŞifreniz %d karakterden uzun olamaz!\nKayıt olmak için şifreni aşağıya gir:", "Tamam", "Çıkış", ReturnName(playerid), MAX_PLAYER_NAME);
		if(strlen(inputtext) < 5) return Dialog_Show(playerid, Kayit, DIALOG_STYLE_INPUT, "Pizza Hayatı - Kayıt Ol", "{ffffff}Sunucumuza hoşgeldin, {cccccc}%s. {ffffff}\nVeritabanında kayıtlı bir hesabın bulunamadı.\nŞifreniz 5 karakterden kısa olamaz!\nKayıt olmak için şifreni aşağıya gir:", "Tamam", "Çıkış", ReturnName(playerid));
		new ddr[150];
		mysql_format(pizza, ddr, 150, "INSERT INTO `oyuncular` (`Isim`, `Skor`, `Para`, `Sifre`, `pMaas`) VALUES ('%s', '0', '0', md5('%s'), '300')", ReturnName(playerid), inputtext);
		new Cache:fzk = mysql_query(pizza, ddr);
		MesajGonder(playerid, "Başarıyla kayıt oldunuz, lobiye yönlendiriliyorsunuz. SQLID: %d.", cache_insert_id());
		PlayerData[playerid][pID] = cache_insert_id();
		PlayerData[playerid][pSkor] = 0;
		PlayerData[playerid][pCash] = 0;
		PlayerData[playerid][pAdmin] = 0;
		PlayerData[playerid][pMaas] = 300;
		Spawnla(playerid);
		return cache_delete(fzk);
	}
	if(!response) return Kick(playerid);
	return 1;
}
Dialog:Giris(playerid, response, listitem, inputtext[])
{
	if(!response) Kick(playerid);
	if(response)
	{
		new query[150];
		mysql_format(pizza, query, 150, "SELECT * FROM `oyuncular` WHERE `Isim` = '%s' AND `Sifre` = md5('%s')", ReturnName(playerid), inputtext);
		new Cache:dogr = mysql_query(pizza, query);
		if(!cache_num_rows()) return Dialog_Show(playerid, Giris, DIALOG_STYLE_PASSWORD, "Pizza Hayatı - Giriş Yap", "{ffffff}Tekrardan sunucumuza hoşgeldin, {cccccc}%s {ffffff}\nVeritabanında kayıtlı bir hesabın bulundu.\nHatalı Şifre!\nLütfen oyuna girebilmek için şifreni gir:", "Tamam", "Çıkış", ReturnName(playerid));
		if(cache_num_rows() > 0)
		{
		    cache_get_value_name_int(0, "ID", PlayerData[playerid][pID]);
		    cache_get_value_name_int(0, "Skor", PlayerData[playerid][pSkor]);
		    cache_get_value_name_int(0, "Para", PlayerData[playerid][pCash]);
		    cache_get_value_name_int(0, "Admin", PlayerData[playerid][pAdmin]);
			cache_get_value_name_int(0, "pMaas", PlayerData[playerid][pMaas]);
			GivePlayerMoney(playerid, PlayerData[playerid][pCash]);
			SetPlayerScore(playerid, PlayerData[playerid][pSkor]);
		    Spawnla(playerid);
		}
		return cache_delete(dogr);
	}
	return 1;
}
stock YetersizSeviye(playerid, level) return HataMesajGonder(playerid, "Bu komutu kullanabilmek için en az %d level yetkili olmalısınız.", level);
stock Log_Write(const path[], const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    File:file,
	    string[1024]
	;
	if ((start = strfind(path, "/")) != -1) {
	    strmid(string, path, 0, start + 1);

	    if (!fexist(string))
	        return printf("** Uyari: Dosya \"%s\" bulunmuyor.", string);
	}
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	file = fopen(path, io_append);

	if (!file)
	    return 0;

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 1024
		#emit PUSH.C string
		#emit PUSH.C args
		#emit SYSREQ.C format

		fwrite(file, string);
		fwrite(file, "\r\n");
		fclose(file);

		#emit LCTRL 5
		#emit SCTRL 4
		#emit RETN
	}
	fwrite(file, str);
	fwrite(file, "\r\n");
	fclose(file);

	return 1;
}
stock SiparisleriGoster(playerid)
{
	new str[760], str1[60], count = 0;
	str = "#\tPizza Sayısı\tIsim\n";
	for(new i = 0; i < MAX_SIPARIS; i++) if(Siparisler[i][sExists] && !Siparisler[i][sHazir] && !Siparisler[i][sPaket] && Siparisler[i][sOnay])
	{
		count++;
		format(str1, 60, "{22af1d}#%d\t%d\t{cccccc}Tıkla!\n", i, Siparisler[i][PizzaSayi], (Siparisler[i][sOnay] == true) ? ("{ff0000}") : ("{00ff00}"), (Siparisler[i][sOnay] == true) ? ("Onaylandı") : ("Onaylanmadı"));
		strcat(str, str1);
	}
	if(count == 0) return HataMesajGonder(playerid, "Hiç bekleyen sipariş yok.");
	strcat(str, "\n \n{ffffff}Sipariş detaylarını incelemek için üstüne tıklayınız!");
	Dialog_Show(playerid, PizzaMenu, DIALOG_STYLE_TABLIST_HEADERS, "Pizza Üretme Menüsü", str, "Seç", "Kapat");
	return 1;
}
PlayAnimEx(playerid, animlib[], animname[], Float:fDelta, loop, lockx, locky, freeze, time, forcesync)
{
    if (GetPlayerAnimationIndex(playerid) != 0) ClearAnimations(playerid);
    ApplyAnimation(playerid, animlib, animname, fDelta, loop, lockx, locky, freeze, time, forcesync);
    return 1;
}
Dialog:PizzaMenu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(PlayerData[playerid][pMeslek] != 3) return HataMesajGonder(playerid, "Aşçı değilsiniz.");
		new id = strval(inputtext), baslik[35];
		format(baslik, 35, "Sipariş #%d", id);
		if(Siparisler[id][sExists] == false) return HataMesajGonder(playerid, "Olağan hata durumu #1");
		SetPVarInt(playerid, "secimPizza", id);
		Dialog_Show(playerid, SiparisYonet, DIALOG_STYLE_LIST, baslik, "Sipariş Adresi: %s\n \n \n{ff9900}» {ffffff}Sipariş İçeriğindeki Pizzayı Üretmek İçin Tıkla!\n{ff9900}» {ffffff}Siparişi Silmek İçin Tıkla!", "Seç", "Kapat", Siparisler[id][sAdres]);
	}
	return 1;
}
Dialog:SiparisYonet(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(PlayerData[playerid][pMeslek] != 3) return HataMesajGonder(playerid, "Aşçı değilsiniz.");
		new id = GetPVarInt(playerid, "secimPizza");
		if(!Siparisler[id][sExists]) return HataMesajGonder(playerid, "Olağan hata durumu #1");
		if(listitem == 3)
		{
			if(ToplamMalzeme < PIZZA_MALZEME) return HataMesajGonder(playerid, "Yeterli malzeme yok, %d/%d.", ToplamMalzeme, PIZZA_MALZEME);
			MesajGonder(playerid, "Pizza hazırlanıyor lütfen 30 saniye bekleyin..");
			SendPizzaMessage(COLOR_WHITE, "%s adlı aşçı #%d nolu pizzayı hazırlamaya başladı.", ReturnName(playerid), id);
			TogglePlayerControllable(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerChatBubble(playerid, "Pizza Hazırlıyor..", COLOR_ORANGE, 10.0, 30000);
			PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
			PizzaTimer[playerid] = SetTimerEx("PizzaHazirla", 30000, false, "d", playerid);
		}
		if(listitem == 4)
		{
			SendPizzaMessage(COLOR_WHITE, "%s adlı aşçı #%d nolu pizza siparişini sildi.", ReturnName(playerid), id);
			Siparisler[id][sExists] = false;
			format(Siparisler[id][sAdres], 50, "Yok"); //Siparisler[id][sAdres] = "Yok";
			DeletePVar(playerid, "secimPizza");
		}
	}
	return 1;
}
StopLoopingAnim(playerid)
{
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
    return 1;
}
forward PizzaHazirla(playerid);
public PizzaHazirla(playerid)
{
	if(PlayerData[playerid][pMeslek] != 3) return HataMesajGonder(playerid, "Aşçı değilsiniz.");
	new id = GetPVarInt(playerid, "secimPizza");
	Siparisler[id][sHazir] = true;
	Siparisler[id][sPaket] = false;
	StopLoopingAnim(playerid);
	ClearAnimations(playerid);
	TogglePlayerControllable(playerid, 1);
	SendPizzaMessage(COLOR_WHITE, "%s adlı aşçı #%d nolu pizzayı hazırladı, paketlemeye gönderdi.", ReturnName(playerid), id);
	MesajGonder(playerid, "Pizza hazırlandı. Paketlenmeye gönderildi.");
	KillTimer(PizzaTimer[playerid]);
	return 1;
}
stock PaketlemeMenu(playerid)
{
	/*
	bool:sExists,
	sAdres[50],
	bool:sHazir,
	bool:sPaket,
	*/
	new str1[60], str[500], baslik[60], count = 0;
	str = "#\tPizza Sayısı\tIsim\n";
	for(new i = 0; i < MAX_SIPARIS; i++) if(Siparisler[i][sExists] == true && Siparisler[i][sPaket] == false && Siparisler[i][sHazir] == true && Siparisler[i][sOnay])
	{
		format(str1, 60, "{22AF1D}#%d\t%d\t{ffffff}Paketle!\n", i, Siparisler[i][PizzaSayi]);
		strcat(str, str1);
		count++;
	}
	if(count == 0) return HataMesajGonder(playerid, "Hiç paketlenecek sipariş yok.");
	strcat(str, "\n \nPaketlemek için üstüne tıklayın!");
	format(baslik, 60, "Siparişler - %d", count);
	Dialog_Show(playerid, Paketlemee, DIALOG_STYLE_TABLIST_HEADERS, baslik, str, "Seç", "Kapat");
	return 1;
}
Dialog:Paketlemee(playerid, response, listitem, inputtext[])
{
	if(response)
	{ 
		new id = strval(inputtext);
		if(!Siparisler[id][sExists]) return HataMesajGonder(playerid, "Olağan hata durumu #1");
		SendPizzaMessage(COLOR_WHITE, "%s adlı pizza paketleyicisi #%d nolu pizzayı paketlemeye başladı.", ReturnName(playerid), id);
		SetPVarInt(playerid, "secimPizza", id);
		PizzaTimer[playerid] = SetTimerEx("PaketlemeTimer", 15000, false, "d", playerid);
		TogglePlayerControllable(playerid, 0);
		SetCameraBehindPlayer(playerid);
		SetPlayerChatBubble(playerid, "Pizza Paketliyor..", COLOR_ORANGE, 10.0, 15000);
		PlayAnimEx(playerid, "BD_FIRE", "wash_up", 4.0, 1, 0, 0, 0, 0, 1);
	}
	return 1;
}
forward PaketlemeTimer(playerid);
public PaketlemeTimer(playerid)
{
	new id = GetPVarInt(playerid, "secimPizza");
	if(!Siparisler[id][sExists]) return HataMesajGonder(playerid, "Olağan hata durumu #1");
	SendPizzaMessage(COLOR_WHITE, "%s adlı pizza paketleyicisi #%d nolu pizzayı paketledi.", ReturnName(playerid), id);
	Siparisler[id][sPaket] = true;
	Siparisler[id][sKurye] = INVALID_VEHICLE_ID;
	TogglePlayerControllable(playerid, 1);
	StopLoopingAnim(playerid);
	ClearAnimations(playerid);
	KillTimer(PizzaTimer[playerid]);
	return 1;
}
stock EvYakin(playerid)
{
	for(new i = 0; i < MAX_EV; i++) if(EvData[i][evExists] == true)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]))
			return i;
	}
	return -1;
}
stock Ev_Olustur(Float:xx, Float:yy, Float:zz, adres[])
{
	new str1[150], Cache:mlsf, query[300];//str1[150], Cache:mlsf, query[300];
	for(new i = 0; i < MAX_EV; i++) if(!EvData[i][evExists])
	{
		EvData[i][evExists] = true;
		EvData[i][evSahip] = INVALID_PLAYER_ID;
		format(EvData[i][evAdres], 60, adres);
		EvData[i][evPos][0] = xx, EvData[i][evPos][1] = yy, EvData[i][evPos][2] = zz;
		new evisim[40];
		if(EvData[i][evSahip] != INVALID_PLAYER_ID) format(evisim, 40, SQLName(EvData[i][evSahip]));
		if(EvData[i][evSahip] == INVALID_PLAYER_ID) format(evisim, 40, 	"Yok");
		format(str1, 150, "{ffffff}[Ev {FF9900}%d{ffffff}]\n{ffffff}[Adres: {FF9900}%s{ffffff}]\n{ffffff}[Ev Sahibi: {FF9900}%s{ffffff}]", i, EvData[i][evAdres], evisim);
		EvData[i][evText] = CreateDynamic3DTextLabel(str1, COLOR_WHITE, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2], 20.0);
		EvData[i][evPickup] = CreateDynamicPickup(1273, 23, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2], 0);
		mysql_format(pizza, query, 300, "INSERT INTO `evler` (`evID`, `evAdres`, `evPos`) VALUES ('%d', '%s', '%0.3f|%0.3f|%0.3f')", i, adres, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]);
		mlsf = mysql_query(pizza, query);
		EvData[i][evID] = cache_insert_id();
		cache_delete(mlsf);
		return i;
	}
	return -1;
}
stock Ev_Sil(evid)
{
	EvData[evid][evExists] = false;
	format(EvData[evid][evAdres], 60,"Yok");
	EvData[evid][evSahip] = INVALID_PLAYER_ID;
	DestroyDynamic3DTextLabel(EvData[evid][evText]);
	DestroyDynamicPickup(EvData[evid][evPickup]);
	for(new i = 0; i < 3; i++) EvData[evid][evPos][i] = 0.0;
	new query[300];
	mysql_format(pizza, query, 300, "DELETE FROM `evler` WHERE `evID` = '%d'", evid);
	mysql_query(pizza, query, false);
	return 1;
}

CMD:evsil(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pAdmin] < 2) return YetersizSeviye(playerid, 2);
	new id;
	if(sscanf(params, "d", id)) return BilgiMesajGonder(playerid, "/evsil [ID]");
	if(EvData[id][evExists] == false) return HataMesajGonder(playerid, "Geçersiz ev ID.");
	MesajGonder(playerid, "%d id'li ev silindi.", id);
	return Ev_Sil(id);
}
CMD:evolustur(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pAdmin] < 2) return YetersizSeviye(playerid, 2);
	if(IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Arabada oluşturamazsınız.");
	new adres[60];
	if(sscanf(params, "s[60]", adres)) return BilgiMesajGonder(playerid, "/evolustur [Adres]");
	new Float:Poss[3];
	GetPlayerPos(playerid, Poss[0], Poss[1], Poss[2]);
	new id = Ev_Olustur(Poss[0], Poss[1], Poss[2], adres);
	if(id == -1) return HataMesajGonder(playerid, "Sunucu maksimum ev limitine ulaştı.");
	MesajGonder(playerid, "Ev oluşturuldu, %d.", id);
	return 1;
}
YonetimMenu(playerid)
{
	if(PlayerData[playerid][pMeslek] != 0) return 1;
	new str[600], topcal = 0, st, dk, sn;
	GetElapsedTime(Maas - gettime(), st, dk, sn);
	for(new i = 0; i < MESLEK_SAYI; i++) topcal += Meslekler[i][meslekSayi];
	format(str, 600, "{ff9900}» {ffffff}Çalışanlar\n{ff9900}» {ffffff}Araçlar\n \n \n{ffffff}Toplam Malzeme: {22af1d}%d\n{ffffff}Toplam Çalışan: {22af1d}%d\n{ffffff}Toplam Araba: {22af1d}%d\n{ffffff}Maaş Kalan Süre: {22af1d}%d dakika %d saniye\n{ffffff}Sipariş Alımı: %s",
		ToplamMalzeme,
		topcal,
		ToplamAraba,
		dk,
		sn,
		(SiparisAlimi == true) ? ("{22af1d}Evet") : ("{bf3131}Hayır"));
	return Dialog_Show(playerid, YonetimD, DIALOG_STYLE_LIST, "Yönetim Paneli", str, "Seç", "Kapat");
}
stock MevkiIsim(mevkii)
{
	new mevki[50];
	switch(mevkii)
	{
		case 0: format(mevki, 50, "Müdür");
		case 1: format(mevki, 50, "Kasiyer");
		case 2: format(mevki, 50, "Kurye");
		case 3: format(mevki, 50, "Aşçı");
		case 4: format(mevki, 50, "Pizza Paketleyicisi");
		case 5: format(mevki, 50, "Tedarikçi");
		case 6: format(mevki, 50, "Molada");
	}
	return mevki;
}
Dialog:YonetimD(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!OyundaDegil(playerid) && PlayerData[playerid][pMeslek] != 0) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[500], str1[60], baslik[30], count = 0;
				str = "#\tIsim\tMevki\n";
				foreach(new i : Player) if(OyundaDegil(i) && PlayerData[i][pMeslek] != -1)
				{
					count++;
					format(str1, 60, "{22af1d}#%d\t{ffffff}%s\t{cccccc}%s\n", i, ReturnName(i), MevkiIsim(PlayerData[i][pMeslek]));
					strcat(str, str1);
				}
				strcat(str, "\n \nÇalışanı yönetmek için üstüne tıklayın.");
				format(baslik, 30, "Çalışanlar - %d", count);
				Dialog_Show(playerid, Calisanlar, DIALOG_STYLE_TABLIST_HEADERS, baslik, str, "Seç", "Kapat");
			}
			case 1:
			{
				new str[500], str1[60];
				strcat(str, "{ff9900}» {ffffff}Pizza Motorları\n");
				for(new i = 0; i < sizeof(Faggiolar); i++)
				{
					format(str1, 60, "{cccccc}Faggio{ffffff} ({22AF1D}%d{ffffff})\n", Faggiolar[i]);
					strcat(str, str1);
				}
				strcat(str, "\n \n{ff9900}» {ffffff}Kamyonlar\n");
				for(new i = 0; i < sizeof(Flatbedler); i++)
				{
					format(str1, 60, "{cccccc}Flatbed{ffffff} ({22AF1D}%d{ffffff})\n", Flatbedler[i]);
					strcat(str, str1);
				}
				Dialog_Show(playerid, Araclar, DIALOG_STYLE_LIST, "Araçlar", str, "Seç", "Kapat");
			}
			case 8:
			{
				switch(SiparisAlimi)
				{
					case true:
					{
						SiparisAlimi = false;
						SendPizzaMessage(COLOR_WHITE, "%s adlı müdür tarafından sipariş alımları kapatıldı.", ReturnName(playerid));
					}
					case false:
					{
						SiparisAlimi = true;
						SendPizzaMessage(COLOR_WHITE, "%s adlı müdür tarafından sipariş alımları açıldı.", ReturnName(playerid));
					}
				}
				cmd_yonetim(playerid);
			}
		}
	}
	return 1;
}
Dialog:Araclar(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response && (strfind(inputtext, "Pizza Motorları", true) == -1 && strfind(inputtext, "Kamyonlar") == -1) && strlen(inputtext) > 1)
	{
		if(!OyundaDegil(playerid) && PlayerData[playerid][pMeslek] != 0) return 1;
		new id = -1;
		if(strfind(inputtext, "Flatbed", true) != -1 && strfind(inputtext, "Faggio", true) == -1) id = Flatbedler[listitem-10];
		if(strfind(inputtext, "Faggio", true) != -1 && strfind(inputtext, "Flatbed", true) == -1) id = Faggiolar[listitem-1];
		SetPVarInt(playerid, "sARACs", id);
		if(id == -1) return HataMesajGonder(playerid, "Olağan bug durumu #3");
		new baslik[40];
		format(baslik, 40, "%s {ffffff}({cccccc}#%d{ffffff})", ReturnVehicleModelName(GetVehicleModel(id)), id);
		Dialog_Show(playerid, AracYonetim, DIALOG_STYLE_LIST, baslik, "{ff9900}» {ffffff}Aracı Spawnla\n{ff9900}» {ffffff}Yükleri / Siparişleri", "Seç", "Kapat");
	}
	return 1;
}
Dialog:AracYonetim(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response)
	{
		if(!OyundaDegil(playerid) && PlayerData[playerid][pMeslek] != 0) return 1;
		new vehicleid = GetPVarInt(playerid, "sARACs");
		if(listitem == 0)
		{
			SetVehicleToRespawn(vehicleid);
			SendPizzaMessage(COLOR_WHITE, "%s adlı müdür %s(%d) model aracı re-spawnladı.", ReturnName(playerid), ReturnVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
			SetEngineStatus(vehicleid, 0);
			cmd_yonetim(playerid);
		}
		if(listitem == 1)
		{
			switch(GetVehicleModel(vehicleid))
			{
				case 455: Dialog_Show(playerid, AracYonet2, DIALOG_STYLE_LIST, "Araç Bilgileri - Flatbed", "{ffffff}Araçtaki Yük Sayısı: {cccccc}%d/50\n \n{ff9900}» {ffffff}Araçtaki Yükleri Boşalt", "Seç", "Kapat", TedarikYuk[vehicleid]);
				case 448:
				{
					new str[500], str1[50], count = 0;
					str = "#\tAdres\tPizza Sayısı\tIsim\n";
					for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[vehicleid][i] != -1)
					{
						count++;
						format(str1, 50, "{ff9900}%d{ffffff}\t%s\t%d\tSiparişi Sil\n", aSiparis[vehicleid][i], Siparisler[aSiparis[vehicleid][i]][sAdres], Siparisler[aSiparis[vehicleid][i]][PizzaSayi]);
						strcat(str, str1);
					}
					if(count == 0) { HataMesajGonder(playerid, "Araçta sipariş yok."); return cmd_yonetim(playerid); }
					strcat(str, "\n \n{ff9900}» {ffffff}Tüm Siparişleri Sil");
					new baslik[100];
					format(baslik, 100, "{ff9900}%s{ffffff}({ffffff}%d{ffffff}) {ffffff}Aracındaki Siparişler - Toplam {22af1d}%d", ReturnVehicleModelName(GetVehicleModel(vehicleid)), vehicleid, count);
					Dialog_Show(playerid, AracYonet2, DIALOG_STYLE_TABLIST_HEADERS, baslik, str, "Seç", "Kapat");
				}
			}
		}
	}
	return 1;
}
Dialog:AracYonet2(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response)
	{
		new vehicleid = GetPVarInt(playerid, "sARACs");
		switch(GetVehicleModel(vehicleid))
		{
			case 455:
			{
				if(listitem == 2)
				{
					if(TedarikYuk[vehicleid] == 0)
					{
						HataMesajGonder(playerid, "Bu araçta hiç yük yok.");
						return cmd_yonetim(playerid);
					}
					TedarikYuk[vehicleid] = 0;
					SendPizzaMessage(COLOR_WHITE, "%s adlı müdür tarafından Flatbed(%d) model aracın yükleri boşaltıldı.", ReturnName(playerid), vehicleid);
					foreach(new i : Player) if(OyundaDegil(i) && GetPlayerVehicleID(playerid) == vehicleid)
					{
						MesajGonder(i, "%s adlı müdür tarafından yükünüz boşaltıldı.", ReturnName(playerid));
					}
				}
			}
			case 448:
			{
				if(IsNumeric(inputtext))
				{
					new sid = strval(inputtext);
					Siparisler[aSiparis[vehicleid][sid]][sKurye] = INVALID_VEHICLE_ID;
					aSiparis[vehicleid][sid] = -1;
					SendPizzaMessage(COLOR_WHITE, "%s adlı müdür tarafından %d id'li aracın #%d nolu siparişi silindi.", ReturnName(playerid), vehicleid, sid);
					foreach(new i : Player) if(OyundaDegil(i) && GetPlayerVehicleID(playerid) == vehicleid)
					{
						MesajGonder(i, "%s adlı müdür tarafından %d no'lu siparişiniz silindi.", ReturnName(playerid), sid);
					}
				}
				if(!strcmp(inputtext, "Tüm Siparişleri Sil!"))
				{
					new count = 0;
					for(new i = 0; i < MAX_SIPARIS; i++) 
					{
						if(aSiparis[vehicleid][i] != -1) Siparisler[aSiparis[vehicleid][i]][sKurye] = INVALID_VEHICLE_ID, count++;
						aSiparis[vehicleid][i] = -1;
					}
					if(count == 0)
					{
						HataMesajGonder(playerid, "Bu araçta hiç sipariş yok.");
						return cmd_yonetim(playerid);
					}
					SendPizzaMessage(COLOR_WHITE, "%s adlı adlı müdür tarafından %d id'li aracın tüm siparişleri silindi.", ReturnName(playerid), vehicleid);
					foreach(new i : Player) if(OyundaDegil(i) && GetPlayerVehicleID(playerid) == vehicleid)
					{
						MesajGonder(i, "%s adlı müdür tarafından tüm siparişleriniz silindi.", ReturnName(playerid));
					}
				}
			}
		}
	}
	return 1;
}
Dialog:Calisanlar(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response && strcmp(inputtext, "Çalışanı yönetmek için üstüne tıklayın.", true) != 0 && strlen(inputtext) > 1)
	{
		if(!OyundaDegil(playerid)) return 1;
		new id = strval(inputtext);
		if(!OyundaDegil(id)) return HataMesajGonder(playerid, "Bu oyuncu oyunda değil.");
		SetPVarInt(playerid, "secimCalisan", id);
		new baslik[40];
		format(baslik, 40, "%s(%d)", ReturnName(id), id);
		Dialog_Show(playerid, CalisanYonet, DIALOG_STYLE_LIST, baslik, "{ff9900}» {ffffff}Mevkisini Değiştir\n{ff9900}» {ffffff}Maaşını Düzenle", "Seç", "Kapat");
	}
	return 1;
}
Dialog:CalisanYonet(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(!OyundaDegil(GetPVarInt(playerid, "secimCalisan"))) return 1;
	if(response)
	{
		if(listitem == 0)
		{
			new str[400];
			for(new i = 0; i < MESLEK_SAYI; i++) format(str, 400, "%s%s\n", str, MevkiIsim(i));
			Dialog_Show(playerid, MevkiSec, DIALOG_STYLE_LIST, "Meslek Seç", str, "Seç", "Kapat");
		}
		if(listitem == 1) Dialog_Show(playerid, MaasDuzenle, DIALOG_STYLE_INPUT, "Maaş Düzenleme", "{cccccc}%s {ffffff}adlı oyuncunun şuanki maaşı: {22af1d}%s\n{ffffff}Maaş $300 - $3000 arasında olmalıdır.\nYeni maaşını girin:", "Seç", "Kapat", ReturnName(GetPVarInt(playerid, "secimCalisan")), FormatNumber(PlayerData[GetPVarInt(playerid, "secimCalisan")][pMaas]));
	}
	return 1;
}
Dialog:MevkiSec(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response)
	{
		Meslekler[PlayerData[GetPVarInt(playerid, "secimCalisan")][pMeslek]][meslekSayi]--;
		PlayerData[GetPVarInt(playerid, "secimCalisan")][pMeslek] = listitem;
		Meslek_Spawn(GetPVarInt(playerid, "secimCalisan"));
		SendPizzaMessage(COLOR_WHITE, "%s adlı müdür tarafından %s adlı çalışanın mevkisi %s olarak ayarlandı.", ReturnName(playerid), ReturnName(GetPVarInt(playerid, "secimCalisan")), MevkiIsim(listitem));
		if(PlayerData[playerid][pMeslek] == 0) cmd_yonetim(playerid);
	}
	return 1;
}
Dialog:MaasDuzenle(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_yonetim(playerid);
	if(response)
	{
		if(strval(inputtext) < 300 || strval(inputtext) > 3000) return HataMesajGonder(playerid, "En az $300 en fazla $3000 girilebilir.");
		new userid = GetPVarInt(playerid, "secimCalisan");
		PlayerData[userid][pMaas] = strval(inputtext);
		SendPizzaMessage(COLOR_WHITE, "%s adlı yönetici tarafından %s adlı çalışanın maaşı %s olarak ayarlandı.", ReturnName(playerid), ReturnName(userid), FormatNumber(strval(inputtext)));
		MesajGonder(userid, "%s adlı yönetici tarafından maaşınız %s olarak ayarlandı.", ReturnName(playerid), FormatNumber(strval(inputtext)));
		cmd_yonetim(playerid);
	}
	return 1;
}
CMD:yonetim(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 0) return HataMesajGonder(playerid, "Müdür değilsiniz.");
	return YonetimMenu(playerid);
}
CMD:genelyardim(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	switch(PlayerData[playerid][pMeslek])
	{
		case 0: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}MÜDÜR: {ffffff}Çalışanlar arasında düzeni sağlamak.");
		case 1: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}KASİYER: {ffffff}Gelen ziyaretçileri karşılayıp, siparişlerini aldıktan sonra siparişi diğer çalışanlara sistem yoluyla iletmek.");
		case 2: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}KURYE: {ffffff}Paketlenmiş pizzaları sıcak şekilde teslim edilmesi gereken eve yetiştirmek.");
		case 3: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}AŞÇI: {ffffff}Gelen siparişler doğrultusunda sıcak pizzalar hazırlamak.");
		case 4: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}PİZZA PAKETLEYİCİSİ: {ffffff}Aşçılar tarafından hazırlanmış enfes pizzaları paketlemek.");	
		case 5: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}TEDARİKÇİ: {ffffff}Enfes pizzaların malzemelerini taşımak.");
	}
	if(PlayerData[playerid][pMeslek] != 6) MesajGonder(playerid, "Mesleğiniz hakkında komut bilgilerini öğrenmek için /yardim.");
	return 1;
}
CMD:yardim(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	switch(PlayerData[playerid][pMeslek])
	{
		case 0: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}MÜDÜR: {ffffff}/yonetim");
		case 1: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}KASİYER: {ffffff}/kasiyer");
		case 2: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}KURYE: {ffffff}/siparis");
		case 3: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}AŞÇI: {ffffff}/pizza");
		case 4: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}PİZZA PAKETLEYİCİSİ: {ffffff}/paket");
		case 5: SendClientMessage(playerid, COLOR_WHITE, "{cccccc}TEDARİKÇİ: {ffffff}/tedarik");
	}
	if(PlayerData[playerid][pMeslek] != 6) MesajGonder(playerid, "Mesleğiniz hakkında genel bilgi edinmek için /genelyardim");
	return 1;
}
Dialog:KuryeMenu(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Araçta değilsiniz.");
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 448) return HataMesajGonder(playerid, "Motorda değilsiniz.");
		if(PlayerData[playerid][pMeslek] != 2) return HataMesajGonder(playerid, "Kurye değilsiniz.");
		if(!strcmp(inputtext, "Sayfayı Yenile!", true)) return cmd_siparis(playerid);
		new id = strval(inputtext), bos = -1;
		for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[GetPlayerVehicleID(playerid)][i] == id) return HataMesajGonder(playerid, "Bu sipariş zaten sizin.");
		if(Siparisler[id][sKurye] != INVALID_VEHICLE_ID) return HataMesajGonder(playerid, "Bu sipariş başka bir araç tarafından alınmış.");
		if(!Siparisler[id][sExists]) return HataMesajGonder(playerid, "Olağan hata durumu #1");
		Siparisler[id][sKurye] = GetPlayerVehicleID(playerid);
		for(new i = 0; i < MAX_SIPARIS; i++)
		{
			if(aSiparis[GetPlayerVehicleID(playerid)][i] == -1)
			{
				aSiparis[GetPlayerVehicleID(playerid)][i] = id;
				bos = i;
				break;
			}
		}
		if(bos == -1) return HataMesajGonder(playerid, "Boş yeriniz yok.");
		SendPizzaMessage(COLOR_WHITE, "%s adlı kurye #%d nolu siparişi aracına yükledi.", ReturnName(playerid), id);
	}
	return 1;
}
stock YakinEv(playerid)
{
	for(new i = 0; i < MAX_EV; i++)
	{
		if(IsPlayerInRangeOfPoint(playerid, 10.0, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]))
		{
			return i;
		}
	}
	return -1;
}
ReturnVehicleModelName(model)
{
	new
	    name[32] = "None";

    if (model < 400 || model > 611)
	    return name;

	format(name, sizeof(name), g_arrVehicleNames[model - 400]);
	return name;
}
Dialog:SSecim(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		if(listitem == 0)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Araçta değilsiniz.");
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 448) return HataMesajGonder(playerid, "Motorda değilsiniz.");
			if(!IsPlayerInRangeOfPoint(playerid, 30.0, 2112.1772, -1772.8372, 13.3930)) return HataMesajGonder(playerid, "Sipariş noktasına yakın değilsiniz.");
			new str[650], str1[60], count = 0;
			str = "#\tPizza Sayısı\tIsim\n";
			for(new i = 0; i < MAX_SIPARIS; i++) if(Siparisler[i][sExists] == true && Siparisler[i][sHazir] == true && Siparisler[i][sPaket] == true && Siparisler[i][sKurye] == INVALID_VEHICLE_ID && Siparisler[i][sOnay])
			{
				count++;
				format(str1, 60, "{22AF1D}#%d\t%d\t{cccccc}Yükle!\n", i, Siparisler[i][PizzaSayi]);
				strcat(str, str1);
			}
			if(count == 0) return HataMesajGonder(playerid, "Hiç hazır sipariş yok.");
			strcat(str, "\n \nSayfayı Yenile!");
			Dialog_Show(playerid, KuryeMenu, DIALOG_STYLE_TABLIST_HEADERS, "Siparişler", str, "Seç", "Kapat");
			return 1;
		}
		if(listitem == 1)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Araçta değilsiniz.");
			new count = 0, vehicleid = GetPlayerVehicleID(playerid); 
			if(GetVehicleModel(vehicleid) != 448) return HataMesajGonder(playerid, "Motorda değilsiniz.");
			for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[vehicleid][i] != -1) count++;
			if(count == 0) return HataMesajGonder(playerid, "Aracınızda hiç sipariş yok.");
			new str[500], str1[50];
			str = "#\tAdres\t\tIsim\n";
			for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[vehicleid][i] != -1)
			{
				format(str1, 50, "{ff9900}#%d{ffffff}\t%s\t\tİncele..\n", aSiparis[vehicleid][i], Siparisler[aSiparis[vehicleid][i]][sAdres], Siparisler[aSiparis[vehicleid][i]][PizzaSayi]);
				strcat(str, str1);
			}
			strcat(str, "\n \nSiparişi incelemek için üstüne tıkla!");
			new baslik[100];
			format(baslik, 100, "{ff9900}%s{ffffff}({ffffff}%d{ffffff}) {ffffff}Aracındaki Siparişler - Toplam {22af1d}%d", ReturnVehicleModelName(GetVehicleModel(vehicleid)), vehicleid, count);
			Dialog_Show(playerid, AractakiSiparisler, DIALOG_STYLE_TABLIST_HEADERS, baslik, str, "Seç", "Kapat");
		}
		if(listitem == 2)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Araçta değilsiniz.");
			if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 448) return HataMesajGonder(playerid, "Motorda değilsiniz.");
			if(YakinEv(playerid) == -1) return HataMesajGonder(playerid, "Eve yakın değilsiniz.");
			new sid = -1;
			for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[GetPlayerVehicleID(playerid)][i] != -1 && Siparisler[aSiparis[GetPlayerVehicleID(playerid)][i]][sKurye] == GetPlayerVehicleID(playerid))
			{
					if(!strcmp(Siparisler[aSiparis[GetPlayerVehicleID(playerid)][i]][sAdres], EvData[YakinEv(playerid)][evAdres], true))
					{
						sid = i; 
						break;
					}
			}
			if(sid == -1) return HataMesajGonder(playerid, "Bu eve teslimatınız yok.");
			SendPizzaMessage(COLOR_WHITE, "%s adlı oyuncu #%d nolu siparişi teslim etti.", ReturnName(playerid), aSiparis[GetPlayerVehicleID(playerid)][sid]);
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sExists] = false;
			format(Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sAdres], 50, "Yok");
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sHazir] = false;
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sPaket] = false;
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sOnay] = false;
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][PizzaSayi] = 0;
			Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sKurye] = INVALID_VEHICLE_ID;
			aSiparis[GetPlayerVehicleID(playerid)][sid] = -1;
			SetPlayerChatBubble(playerid, "Sipariş Teslim Ediyor..", COLOR_ORANGE, 15.0, 2000);
		}
	}
	return 1;
}
CMD:siparis(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 2) return HataMesajGonder(playerid, "Kurye değilsiniz.");
	if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Araçta değilsiniz.");
	if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 448) return HataMesajGonder(playerid, "Motorda değilsiniz.");
	Dialog_Show(playerid, SSecim, DIALOG_STYLE_LIST, "Kurye Sipariş Menüsü", "{FF9900}» {ffffff}Sipariş Al\n{FF9900}» {ffffff}Aracınızdaki Siparişler\n{FF9900}» {ffffff}Sipariş Teslim Et", "Seç", "Kapat");
	return 1;
}

Dialog:AractakiSiparisler(playerid, response, listitem, inputtext[])
{
	if(response && strcmp(inputtext, "Siparişi incelemek için üstüne tıkla!", true) != 0 && strlen(inputtext) > 1)
	{
		if(PlayerData[playerid][pMeslek] != 2) return HataMesajGonder(playerid, "Kurye değilsiniz.");
		new sid = strval(inputtext), baslik[31];
		format(baslik, 31, "Sipariş #%d", sid);
		SetPVarInt(playerid, "sipID", sid);
		Dialog_Show(playerid, SidYonetim, DIALOG_STYLE_LIST, baslik, "{FF9900}» {ffffff}Siparişi Geri Bırak\n{FF9900}» {ffffff}Sipariş Adresini İşaretle\n \nSipariş Adresi: {cccccc}%s", "Seç", "Geri", Siparisler[aSiparis[GetPlayerVehicleID(playerid)][sid]][sAdres]);
	}	
	return 1;
}
Dialog:SidYonetim(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_siparis(playerid);
	if(response)
	{
		if(PlayerData[playerid][pMeslek] != 2) return HataMesajGonder(playerid, "Kurye değilsiniz.");
		new sid = GetPVarInt(playerid, "sipID");
		if(sid == -1) return HataMesajGonder(playerid, "Olağan hata durumu #2");
		if(!IsPlayerInAnyVehicle(playerid)) return HataMesajGonder(playerid, "Herhangi bir araçta değilsiniz.");
		new vehicleid = GetPlayerVehicleID(playerid);
		if(listitem == 0)
		{
			SendPizzaMessage(COLOR_WHITE, "%s adlı kurye #%d nolu siparişini geri bıraktı.", ReturnName(playerid), aSiparis[vehicleid][sid]);
			MesajGonder(playerid, "#%d no'lu sipariş geri bırakıldı.", aSiparis[vehicleid][sid]);
			Siparisler[aSiparis[vehicleid][sid]][sKurye] = INVALID_VEHICLE_ID;
			aSiparis[vehicleid][sid] = -1;
		}
		if(listitem == 1)
		{
			for(new i = 0; i < MAX_EV; i++) if(EvData[i][evExists] == true && !strcmp(EvData[i][evAdres], Siparisler[aSiparis[vehicleid][sid]][sAdres], true))
			{
				SetPlayerCheckpoint(playerid, 5.0, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]);
				MesajGonder(playerid, "Teslimat noktası haritada işaretlendi.");
				break;
			}
		}
	}
	return 1;
}
CMD:paket(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 4) return HataMesajGonder(playerid, "Pizza paketleyicisi değilsiniz.");
	return PaketlemeMenu(playerid);
}
	/*	Meslekler[0][meslekAd] = "Müdür", Meslekler[0][meslekMax] = 1;
	Meslekler[1][meslekAd] = "Kasiyer";
	Meslekler[2][meslekAd] = "Kurye";
	Meslekler[3][meslekAd] = "Aşçı";
	Meslekler[4][meslekAd] = "Pizza Paketleyicisi";
	Meslekler[5][meslekAd] = "Tedarikçi";*/
CMD:sipariskoy(playerid)
{
	ToplamMalzeme = 100;
	Siparisler[0][sExists] = true;
	format(Siparisler[0][sAdres], 50, "Deneme");
	Siparisler[0][sHazir] = false;
	Siparisler[0][sPaket] = false;
	Siparisler[0][sKurye] = INVALID_VEHICLE_ID;
	Siparisler[0][sOnay] = true;
	Siparisler[0][PizzaSayi] = 1;
	Siparisler[1][sExists] = true;
	format(Siparisler[1][sAdres], 50, "Deneme2");
	Siparisler[1][sHazir] = false;
	Siparisler[1][sPaket] = false;
	Siparisler[1][sOnay] = true;
	Siparisler[1][PizzaSayi] = 2;
	Siparisler[1][sKurye] = INVALID_VEHICLE_ID;
	return 1;
}
stock KasiyerMenu(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 1) return HataMesajGonder(playerid, "Kasiyer değilsiniz.");
	new kstr[60], str[1000], count = 0;
	str = "#\t\tPizza Sayısı\tAdres\t\tDurum\n";
	for(new i = 0; i < MAX_SIPARIS; i++) if(Siparisler[i][sExists] && Siparisler[i][sKurye] == INVALID_VEHICLE_ID && Siparisler[i][sPaket] == false)
	{
		format(kstr, 60, "{ff9900}#%d\t\t{cccccc}%d\t{ffffff}%s\t\t%s\n", i, Siparisler[i][PizzaSayi], Siparisler[i][sAdres], (Siparisler[i][sOnay] == true) ? ("{ff0000}Onaylandı") : ("{00ff00}Onaylanmadı"));	
		strcat(str, kstr);
		count++;
	}
	if(count == 0) return HataMesajGonder(playerid, "Hiç sipariş/müşteri yok.");
	Dialog_Show(playerid, SiparisDG1, DIALOG_STYLE_TABLIST_HEADERS, "Sipariş Yönetim Meünüsü", str, "Seç", "Kapat");
	return 1;
}
Dialog:SiparisDG1(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = strval(inputtext);
		if(Siparisler[id][sExists] == false) return 1;
		if(!OyundaDegil(playerid)) return 1;
		if(PlayerData[playerid][pMeslek] != 1) return 1;
		if(Siparisler[id][sOnay] == true) { MesajGonder(playerid, "Bu müşterinin siparişi onaylanmış."); return cmd_kasiyer(playerid); }
		SetPVarInt(playerid, "sidg2", id);
		Dialog_Show(playerid, SiparisDG2, DIALOG_STYLE_LIST, "Kasiyer Menüsü - Sipariş", "{ffffff}Adres: {cccccc}%s\n{ffffff}Pizza Sayısı: {cccccc}%d\n{ffffff}Sipariş ID: {cccccc}#%d\n \n{ff9900}» {cccccc}Siparişi İlet\n{ff9900}» {cccccc}Siparişi Sil", "Seç", "Kapat", Siparisler[id][sAdres], Siparisler[id][PizzaSayi], id);
	}
	return 1;
}
Dialog:SiparisDG2(playerid, response, listitem, inputtext[])
{
	if(!response) cmd_kasiyer(playerid);
	if(response)
	{
		new id = GetPVarInt(playerid, "sidg2");
		if(Siparisler[id][sExists] == false) return 1;
		if(!OyundaDegil(playerid)) return 1;
		if(PlayerData[playerid][pMeslek] != 1) return 1;
		if(Siparisler[id][sOnay] == true) { MesajGonder(playerid, "#%d nolu müşterinin siparişi onaylanmış.", id); return cmd_kasiyer(playerid); }
		switch(listitem)
		{
			case 4:
			{
				SendPizzaMessage(COLOR_WHITE, "%s adlı kasiyer #%d nolu müşteri siparişini onayladı ve üretime yolladı!", ReturnName(playerid), id);
				Siparisler[id][sOnay] = true;
			}
			case 5:
			{
				SendPizzaMessage(COLOR_WHITE, "%s adlı kasiyer #%d nolu müşteri siparişini sildi.", ReturnName(playerid), id);
				Siparisler[id][sExists] = false;
			}
		}
	}
	return 1;
}
CMD:kasiyer(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 1) return HataMesajGonder(playerid, "Kasiyer değilsiniz.");
	return KasiyerMenu(playerid);
}
CMD:pizza(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 3) return HataMesajGonder(playerid, "Aşçı değilsiniz.");
	return SiparisleriGoster(playerid);
}
CMD:meslekler(playerid)
{
	if(!OyundaDegil(playerid)) return 1;
	if(Yukluyo[playerid] == true) return HataMesajGonder(playerid, "Şuan yapamazsınız.");
	return Show_Meslekler(playerid);
}
CMD:ban(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pAdmin] < 2) return YetersizSeviye(playerid, 2);
	new userid, sebep[50], sure;
	if(sscanf(params, "diS()[50]", userid, sure, sebep)) return BilgiMesajGonder(playerid, "/ban [ID] [Gün(0 yazarsanız sınırsız olur.)] [Sebep]");
	if(!OyundaDegil(userid)) return HataMesajGonder(playerid, "Oyuncu oyunda değil.");
	if(isnull(sebep) || strlen(sebep) > 49) return HataMesajGonder(playerid, "Geçersiz sebep.");
	if(sure < 0) return HataMesajGonder(playerid, "Geçersiz süre.");
	new suremsg[30], query[200], Cache:daa;
	if(sure == 0) suremsg = "Sınırsız";
	else format(suremsg, 30, "%d gün", sure);
	SendClientMessageToAllEx(COLOR_LIGHTRED, "Yasaklanma: %s adlı oyuncu %s adlı yetkili tarafından %s sebebiyle %s yasaklandı. >> %s <<", ReturnName(userid), ReturnName(playerid), sebep, suremsg, ReturnDate());
	mysql_format(pizza, query, 200, "INSERT INTO `bans` (`banSebep`, `banAtan`, `banYiyen`, `banSure`, `banIP`) VALUES ('%s', '%s', '%s', '%d', '%s')", sebep, ReturnName(playerid), ReturnName(userid), gettime()+ sure*86400, GetIP(userid));
	daa = mysql_query(pizza, query);
	Log_Write("admlog\ban-unban.txt", "[%s] %s(%d SQLID) adlı oyuncu %s(%d SQLID) adlı yetkili tarafından %s sebebiyle %s yasaklandı. (%d Ban ID)", ReturnDate(), ReturnName(userid), PlayerData[userid][pID], ReturnName(playerid), PlayerData[playerid][pID], sebep, suremsg, cache_insert_id());
	SetTimerEx("OyundanAt", 500, false, "d", userid);
	cache_delete(daa);
	return 1;
}
CMD:unban(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pAdmin] < 2) return YetersizSeviye(playerid, 2);
	new isim[25];
	if(sscanf(params, "s[25]", isim)) return BilgiMesajGonder(playerid, "/unban [Isim]");
	if(isnull(isim)) return HataMesajGonder(playerid, "Geçersiz isim.");
	if(IsimdenSQLID(isim) == -1) return HataMesajGonder(playerid, "Böyle bir oyuncu yok.");
	new query[300], Cache:isf;
	mysql_format(pizza, query, 300, "SELECT * FROM `bans` WHERE `banYiyen` = '%s'", isim);
	isf = mysql_query(pizza, query);
	if(!cache_num_rows()) return HataMesajGonder(playerid, "Bu oyuncu yasaklı değil.");
	mysql_format(pizza, query, 300, "DELETE FROM `bans` WHERE `banYiyen` = '%s'", isim);
	mysql_query(pizza, query, false);
	cache_delete(isf);
	SendAdminAlert("ADM: %s(%d SQLID) adlı oyuncunun yasağı %s adlı yetkili tarafından kaldırıldı.", isim, IsimdenSQLID(isim), ReturnName(playerid));
	Log_Write("admlog\ban-unban.txt", "[%s] %s(%d SQLID) adlı oyuncunun yasağı %s(%d SQLID) adlı yetkili tarafından kaldırıldı.", isim, IsimdenSQLID(isim), ReturnName(playerid), PlayerData[playerid][pID]);
	return 1;
}
//----------------------------------------------------------
stock Show_Meslekler(playerid)
{
		new str[550], str1[100];
		str = "Meslek\t\t\tMeslektekiler / Maks Kişi\n";
	    for(new i = 0; i < MESLEK_SAYI; i++)
	    {
			format(str1, 100, "{ff9900}» {cccccc}%s\t\t\t{22AF1D}%d / %d\n", Meslekler[i][meslekAd], Meslekler[i][meslekSayi], Meslekler[i][meslekMax]);
			strcat(str, str1);
	    }
		if(PlayerData[playerid][pMeslek] != -1) strcat(str, "\n \n{ffffff}Seçimi iptal edip mesleğinizde kalmak için tıklayın.");
		Dialog_Show(playerid, MeslekSecim, DIALOG_STYLE_TABLIST_HEADERS, "Pizza Hayatı - Meslek Seçimi", str, "Seç", "Varsayılan");
		return 1;
}
stock Meslek_Spawn(playerid)
{
	ClearAnimations(playerid);
	switch(PlayerData[playerid][pMeslek])
	{
	/*	Meslekler[0][meslekAd] = "Müdür", Meslekler[0][meslekMax] = 1;
	Meslekler[1][meslekAd] = "Kasiyer";
	Meslekler[2][meslekAd] = "Kurye";
	Meslekler[3][meslekAd] = "Aşçı";
	Meslekler[4][meslekAd] = "Pizza Paketleyicisi";
	Meslekler[5][meslekAd] = "Tedarikçi";*/
		case 0: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 147); // ŞİMDİLİK BÖYLE İNTERİOR EKLENİNCE DEĞİŞİCEK (MÜDÜR
		case 1: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 205);// ŞİMDİLİK BÖYLE İNTERİOR EKLENİNCE DEĞİŞİCEK (KASİYER)
		case 2: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 155); // ŞİMDİLİK BÖYLE İNTERİOR EKLENİNCE DEĞİŞİCEK (KURYE)
		case 3: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 20001); // ŞİMDİLİK BÖYLE İNTERİOR EKLENİNCE DEĞİŞİCEK (AŞÇI)
		case 4: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 217); // ŞİMDİLİK BÖYLE İNTERİOR EKLENİNCE DEĞİŞİCEK (PAKETLEYİCİ)
		case 5: SetPlayerPos(playerid, 2153.5610,-1799.5363,13.5595), SetPlayerSkin(playerid, 16); // TEDARİKÇİ SPAWN (TEDARİKÇİ)
		case 6: SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559), SetPlayerSkin(playerid, 23); // NORMAL SPAWN (MOLADA)
	}
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	/*if(newkeys == KEY_YES)
	{
		if(EvYakin(playerid) != -1)
		{
			if(EvData[EvYakin(playerid)][evKilit] == true) return HataMesajGonder(playerid, "Ev kilitli.");
			PlayerData[playerid][InsideHome] = EvYakin(playerid);
			Meslekler[PlayerData[playerid][pMeslek]][meslekSayi]--;
			PlayerData[playerid][pMeslek] = 6;
			Meslekler[6][meslekSayi]++;
			ClearAnimations(playerid);
			SetPlayerSkin(playerid, 23); // NORMAL SPAWN (MOLADA)
			SetPlayerVirtualWorld(playerid, EvYakin(playerid)+1);
			SetPlayerPos(playerid, 2324.53, -1149.54, 1050.71);
		}
		if(PlayerData[playerid][InsideHome] != -1)
		{
			new hid = PlayerData[playerid][InsideHome];
			if(EvData[hid][evKilit] == true || EvData[hid][evExists] == false) return HataMesajGonder(playerid, "Ev kilitli.");
			SetPlayerPos(playerid, EvData[hid][evPos][0], EvData[hid][evPos][1], EvData[hid][evPos][2]);
			SetPlayerVirtualWorld(playerid, 0);
		}
	}*/
	return 1;
}
public OnPlayerSpawn(playerid)
{
	if(IsPlayerNPC(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != -1)
	{
		SetPVarInt(playerid, "Logged", 1);
		TogglePlayerSpectating(playerid, 0);
	    SetPlayerInterior(playerid,0);
	    SetPlayerPos(playerid, 2071.9751,-1773.0333,13.5559);
	    SetPlayerFacingAngle(playerid, 350.8630);
	    SetPlayerVirtualWorld(playerid,0);
	    SetPlayerSkin(playerid, 23);
	    SetCameraBehindPlayer(playerid);
	}
	else
	{
		Show_Meslekler(playerid);
	}
	return 1;
}
Dialog:MeslekSecim(playerid, response, listitem, inputtext[])
{
	if(!strcmp(inputtext, "Seçimi iptal edip mesleğinizde kalmak için tıklayın.", true) && PlayerData[playerid][pMeslek] != -1)
	{
		MesajGonder(playerid, "Mesleğinizde değişiklik olmadı.");
		return 1;
	}
	if(PlayerData[playerid][pMeslek] != -1) Meslekler[PlayerData[playerid][pMeslek]][meslekSayi]--;
	if(!response)
	{
	    PlayerData[playerid][pMeslek] = 6;
		Meslekler[6][meslekSayi]++;
		MesajGonder(playerid, "Varsayılan mesleğiniz 'Molada' olarak belirlendi.");
		Spawnla(playerid);
	}
	if(response)
	{
	    if(Meslekler[listitem][meslekSayi] == Meslekler[listitem][meslekMax]) return HataMesajGonder(playerid, "Bu meslek dolu, %s.", Meslekler[listitem][meslekAd]), Show_Meslekler(playerid);
    	if(IsPlayerInAnyVehicle(playerid))
		{
		    RepairVehicle(GetPlayerVehicleID(playerid));
		    SetEngineStatus(GetPlayerVehicleID(playerid), 0);
		    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			AractanIndir(playerid);
		}
		Meslekler[listitem][meslekSayi]++;
		PlayerData[playerid][pMeslek] = listitem;
		MesajGonder(playerid, "Yeni mesleğiniz artık %s.", Meslekler[listitem][meslekAd]);
		Meslek_Spawn(playerid);
	}
	return 1;
}
//----------------------------------------------------------

public OnPlayerDeath(playerid, killerid, reason)
{
   	return 1;
}

//----------------------------------------------------------

public OnPlayerRequestClass(playerid, classid)
{
	if(IsPlayerNPC(playerid)) return 1;
 	TogglePlayerSpectating(playerid, 1);
	if (GetPVarInt(playerid, "Logged") == 1)
	{
		Spawnla(playerid);
	}
	return 0;
}
stock AractanIndir(playerid)
{
	new Float:pos[3];
	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	SetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	return 1;
}
/*CMD:kilit(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(YakinEv(playerid) == -1 && PlayerData[playerid][InsideHome] == -1) return HataMesajGonder(playerid, "Evde veya evin yakınında değilsiniz.");
	new hid = YakinEv(playerid);
	if(hid == -1) hid = PlayerData[playerid][InsideHome];
	if(EvData[hid][evSahip] != playerid) return HataMesajGonder(playerid, "Evin sahibi değilsiniz.");
	switch(EvData[hid][evKilit])
	{
		case true:
		{
			MesajGonder(playerid, "Evin kilidini açtınız.");
			EvData[hid][evKilit] = false;
		}
		case false:
		{
			MesajGonder(playerid, "Evi kilitlediniz.");
			EvData[hid][evKilit] = true;
		}
	}
	return 1;
}*/
CMD:tedarik(playerid, params[])
{
	if(!OyundaDegil(playerid)) return 1;
	if(PlayerData[playerid][pMeslek] != 5) return HataMesajGonder(playerid, "Tedarikçi değilsiniz.");
	if(!IsPlayerInAnyVehicle(playerid) && GetVehicleModel(GetPlayerVehicleID(playerid)) != 455) return HataMesajGonder(playerid, "Kamyonda değilsiniz.");
	new secim[34];
	if(sscanf(params, "s[34]", secim)) return BilgiMesajGonder(playerid, "/tedarik [yukle/teslim/donus]");
	if(!strcmp(secim, "yukle", true))
	{
		if(Yukluyo[playerid]) return HataMesajGonder(playerid, "Zaten yük yüklüyorsunuz.");
		if(IsPlayerInRangeOfPoint(playerid, 10, 2460.4893,-2117.3384,13.5530))
		{
			if(TedarikYuk[GetPlayerVehicleID(playerid)] == 50) return HataMesajGonder(playerid, "Bu araç dolmuş! 50/50");
			SetCameraBehindPlayer(playerid);
			TogglePlayerControllable(playerid, 0);
		    MesajGonder(playerid, "Yük yükleniyor, 1.5 saniye bekleyiniz.");
			YukTimer[playerid] = SetTimerEx("YukYukle", 1500, false, "d", playerid);
			Yukluyo[playerid] = true;
		}
		else return HataMesajGonder(playerid, "Bunu kullanamazsınız.");
	}
	else if(!strcmp(secim, "teslim", true))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10, 2180.6335, -1812.6969, 13.5469))
	    {
			if(TedarikYuk[GetPlayerVehicleID(playerid)] == 0) return HataMesajGonder(playerid, "Bu araç boş 0/50");
			SendPizzaMessage(COLOR_WHITE, "%s adlı tedarikçi toplam %d tedarik yükünü teslim etti!", ReturnName(playerid), TedarikYuk[GetPlayerVehicleID(playerid)]);
			ToplamMalzeme += TedarikYuk[GetPlayerVehicleID(playerid)];
			TedarikYuk[GetPlayerVehicleID(playerid)] = 0;
			RepairVehicle(GetPlayerVehicleID(playerid));
		    SetEngineStatus(GetPlayerVehicleID(playerid), 0);
		    SetVehicleToRespawn(GetPlayerVehicleID(playerid));
			AractanIndir(playerid);
	    } else return HataMesajGonder(playerid, "Bunu kullanamazsınız.");
	}
	else if(!strcmp(secim, "donus", true))
	{
	    if(IsPlayerInRangeOfPoint(playerid, 10, 2460.4893,-2117.3384,13.5530))
	    {
			MesajGonder(playerid, "Yük teslim noktası haritada işaretlendi.");
			SetPlayerCheckpoint(playerid, 2180.6335,-1812.6969,13.5469, 10.0);
	    } else return HataMesajGonder(playerid, "Bunu kullanamazsınız.");
	}
	return 1;
}
forward YukYukle(playerid);
public YukYukle(playerid)
{
	if(Yukluyo[playerid] && TedarikYuk[GetPlayerVehicleID(playerid)] != 50)
	{
	    TogglePlayerControllable(playerid, 1);
		TedarikYuk[GetPlayerVehicleID(playerid)]++;
		MesajGonder(playerid, "Araca yük yüklendi, %d/50", TedarikYuk[GetPlayerVehicleID(playerid)]);
		Yukluyo[playerid] = false;
		KillTimer(YukTimer[playerid]);
	}
	return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && IsPlayerInRangeOfPoint(playerid, 10, 2460.4893,-2117.3384,13.5530) && GetVehicleModel(GetPlayerVehicleID(playerid)) == 455 && PlayerData[playerid][pMeslek] == 5) MesajGonder(playerid, "Yük alma noktasına geldiniz, /tedarik yukle komutunu kullanın.");
	DisablePlayerCheckpoint(playerid);
	return 1;
}
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	if(GetVehicleModel(vehicleid) == 455 && PlayerData[playerid][pMeslek] != 5)
	{
	    AractanIndir(playerid);
	    ClearAnimations(playerid);
	    MesajGonder(playerid, "Tedarikçi olmadığınız için binemezsiniz.");
	}
	else if (GetVehicleModel(vehicleid) == 455 && PlayerData[playerid][pMeslek] == 5)
	{
	    SetPVarInt(playerid, "aga", 1);
	    SetTimerEx("TedarikArac", 2750, false, "d", playerid);
	}
	if(GetVehicleModel(playerid) == 448 && PlayerData[playerid][pMeslek] != 2)
	{
	    AractanIndir(playerid);
	    ClearAnimations(playerid);
	    MesajGonder(playerid, "Kurye olmadığınız için binemezsiniz.");
	}
	else if (GetVehicleModel(vehicleid) == 448 && PlayerData[playerid][pMeslek] == 2)
	{
		SetPVarInt(playerid, "aga", 1);
		SetTimerEx("KuryeArac", 2000, false, "d", playerid);
	}
	return 1;
}
forward TedarikArac(playerid);
public TedarikArac(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetEngineStatus(GetPlayerVehicleID(playerid), 1);
		if(GetPVarInt(playerid, "aga") == 1)
		{
			SendClientMessageEx(playerid, COLOR_WHITE, "{cccccc}ARAÇ: {ffffff}Bu araçtaki yük sayısı: {c9c9c9}%d/50", TedarikYuk[GetPlayerVehicleID(playerid)]);
			SendClientMessageEx(playerid, COLOR_WHITE, "{cccccc}ARAÇ: {ffffff}Tedarik yükü yüklemek için haritada işaretlenen kırmızı noktaya git.");
			SetPVarInt(playerid, "aga", 0);
		}
		SetPlayerCheckpoint(playerid, 2460.4893,-2117.3384,13.5530, 10.0);
	}
	return 1;
}
forward KuryeArac(playerid);
public KuryeArac(playerid)
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		SetEngineStatus(GetPlayerVehicleID(playerid), 1);
		if(GetPVarInt(playerid, "aga") == 1)
		{
			new count = 0, c2 = 0;
			for(new i = 0; i < MAX_SIPARIS; i++) if(aSiparis[GetPlayerVehicleID(playerid)][i] != -1) count++, c2 += Siparisler[aSiparis[GetPlayerVehicleID(playerid)][i]][PizzaSayi];
			SendClientMessageEx(playerid, COLOR_WHITE, "{cccccc}ARAÇ: {ffffff}Bu araçtaki sipariş sayısı: {c9c9c9}%d/%d.", count, MAX_SIPARIS);
			SendClientMessageEx(playerid, COLOR_WHITE, "{cccccc}ARAÇ: {ffffff}Siparişlerinizi görmek için /siparis gor. Siparişleri adreslere teslim edin.");
			SetPVarInt(playerid, "aga", 0);
		}
	}
	return 1;
}
//----------------------------------------------------------
stock AraclariYukle()
{
	Flatbedler[0] = AddStaticVehicle(455,2159.3828,-1795.9283,13.7996,179.9812,84,58); //
	Flatbedler[1] = AddStaticVehicle(455,2166.2117,-1794.8795,13.8012,180.7584,84,31); // 
	Flatbedler[2] = AddStaticVehicle(455,2173.7490,-1794.8320,13.8045,179.5240,32,74); //
	Faggiolar[0] = AddStaticVehicle(448,2118.6128,-1784.7836,12.9849,0.9508,3,6); //
	Faggiolar[1] = AddStaticVehicle(448,2115.8601,-1784.5940,12.9872,4.6151,3,6); //
	Faggiolar[2] = AddStaticVehicle(448,2111.9648,-1784.9705,12.9867,358.5999,3,6); //
	Faggiolar[3] = AddStaticVehicle(448,2109.5449,-1784.8550,12.9867,358.7396,3,6); //
	Faggiolar[4] = AddStaticVehicle(448,2106.6167,-1784.8669,12.9830,356.4091,3,6); //
	Faggiolar[5] = AddStaticVehicle(448,2103.9326,-1784.6475,12.9858,358.8599,3,6); //
	Faggiolar[6] = AddStaticVehicle(448,2100.4595,-1784.9119,12.9956,355.1586,3,6); //
	ToplamAraba = 10;
	for(new i = 0; i < MAX_VEHICLES; i++)
	{
		TedarikYuk[i] = 0;
		for(new j = 0; j < MAX_SIPARIS; j++) aSiparis[i][j] = -1;
	}
	return 1;
}
public OnGameModeExit()
{
	foreach(new i : Player) OnPlayerDisconnect(i, 1);
	new query[300];
	for(new i = 0; i < MAX_EV; i++)
	{
		if(EvData[i][evExists])
		{
			mysql_format(pizza, query, 300, "UPDATE `evler` SET `evID` = '%d', evAdres` = '%s', `evPos` = '%0.3f|%0.3f|%0.3f'", i, EvData[i][evAdres], EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]);
			mysql_query(pizza, query, false);
		}
	}
	return 1;
}
public OnGameModeInit()
{
 	AntiDeAMX();
    WasteDeAMXersTime();
	SetGameModeText("Pizza Hayatı v0.1");
	ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);
	ShowNameTags(1);
	SetNameTagDrawDistance(40.0);
	EnableStuntBonusForAll(0);
	DisableInteriorEnterExits();
	SetWeather(2);
	SetWorldTime(11);
    ManualVehicleEngineAndLights();
	AddPlayerClass(23, 2071.9751,-1773.0333,13.5559,254.2435,0,0,0,0,0,0);
	AraclariYukle();
    pizza = mysql_connect(MYSQL_HOST,MYSQL_USER,MYSQL_PASS,MYSQL_BASE);
   	if (mysql_errno(pizza) == 0)
	{
	    print("MySQL ile bağlantı başarılı.");
	    mysql_set_charset("latin5");
	    mysql_set_charset("latin5");
	    mysql_set_charset("latin5");
	    mysql_log(ERROR);
		PizzaDG = 0;
		SiparisAlimi = true;
		SetTimer("DakikaUpdate",60000,true);
		SetTimer("SaatUpdate", 3600000,true);
	    SetTimer("SaniyeUpdate",900,true);
	}
	else
	{
	    print("MySQL ile bağlantı başarısız. Sunucu kapatılıyor...");
	    SendRconCommand("exit");
	}
	Maas = gettime() + 3600;
	for(new i = 0; i < MESLEK_SAYI; i++)
	{
		Meslekler[i][meslekSayi] = 0;
		if(i != 0 && i != 6) Meslekler[i][meslekMax] = 50;
	}
	new Cache:Ozz, str[60], str1[150];
	Ozz = mysql_query(pizza, "SELECT * FROM `evler`", true);
	if(cache_num_rows() != 0)
	{
		for(new i = 0; i < cache_num_rows(); i++)
		{
			EvData[i][evID] = cache_insert_id();
			cache_get_value_name(i, "evAdres", EvData[i][evAdres], 60);
			cache_get_value_name(i, "evPos", str, 60);
			sscanf(str, "p<|>fff", EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2]);
		new evisim[40];
		if(EvData[i][evSahip] != INVALID_PLAYER_ID) format(evisim, 40, SQLName(EvData[i][evSahip]));
		if(EvData[i][evSahip] == INVALID_PLAYER_ID) format(evisim, 40, 	"Yok");
		format(str1, 150, "{ffffff}[Ev {FF9900}%d{ffffff}]\n{ffffff}[Adres: {FF9900}%s{ffffff}]\n{ffffff}[Ev Sahibi: {FF9900}%s{ffffff}]", i, EvData[i][evAdres], evisim);		EvData[i][evText] = CreateDynamic3DTextLabel(str1, COLOR_WHITE, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2], 20.0);
			EvData[i][evPickup] = CreateDynamicPickup(1273, 23, EvData[i][evPos][0], EvData[i][evPos][1], EvData[i][evPos][2], 0);
			EvData[i][evExists] = true;
			//EvData[i][evKilit] = false;
		}
		cache_delete(Ozz);
	}
		ToplamMalzeme = 0;
		format(Meslekler[0][meslekAd], 50, "Müdür"), Meslekler[0][meslekMax] = 1;
		format(Meslekler[1][meslekAd], 50, "Kasiyer"); 												//Meslekler[1][meslekAd] = "Kasiyer";
		format(Meslekler[2][meslekAd], 50, "Kurye"); 												//Meslekler[2][meslekAd] = "Kurye";
		format(Meslekler[3][meslekAd], 50, "Aşçı"); 												//Meslekler[3][meslekAd] = "Aşçı";
		format(Meslekler[4][meslekAd], 50, "Pizza Paketleyicisi"); 									//Meslekler[4][meslekAd] = "Pizza Paketleyicisi";
		format(Meslekler[5][meslekAd], 50, "Tedarikçi"); 											//Meslekler[5][meslekAd] = "Tedarikçi";
		format(Meslekler[6][meslekAd], 50, "Molada"), Meslekler[6][meslekMax] = 99999; 				//Meslekler[6][meslekAd] = "Molada", Meslekler[6][meslekMax] = 9999999;
		Create3DTextLabel("{bf3131}[Yük Alma Noktası]\n{ffffff}/tedarik", COLOR_WHITE, 2460.4893,-2117.3384,13.5530, 15.0, 0, 0);
		Create3DTextLabel("{bf3131}[Yük Teslim Noktası]\n{ffffff}/tedarik", COLOR_WHITE, 2180.6335, -1812.6969, 13.5469, 15.0, 0, 0);
	for(new i = 0; i < MAX_SIPARIS; i++)
	{
		Siparisler[i][sExists] = false;
		Siparisler[i][sKurye] = INVALID_VEHICLE_ID;
		Siparisler[i][sOnay] = false;
		Siparisler[i][sHazir] = false;
		Siparisler[i][sPaket] = false;
		Siparisler[i][PizzaSayi] = 0;
		format(Siparisler[i][sAdres], 60, "Yok");
	}
	return 1;
}
stock ParaVer(playerid, amount)
{
	GivePlayerMoney(playerid, amount);
	PlayerData[playerid][pCash] += amount;
	return 1;
}
stock RandomEv()
{
	new deger = RandomEx(0, MAX_EV);
	if(EvData[deger][evExists] == true) return deger;
	while(EvData[deger][evExists] == true)
	{
		deger = RandomEx(0, MAX_EV);
	}
	return deger;
}
stock GetEvCount()
{
	new count = 0;
	for(new i = 0; i < MAX_EV; i++) if(EvData[i][evExists] == true)
	{
		count++;
	}
	return count;
}
forward DakikaUpdate(); forward SaatUpdate(); forward SaniyeUpdate();
forward OyundanAt(playerid);
public OyundanAt(playerid) return Kick(playerid);
public DakikaUpdate()
{
	if(gettime() >= Maas)
	{
		foreach(new i : Player) if(OyundaDegil(i))
		{
			MesajGonder(i, "Maaş vaktiniz geldi ve {22af1d}%s {ffffff}kazandınız.", FormatNumber(PlayerData[i][pMaas]));
			ParaVer(i, PlayerData[i][pMaas]);
		}
	}
	/*
		bool:sExists,
	sAdres[50],
	bool:sHazir,
	bool:sPaket,
	sKurye,
	PizzaSayi,
	bool:sOnay
	*/
	if(PizzaDG == 1)
	{
		if(Meslekler[1][meslekSayi] != 0 && GetEvCount() != 0 && SiparisAlimi == true)
		{
			new idsd;
			for(new i = 0; i < MAX_SIPARIS; i++) if(Siparisler[i][sExists] == false)
			{
				Siparisler[i][sExists] = true;
				format(Siparisler[i][sAdres], 50, EvData[RandomEv()][evAdres]);
				Siparisler[i][sHazir] = false;
				Siparisler[i][sPaket] = false;
				Siparisler[i][sKurye] = INVALID_VEHICLE_ID;
				Siparisler[i][PizzaSayi] = RandomEx(1, 5);
				Siparisler[i][sOnay] = false;
				idsd = i;
				break;
			}
			SendPizzaMessage(COLOR_WHITE, "Sipariş geldi! #%d", idsd);
		}
		PizzaDG = 0;
	}
	if(PizzaDG == 0) PizzaDG++;
	return 1;
}
public SaatUpdate()
{
	new Cache:htr, bansure, query[300], id;
	htr = mysql_query(pizza, "SELECT * FROM `bans`");
	if(cache_num_rows())
	{
	    for(new i = 0; i < cache_num_rows(); i++)
	    {
	        cache_get_value_name_int(i, "banSure", bansure);
	        if(bansure != 0 && bansure < gettime())
	        {
				cache_get_value_name_int(i, "banID", id);
				mysql_format(pizza, query, 300, "DELETE FROM `bans` WHERE `banID` = '%d'", id);
				mysql_query(pizza, query, false);
		    }
		}
	}
	cache_delete(htr);
}
/*public SaniyeUpdate()
{

}*/
stock SetVehicleSpeed(vehicleid, Float:speed)
{
	new Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2, Float:a;
	GetVehicleVelocity(vehicleid, x1, y1, z1);
	GetVehiclePos(vehicleid, x2, y2, z2);
	GetVehicleZAngle(vehicleid, a); a = 360 - a;
	x1 = (floatsin(a, degrees) * (speed/100) + floatcos(a, degrees) * 0 + x2) - x2;
	y1 = (floatcos(a, degrees) * (speed/100) + floatsin(a, degrees) * 0 + y2) - y2;
	SetVehicleVelocity(vehicleid, x1, y1, z1);
}
stock GetClosestCar(iPlayer, iException = INVALID_VEHICLE_ID, Float: fRange = Float: 0x7F800000) {

	new
		iReturnID = -1,
		Float: fVehiclePos[4];

	for (new i = 0; i <= MAX_VEHICLES; ++i) if (GetVehicleModel(i) && i != iException) {
		GetVehiclePos(i, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2]);
		if ((fVehiclePos[3] = GetPlayerDistanceFromPoint(iPlayer, fVehiclePos[0], fVehiclePos[1], fVehiclePos[2])) < fRange) {
			fRange = fVehiclePos[3];
			iReturnID = i;
		}
	}
	return iReturnID;
}
stock Float:GetVehicleSpeed(vehicleid)
{
    new Float: vx, Float: vy, Float: vz, Float: vel;
    vel = GetVehicleVelocity(vehicleid, vx, vy, vz);
    vel = (floatsqroot(((vx*vx)+(vy*vy))+(vz*vz)) * 181.5);
    return vel;
}
stock IsPlayerRunning(playerid)
{
    if (!IsPlayerConnected(playerid)) return 0;
    if (IsPlayerInAnyVehicle(playerid)) return 0;
    new keys, updown, leftright;
    GetPlayerKeys(playerid, keys, updown, leftright);
    if (keys & KEY_SPRINT) return 1;
    return 0;
}

stock IsPlayerAiming(playerid)
{
    new anim = GetPlayerAnimationIndex(playerid);
    if (((anim >= 1160) && (anim <= 1163)) || (anim == 1167) || (anim == 1365) ||
    (anim == 1643) || (anim == 1453) || (anim == 220)) return 1;
    return 0;
}
stock GetVehicleMaxSeats(vehicleid)
{
	new deger;

	if(GetVehicleModel(vehicleid) == 599)
		deger = 4;

	else
	{
	    static const g_arrMaxSeats[] = {
			4, 2, 2, 2, 4, 4, 1, 2, 2, 4, 2, 2, 2, 4, 2, 2, 4, 2, 4, 2, 4, 4, 2, 2, 2, 1, 4, 4, 4, 2,
			1, 7, 1, 2, 2, 0, 2, 7, 4, 2, 4, 1, 2, 2, 2, 4, 1, 2, 1, 0, 0, 2, 1, 1, 1, 2, 2, 2, 4, 4,
			2, 2, 2, 2, 1, 1, 4, 4, 2, 2, 4, 2, 1, 1, 2, 2, 1, 2, 2, 4, 2, 1, 4, 3, 1, 1, 1, 4, 2, 2,
			4, 2, 4, 1, 2, 2, 2, 4, 4, 2, 2, 1, 2, 2, 2, 2, 2, 4, 2, 1, 1, 2, 1, 1, 2, 2, 4, 2, 2, 1,
			1, 2, 2, 2, 2, 2, 2, 2, 2, 4, 1, 1, 1, 2, 2, 2, 2, 7, 7, 1, 4, 2, 2, 2, 2, 2, 4, 4, 2, 2,
			4, 4, 2, 1, 2, 2, 2, 2, 2, 2, 4, 4, 2, 2, 1, 2, 4, 4, 1, 0, 0, 1, 1, 2, 1, 2, 2, 1, 2, 4,
			4, 2, 4, 1, 0, 4, 2, 2, 2, 2, 0, 0, 7, 2, 2, 1, 4, 4, 4, 2, 2, 2, 2, 2, 4, 2, 0, 0, 0, 4,
			0, 0
		};
		new
		    model = GetVehicleModel(vehicleid);

		if (400 <= model <= 611)
		    deger = g_arrMaxSeats[model - 400];
	}

	return deger;
}
stock GetAvailableSeat(vehicleid, start = 1)
{
	new seats = GetVehicleMaxSeats(vehicleid);

	for (new i = start; i < seats; i ++) if (!IsVehicleSeatUsed(vehicleid, i)) {
	    return i;
	}
	return -1;
}
stock IsVehicleSeatUsed(vehicleid, seat)
{
	foreach (new i : Player) if (IsPlayerInVehicle(i, vehicleid) && GetPlayerVehicleSeat(i) == seat) {
	    return 1;
	}
	return 0;
}
stock IsVehicleBike(vehicleid)
{
	new Bike[] = { 509, 481, 510, 462, 448,522, 581, 521, 523, 463, 586, 468, 471 };

	for (new i = 0; i < sizeof(Bike); i++)
    {
        if (GetVehicleModel(vehicleid) == Bike[i]) return 1;
    }
	return 0;
}

stock IsWindowedVehicle(vehicleid)
{
	static const g_aWindowStatus[] = {
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 0, 1, 1,
	    1, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1,
	    1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 1, 0, 0, 0, 0,
	    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
	    1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1,
		1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 1, 1,
		1, 1, 1, 1, 1, 1, 0, 0, 0, 1, 0, 0
	};
	new modelid = GetVehicleModel(vehicleid);

    if (modelid < 400 || modelid > 611)
        return 0;

    return (g_aWindowStatus[modelid - 400]);
}
stock GetVehicleHood(vehicleid, &Float:x, &Float:y, &Float:z)
{
    if (!GetVehicleModel(vehicleid) || vehicleid == INVALID_VEHICLE_ID)
	    return (x = 0.0, y = 0.0, z = 0.0), 0;

	static
	    Float:pos[7]
	;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, pos[0], pos[1], pos[2]);
	GetVehiclePos(vehicleid, pos[3], pos[4], pos[5]);
	GetVehicleZAngle(vehicleid, pos[6]);

	x = pos[3] + (floatsqroot(pos[1] + pos[1]) * floatsin(-pos[6], degrees));
	y = pos[4] + (floatsqroot(pos[1] + pos[1]) * floatcos(-pos[6], degrees));
 	z = pos[5];

	return 1;
}
stock SetHoodStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, status, boot, objective);
}
stock GetLightStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (lights != 1)
		return 0;

	return 1;
}
stock SetLightStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, engine, status, alarm, doors, bonnet, boot, objective);
}
stock SetEngineStatus(vehicleid, status)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	return SetVehicleParamsEx(vehicleid, status, lights, alarm, doors, bonnet, boot, objective);
}
stock GetElapsedTime(time, &hours, &minutes, &seconds)
{
	hours = 0;
	minutes = 0;
	seconds = 0;

	if (time >= 3600)
	{
		hours = (time / 3600);
		time -= (hours * 3600);
	}
	while (time >= 60)
	{
	    minutes++;
	    time -= 60;
	}
	return (seconds = time);
}
stock GetEngineStatus(vehicleid)
{
	static
	    engine,
	    lights,
	    alarm,
	    doors,
	    bonnet,
	    boot,
	    objective;

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);

	if (engine != 1)
		return 0;

	return 1;
}
stock SQLName(id, underscore = 1)
{
	new owner[MAX_PLAYER_NAME], query[512];
	mysql_format(pizza, query, sizeof(query), "SELECT `Isim` FROM `oyuncular` WHERE `ID` = '%d'", id);
 	new Cache:sqlname = mysql_query(pizza, query);
	new rows;
	cache_get_row_count(rows);
	if (rows) cache_get_value_name(0, "Isim", owner, 24);
	cache_delete(sqlname);
	if (!underscore) {
	    for (new i = 0, len = strlen(owner); i < len; i ++) {
	        if (owner[i] == '_') owner[i] = ' ';
		}
	}
	return owner;
}
stock IsimdenSQLID(isim[])
{
	new query[512], sqlID;
	mysql_format(pizza, query, sizeof(query), "SELECT `ID` FROM `oyuncular` WHERE `Isim` = '%s'", isim);
	new Cache:isimarat = mysql_query(pizza, query);
	if(cache_num_rows())
	{
	    cache_get_value_name_int(0, "ID", sqlID);
		return sqlID;
	}
	cache_delete(isimarat);
	return -1;
}
stock RandomEx(min, max)
	return random(max - min) + min;

stock IsValidVehicleModel(model)
{
	if (model >= 400 && model <= 611)
	{
		return true;
	}
	return false;
}
stock FormatNumber(number, prefix[] = "$")
{
	static
		value[32],
		length;

	format(value, sizeof(value), "%d", (number < 0) ? (-number) : (number));

	if ((length = strlen(value)) > 3)
	{
		for (new i = length, l = 0; --i >= 0; l ++) {
		    if ((l > 0) && (l % 3 == 0)) strins(value, ",", i + 1);
		}
	}
	if (prefix[0] != 0)
	    strins(value, prefix, 0);

	if (number < 0)
		strins(value, "-", 0);

	return value;
}
stock OyundaDegil(playerid)
{
	if (!IsPlayerConnected(playerid) || GetPVarInt(playerid, "Logged") == 0)
	{
	    return 0;
	}
	return 1;
}
stock SendClientMessageToAllEx(color, const text[], {Float, _}:...)
{
    static
        args,
        str[512];

    /*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
    */
    if ((args = numargs()) == 2)
    {
        SendClientMessageToAll(color, text);
    }
    else
    {
        while (--args >= 2)
        {
            #emit LCTRL 5
            #emit LOAD.alt args
            #emit SHL.C.alt 2
            #emit ADD.C 12
            #emit ADD
            #emit LOAD.I
            #emit PUSH.pri
        }
        #emit PUSH.S text
        #emit PUSH.C 144
        #emit PUSH.C str
        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri
        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        SendClientMessageToAll(color, str);

        #emit RETN
    }
    return 1;
}


stock SendClientMessageEx(playerid, color, const text[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 3)
	{
	    SendClientMessage(playerid, color, text);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S text
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4

		SendClientMessage(playerid, color, str);

		#emit RETN
	}
	return 1;
}
stock SendPizzaMessage(color, const str[], {Float,_}:...)
{
	static
	    args,
	    start,
	    end,
	    string[144],
		ystr[170]
	;
	#emit LOAD.S.pri 8
	#emit STOR.pri args

	if (args > 8)
	{
		#emit ADDR.pri str
		#emit STOR.pri start

	    for (end = start + (args - 8); end > start; end -= 4)
		{
	        #emit LREF.pri end
	        #emit PUSH.pri
		}
		#emit PUSH.S str
		#emit PUSH.C 144
		#emit PUSH.C string

		#emit LOAD.S.pri 8
		#emit ADD.C 4
		#emit PUSH.pri

		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		format(ystr, 170, "{cccccc}PIZZA: {ffffff}%s", string);
        foreach (new i : Player)
		{
			if (PlayerData[i][pMeslek] != 6 && PlayerData[i][pMeslek] != -1) {
  				SendClientMessage(i, color, ystr);
			}
		}
		return 1;
	}
	format(ystr, 170, "{cccccc}PIZZA: {ffffff}%s", str);
 	foreach (new i : Player)
	{
		if (PlayerData[i][pMeslek] != 6 && PlayerData[i][pMeslek] != -1) {
			SendClientMessage(i, color, ystr);
		}
	}
	return 1;
}

stock SendAdminAlert(const msgg[], {Float, _}:...)
{
	static
	    args,
	    str[144];

	/*
     *  Custom function that uses #emit to format variables into a string.
     *  This code is very fragile; touching any code here will cause crashing!
	*/
	if ((args = numargs()) == 3)
	{
	    foreach(new playerid : Player) if(PlayerData[playerid][pAdmin] != 0)
	    	SendClientMessage(playerid, COLOR_LIGHTRED, msgg);
	}
	else
	{
		while (--args >= 3)
		{
			#emit LCTRL 5
			#emit LOAD.alt args
			#emit SHL.C.alt 2
			#emit ADD.C 12
			#emit ADD
			#emit LOAD.I
			#emit PUSH.pri
		}
		#emit PUSH.S msgg
		#emit PUSH.C 144
		#emit PUSH.C str
		#emit PUSH.S 8
		#emit SYSREQ.C format
		#emit LCTRL 5
		#emit SCTRL 4
		
        foreach(new playerid : Player) if(PlayerData[playerid][pAdmin] != 0)
			SendClientMessage(playerid, COLOR_LIGHTRED, str);

		#emit RETN
	}
	return 1;
}
ReturnName(playerid)
{
	static
	    name[MAX_PLAYER_NAME + 1];

	GetPlayerName(playerid, name, sizeof(name));
	return name;
}

stock IsDoorVehicle(vehicleid)
{
	switch (GetVehicleModel(vehicleid)) {
		case 400..424, 426..429, 431..440, 442..445, 451, 455, 456, 458, 459, 466, 467, 470, 474, 475:
		    return 1;

		case 477..480, 482, 483, 486, 489, 490..492, 494..496, 498..500, 502..508, 514..518, 524..529, 533..536:
		    return 1;

		case 540..547, 549..552, 554..562, 565..568, 573, 575, 576, 578..580, 582, 585, 587..589, 596..605, 609:
			return 1;
	}
	return 0;
}
stock GetNearestVehicle(playerid)
{
	static
	    Float:fX,
	    Float:fY,
	    Float:fZ;

	for (new i = 0; i != MAX_VEHICLES; i ++) if (IsValidVehicle(i) && GetVehiclePos(i, fX, fY, fZ))
	{
	    if (IsPlayerInRangeOfPoint(playerid, 3.5, fX, fY, fZ)) return i;
	}
	return INVALID_VEHICLE_ID;
}
stock GetVehicleModelByName(const name[])
{
	if (IsNumeric(name) && (strval(name) >= 400 && strval(name) <= 611))
	    return strval(name);

	for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
	{
	    if (strfind(g_arrVehicleNames[i], name, true) != -1)
	    {
	        return i + 400;
		}
	}
	return 0;
}
stock GetPlayerSQLIDWithName(name[])
{
	new query[150];
	format(query,sizeof(query), "SELECT `ID` FROM `oyuncular` WHERE `Isim` = '%s'",name);
	new Cache:Radless = mysql_query(pizza, query);
	new rows;
	cache_get_row_count(rows);
	if (rows)
	{
	    new id;
	    cache_get_value_name_int(0, "ID",id);
	    cache_delete(Radless);
	    return id;
	}
	cache_delete(Radless);
	return -1;
}
stock GetPlayerIDWithSQLID(sqlid)
{
	foreach (new i:Player)
	{
	    if (PlayerData[i][pID] == sqlid)
	    {
	        return i;
	    }
	}
	return -1;
}
stock GetMoveDirectionFromKeys(ud, lr)
{
	new direction = 0;

    if (lr < 0)
	{
		if (ud < 0) 		direction = MOVE_FORWARD_LEFT; 	// Up & Left key pressed
		else if (ud > 0) direction = MOVE_BACK_LEFT; 	// Back & Left key pressed
		else            direction = MOVE_LEFT;          // Left key pressed
	}
	else if (lr > 0) 	// Right pressed
	{
		if (ud < 0)      direction = MOVE_FORWARD_RIGHT;  // Up & Right key pressed
		else if (ud > 0) direction = MOVE_BACK_RIGHT;     // Back & Right key pressed
		else			direction = MOVE_RIGHT;          // Right key pressed
	}
	else if (ud < 0) 	direction = MOVE_FORWARD; 	// Up key pressed
	else if (ud > 0) 	direction = MOVE_BACK;		// Down key pressed

	return direction;
}
stock FlipVehicle(vehicleid)
{
    new
        Float:fAngle;

    GetVehicleZAngle(vehicleid, fAngle);

    SetVehicleZAngle(vehicleid, fAngle);
    SetVehicleVelocity(vehicleid, 0.0, 0.0, 0.0);
    return 1;
}
//----------------------------------------------------------


//----------------------------------------------------------

public OnPlayerCommandText(playerid, cmdtext[])
{

	return 0;
}


//----------------------------------------------------------

public OnPlayerUpdate(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) return 1;

	return 1;
}

//----------------------------------------------------------
