{ lib, username, ... }:
{
  lib.mkMerge = {
    users = {
      users.ajhyperbit = {
        hashedPasswordFile = "/home/${username}/private/hashedpassword.txt";
      };
    };
  };
}
