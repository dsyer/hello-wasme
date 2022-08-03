with import <nixpkgs> { };
let
  wasme = stdenv.mkDerivation {
    pname = "wasme";
    version = "0.0.33";
    src = fetchurl {
      # nix-prefetch-url this URL to find the hash value
      url =
        "https://github.com/solo-io/wasm/releases/download/v0.0.33/wasme-linux-amd64";
      sha256 = "0bj8ng9hrs8k689vk5blq71a4zcsv6fbmgfqn442bzwp9162ic2f";
    };
    phases = [ "installPhase" ];
    installPhase = ''
      mkdir -p $out/bin
      chmod +x $src && mv $src $out/bin/wasme
    '';
  };

in 
mkShell {

  name = "env";
  buildInputs = [
    figlet nodejs wasme elixir umoci
  ];

  shellHook = ''
    figlet ":wasme:"
  '';

}