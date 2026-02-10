{ stdenv, librsvg, xcursorgen }:

stdenv.mkDerivation {
  pname = "rose-heart-cursor";
  version = "1.0.0";

  src = ./.;

  nativeBuildInputs = [ librsvg xcursorgen ];

  buildPhase = ''
    export out=$out
    bash build.sh
  '';

  installPhase = "true";  # build.sh writes directly to $out
}
