with import <nixpkgs> {};

mkShell {
  inputsFrom = [ (import ./default.nix {}) ];
  buildInputs = with rPackages; [
    roxygen2
    usethis
  ];

  shellHook = ''
    export MANPATH="${R}/share/man''${MANPATH:+:}$MANPATH"
  '';
}
