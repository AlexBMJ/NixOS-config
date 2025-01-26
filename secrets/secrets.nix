let
  BMJ-Desktop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDyMZKyptGPtS/osbdmDrhnn2J08Iiy/i+BrvqvyNBpJ";
  users = [ BMJ-Desktop ];
in
{
  "albmj-password.age".publicKeys = users;
}
