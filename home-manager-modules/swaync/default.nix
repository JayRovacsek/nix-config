{ self, ... }:
let
  inherit (self.lib.generators) to-css;
  inherit (self.common.colour-schemes.tomorrow-night-blue-base16)
    base00
    base01
    base02
    base03
    base04
    base05
    base06
    base08
    base09
    base0A
    base0B
    base0D
    ;
in
{
  services.swaync = {
    enable = true;
    style = to-css {
      "*" = {
        all = "unset";
        font-size = "14px";
        font-family = "Hack Nerd Font";
        transition = "200ms";
      };

      "trough highlight" = {
        background = "#${base03}";
      };

      "scale trough" = {
        margin = "0rem 1rem";
        background-color = "#${base04}";
        min-height = "8px";
        min-width = "70px";
      };

      slider = {
        background-color = "#${base00}";
      };

      ".floating-notifications.background .notification-row .notification-background" = {
        box-shadow = "0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #${base03}";
        border-radius = "12.6px";
        margin = "18px";
        background-color = "#${base00}";
        color = "#${base03}";
        padding = 0;
      };

      ".floating-notifications.background .notification-row .notification-background .notification" = {
        padding = "7px";
        border-radius = "12.6px";
      };

      ".floating-notifications.background .notification-row .notification-background .notification.critical" = {
        box-shadow = "inset 0 0 7px 0 #${base03}";
      };

      ".floating-notifications.background .notification-row .notification-background .notification .notification-content" = {
        margin = "7px";
      };

      ".floating-notifications.background .notification-row .notification-background .notification .notification-content .summary" = {
        color = "#${base03}";
      };

      ".floating-notifications.background .notification-row .notification-background .notification .notification-content .time" = {
        color = "#${base04}";
      };

      ".floating-notifications.background .notification-row .notification-background .notification .notification-content .body" = {
        color = "#${base03}";
      };

      ".floating-notifications.background .notification-row .notification-background .notification > *:last-child > *" = {
        min-height = "3.4em";
      };

      ".floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action" = {
        border-radius = "7px";
        color = "#${base03}";
        background-color = "#${base04}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        margin = "7px";
      };

      ".floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:hover" = {
        box-shadow = "inset 0 0 0 1px #${base03}";
        background-color = "#${base04}";
        color = "#${base03}";
      };

      ".floating-notifications.background .notification-row .notification-background .notification > *:last-child > * .notification-action:active" = {
        background-color = "#${base02}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        color = "#${base03}";

      };

      ".floating-notifications.background .notification-row .notification-background .close-button" = {
        margin = "7px";
        padding = "2px";
        border-radius = "6.3px";
        color = "#${base00}";
        background-color = "#${base09}";
      };

      ".floating-notifications.background .notification-row .notification-background .close-button:hover" = {
        background-color = "#${base08}";
        color = "#${base00}";
      };

      ".floating-notifications.background .notification-row .notification-background .close-button:active" = {
        background-color = "#${base09}";
        color = "#${base00}";
      };

      ".control-center" = {
        box-shadow = "0 0 8px 0 rgba(0, 0, 0, 0.8), inset 0 0 0 1px #${base03}";
        border-radius = "12.6px";
        margin = "18px";
        background-color = "#${base00}";
        color = "#${base03}";
        padding = "14px";
      };

      ".control-center .widget-title > label" = {
        color = "#${base03}";
        font-size = "1.3em";
      };

      ".control-center .widget-title button" = {
        border-radius = "7px";
        color = "#${base05}";
        background-color = "#${base00}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        padding = "8px";
      };

      ".control-center .widget-title button:hover" = {
        background-color = "#${base01}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        color = "#${base05}";
      };

      ".control-center .widget-title button:active" = {
        background-color = "#${base02}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        color = "#${base00}";
      };

      ".control-center .notification-row .notification-background" = {
        border-radius = "7px";
        color = "#${base05}";
        background-color = "#${base00}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        margin-top = "14px";
      };

      ".control-center .notification-row .notification-background .notification" = {
        padding = "7px";
        border-radius = "7px";
      };

      ".control-center .notification-row .notification-background .notification.critical" = {
        box-shadow = "inset 0 0 7px 0 #${base09}";
      };

      ".control-center .notification-row .notification-background .notification .notification-content" = {
        margin = "7px";
      };

      ".control-center .notification-row .notification-background .notification .notification-content .summary" = {
        color = "#${base03}";
      };

      ".control-center .notification-row .notification-background .notification .notification-content .time" = {
        color = "#${base04}";
      };

      ".control-center .notification-row .notification-background .notification .notification-content .body" = {
        color = "#${base03}";
      };

      ".control-center .notification-row .notification-background .notification > *:last-child > *" = {
        min-height = "3.4em";
      };

      ".control-center .notification-row .notification-background .notification > *:last-child > * .notification-action" = {
        border-radius = "7px";
        color = "#${base03}";
        background-color = "#${base01}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        margin = "7px";
      };

      ".control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:hover" = {
        box-shadow = "inset 0 0 0 1px #${base03}";
        background-color = "#${base04}";
        color = "#${base03}";
      };

      ".control-center .notification-row .notification-background .notification > *:last-child > * .notification-action:active" = {
        box-shadow = "inset 0 0 0 1px #${base03}";
        background-color = "#${base02}";
        color = "#${base03}";
      };

      ".control-center .notification-row .notification-background .close-button" = {
        margin = "7px";
        padding = "2px";
        border-radius = "6.3px";
        color = "#${base00}";
        background-color = "#${base08}";
      };

      ".close-button" = {
        border-radius = "6.3px";
      };

      ".control-center .notification-row .notification-background .close-button:hover" = {
        background-color = "#${base09}";
        color = "#${base00}";
      };

      ".control-center .notification-row .notification-background .close-button:active" = {
        background-color = "#${base09}";
        color = "#${base00}";
      };

      ".control-center .notification-row .notification-background:hover" = {
        background-color = "#${base06}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        color = "#${base03}";
      };

      ".control-center .notification-row .notification-background:active" = {
        background-color = "#${base02}";
        box-shadow = "inset 0 0 0 1px #${base03}";
        color = "#${base03}";
      };

      ".notification.critical progress" = {
        background-color = "#${base09}";
      };

      ".notification.low progress, .notification.normal progress" = {
        background-color = "#${base00}";
      };

      ".control-center-dnd" = {
        margin-top = "5px";
        border-radius = "8px";
        background = "#${base04}";
        border = "1px solid #${base00}";
        box-shadow = "none";
      };

      ".control-center-dnd:checked" = {
        background = "#${base04}";
      };

      ".control-center-dnd slider" = {
        background = "#${base00}";
        border-radius = "8px";
      };

      ".widget-dnd" = {
        margin = "0px";
        font-size = "1.1rem";
      };

      ".widget-dnd > switch" = {
        font-size = "initial";
        border-radius = "8px";
        background = "#${base0D}";
        border = "1px solid #${base03}";
        box-shadow = "none";
      };

      ".widget-dnd > switch:checked" = {
        background = "#${base0B}";
      };

      ".widget-dnd > switch slider" = {
        background = "#${base00}";
        border-radius = "8px";
        border = "1px solid #${base04}";
      };

      ".widget-mpris .widget-mpris-player" = {
        background = "#${base04}";
        padding = "7px";
      };

      ".widget-mpris .widget-mpris-title" = {
        font-size = "1.2rem";
      };

      ".widget-mpris .widget-mpris-subtitle" = {
        font-size = "0.8rem";
      };

      ".widget-menubar > box > .menu-button-bar > button > label" = {
        font-size = "3rem";
        padding = "0.5rem 2rem";
      };

      ".widget-menubar > box > .menu-button-bar > :last-child" = {
        color = "#${base09}";
      };

      ".power-buttons button:hover, .powermode-buttons button:hover, .screenshot-buttons button:hover" = {
        background = "#${base04}";
      };

      ".control-center .widget-label > label" = {
        color = "#${base03}";
        font-size = "2rem";
      };

      ".widget-buttons-grid" = {
        padding-top = "1rem";
      };

      ".widget-buttons-grid > flowbox > flowboxchild > button label" = {
        font-size = "2.5rem";
      };

      ".widget-volume" = {
        padding-top = "1rem";
      };

      ".widget-volume label" = {
        font-size = "1.5rem";
        color = "#${base02}";
      };

      ".widget-volume trough highlight" = {
        background = "#${base02}";
      };

      ".widget-backlight trough highlight" = {
        background = "#${base0A}";
      };

      ".widget-backlight label" = {
        font-size = "1.5rem";
        color = "#${base0A}";
      };

      ".widget-backlight .KB" = {
        padding-bottom = "1rem";
      };

      ".image" = {
        padding-right = "0.5rem";
      };
    };
  };
}
