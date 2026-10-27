{ username, ... }: {
  lib.mkMerge = {
    users.users.${username} = {
      hashedPasswordFile = "/home/${username}/private/hashedpassword.txt";
    };
  };
}
