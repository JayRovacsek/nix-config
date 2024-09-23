{ config, ... }:
{
  networking.firewall.allowedUDPPorts = [
    2456
    2457
  ];

  users = {
    groups.valheim = {
      gid = 10105;
      members = [ "valheim" ];
    };
    users.valheim = {
      group = "valheim";
      isSystemUser = true;
      uid = 10105;
    };
  };

  virtualisation = {
    podman = {
      autoPrune = {
        dates = "daily";
        enable = true;
      };
      dockerCompat = true;
      enable = true;
    };

    oci-containers = {
      backend = "podman";
      containers.valheim = {
        environment = {
          SERVER_NAME = "Poopy Bum Bum";
          SERVER_PASS = "birry birry";
          SERVER_PUBLIC = "false";
          RESTART_CRON = "";
          TZ = config.time.timeZone;
          BACKUPS_MAX_AGE = "5";
          BACKUPS_IF_IDLE = "false";
          VALHEIM_PLUS = "true";
          PUID = "${builtins.toString config.users.users.valheim.uid}";
          PGID = "${builtins.toString config.users.groups.valheim.gid}";

          VPCFG_ValheimPlus_enabled = "true";
          VPCFG_ValheimPlus_serverBrowserAdvertisement = "false";

          VPCFG_Beehive_enabled = "true";
          VPCFG_Beehive_autoDeposit = "true";
          VPCFG_Beehive_autoDepositRange = "5";
          VPCFG_Beehive_showDuration = "true";

          VPCFG_Building_enabled = "true";
          VPCFG_Building_alwaysDropResources = "true";
          VPCFG_Building_alwaysDropExcludedResources = "true";
          VPCFG_Building_enableAreaRepair = "true";
          VPCFG_Building_areaRepairRadius = "10";

          VPCFG_Fermenter_enabled = "true";
          VPCFG_Fermenter_autoDeposit = "true";
          VPCFG_Fermenter_autoFuel = "true";
          VPCFG_Fermenter_showDuration = "true";

          VPCFG_FireSource_enabled = "true";
          VPCFG_FireSource_autoFuel = "true";

          VPCFG_Items_enabled = "true";
          VPCFG_Items_noTeleportPrevention = "true";
          VPCFG_Items_itemsFloatInWater = "true";

          VPCFG_Smelter_enabled = "true";
          VPCFG_Smelter_maximumOre = "100";
          VPCFG_Smelter_maximumCoal = "200";
          VPCFG_Smelter_coalUsedPerProduct = "2";
          VPCFG_Smelter_autoDeposit = "true";
          VPCFG_Smelter_autoFuel = "true";

          VPCFG_Furnace_enabled = "true";
          VPCFG_Furnace_maximumOre = "100";
          VPCFG_Furnace_maximumCoal = "200";
          VPCFG_Furnace_autoDeposit = "true";
          VPCFG_Furnace_autoFuel = "true";

          VPCFG_Hud_enabled = "true";
          VPCFG_Hud_showRequiredItems = "true";
          VPCFG_Hud_displayBowAmmoCounts = "2";

          VPCFG_Kiln_enabled = "true";
          VPCFG_Kiln_maximumWood = "250";
          VPCFG_Kiln_dontProcessFineWood = "true";
          VPCFG_Kiln_dontProcessRoundLog = "true";
          VPCFG_Kiln_autoDeposit = "true";
          VPCFG_Kiln_autoFuel = "true";
          VPCFG_Kiln_stopAutoFuelThreshold = "200";

          VPCFG_Map_enabled = "true";
          VPCFG_Map_preventPlayerFromTurningOffPublicPosition = "true";
          VPCFG_Map_shareMapProgression = "true";
          VPCFG_Map_shareAllPins = "true";
          VPCFG_Map_displayCartsAndBoats = "true";

          VPCFG_Player_enabled = "true";
          VPCFG_Player_autoRepair = "true";
          VPCFG_Player_skipIntro = "true";
          VPCFG_Player_cropNotifier = "true";
          VPCFG_Player_reequipItemsAfterSwimming = "true";

          VPCFG_Server_enabled = "true";
          VPCFG_Server_dataRate = "2048";
          VPCFG_Server_maxPlayers = "5";
          VPCFG_Server_serverSyncsConfig = "true";

          VPCFG_Windmill_enabled = "true";
          VPCFG_Windmill_maximumBarley = "200";
          VPCFG_Windmill_autoDeposit = "true";
          VPCFG_Windmill_autoFuel = "true";

          VPCFG_Inventory_enabled = "true";
          VPCFG_Inventory_playerInventoryRows = "5";
          VPCFG_Inventory_woodChestColumns = "6";
          VPCFG_Inventory_woodChestRows = "3";
          VPCFG_Inventory_ironChestColumns = "8";
          VPCFG_Inventory_ironChestRows = "6";
          VPCFG_Inventory_blackmetalChestRows = "6";

          VPCFG_CraftFromChest_enabled = "true";
          VPCFG_CraftFromChest_allowCraftingFromCarts = "true";
          VPCFG_CraftFromChest_allowCraftingFromShips = "true";

          VPCFG_SpinningWheel_enabled = "true";
          VPCFG_SpinningWheel_maximumFlax = "200";
          VPCFG_SpinningWheel_autoDeposit = "true";
          VPCFG_SpinningWheel_autoFuel = "true";

          VPCFG_GameClock_enabled = "true";
          VPCFG_GameClock_useAMPM = "true";

          VPCFG_GameClock_textFontSize = "20";
          VPCFG_GameClock_textTransparencyChannel = "200";

          VPCFG_Chat_enabled = "true";
          VPCFG_Chat_forcedCase = "false";

        };
        extraOptions = [
          "--cap-add=sys_nice"
        ];
        image = "ghcr.io/lloesche/valheim-server";
        ports = [
          "2456-2457:2456-2457/udp"
        ];
        volumes = [
          "/srv/games/servers/2024-valheim-server/config:/config"
          "/srv/games/servers/2024-valheim-server/data:/opt/valheim"
        ];
      };
    };
  };

}
