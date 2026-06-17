{ ... }: {
  xdg = {
    mime = {
      defaultApplications = {
        #Lists of mime types:
        #Common types as defined by mozilla:
        #https://developer.mozilla.org/en-US/docs/Web/HTTP/Guides/MIME_types/Common_types
        #Contains a database of many mime types:
        #https://mimetype.io/all-types
        #Offical IANA types:
        #https://www.iana.org/assignments/media-types/media-types.xhtml
        "application/pdf" = "google-chrome.desktop";
        "inode/directory" = "thunar.desktop";
        "text/x-patch" = "kate.desktop";
      };
    };
  };
}
