{ ... }: {
  xdg = {
    desktopEntries = {
      steam = {
        name = "Steam";
        comment = "Application for managing and playing games on Steam";
        genericName = "Application";
        exec = "steam -forcedesktopscaling 1.5 %U";
        icon = "steam";
        terminal = false;
        categories = [
          "Network"
          "FileTransfer"
          "Game"
        ];
        mimeType = [
          "x-scheme-handler/steam"
          "x-scheme-handler/steamlink"
        ];
        actions = {
          "Store" = {
            exec = "steam steam://store";
          };
          "Community" = {
            exec = "steam steam://url/SteamIDControlPage";
          };
          "Library" = {
            exec = "steam steam://open/games";
          };
          "Servers" = {
            exec = "steam steam://open/servers";
          };
          "Screenshots" = {
            exec = "steam steam://open/screenshots";
          };
          "News" = {
            exec = "steam steam://open/news";
          };
          "Settings" = {
            exec = "steam steam://open/settings";
          };
          "BigPicture" = {
            exec = "steam steam://open/bigpicture";
          };
          "Friends" = {
            exec = "steam steam://open/friends";
          };
        };
        PrefersNonDefaultGPU = true;
        X-KDE-RunOnDiscreteGpu = true;
      };
    };
  };
}
