{ nixpkgs ? import <nixpkgs> {} }:

with nixpkgs;

let
  version = "0.0.0.9000";

  depends = with rPackages; [
    rstan
    rstantools
    BH
    Rcpp
    RcppEigen
    StanHeaders
  ];
in

rPackages.buildRPackage {
  name = "rstanNSBe-${version}";

  src = ./.;

  propagatedBuildInputs = depends;
  nativeBuildInputs = depends;

  meta.platforms = R.meta.platforms;
}
