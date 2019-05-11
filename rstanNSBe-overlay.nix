self: super:

{
  rPackages = super.rPackages // {
    rstanNSBe = super.callPackage ./. { nixpkgs = super; };
  };
}

