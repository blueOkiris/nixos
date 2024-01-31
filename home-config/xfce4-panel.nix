# Configure xfce4-panel with home-manager

{ config, lib, pkgs, modulesPath, ... }:

{
    home-manager.users.dylan = {
        home.file.".config/xfce4/panel/launcher-1/17066612571.desktop".source =
            .config/xfce4/panel/launcher-1/17066612571.desktop;
        home.file.".config/xfce4/panel/launcher-2/16812272972.desktop".source =
            .config/xfce4/panel/launcher-2/16812272972.desktop;
        home.file.".config/xfce4/panel/launcher-3/16872964452.desktop".source =
            .config/xfce4/panel/launcher-3/16872964452.desktop;
        home.file.".config/xfce4/panel/launcher-4/16872969311.desktop".source =
            .config/xfce4/panel/launcher-4/16872969311.desktop;
        home.file.".config/xfce4/panel/launcher-5/16812273385.desktop".source =
            .config/xfce4/panel/launcher-5/16812273385.desktop;
        home.file.".config/xfce4/panel/launcher-6/16812273013.desktop".source =
            .config/xfce4/panel/launcher-6/16812273013.desktop;
        home.file.".config/xfce4/panel/battery-13.rc".source =
            .config/xfce4/panel/battery-13.rc;
        home.file.".config/xfce4/panel/datetime-20.rc".source =
            .config/xfce4/panel/datetime-20.rc;
        home.file.".config/xfce4/panel/datetime-22.rc".source =
            .config/xfce4/panel/datetime-22.rc;
        home.file.".config/xfce4/panel/fsguard-14.rc".source =
            .config/xfce4/panel/fsguard-14.rc;
        home.file.".config/xfce4/panel/fsguard-16.rc".source =
            .config/xfce4/panel/fsguard-16.rc;
        home.file.".config/xfce4/panel/fsguard-18.rc".source =
            .config/xfce4/panel/fsguard-18.rc;
        home.file.".config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml".source =
            .config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml;
    };
}

