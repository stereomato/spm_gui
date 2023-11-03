{
	inputs = {
		# testing, https://github.com/NixOS/nixpkgs/issues/260278
		nixpkgs.url = "github:nixos/nixpkgs/";
		flake-utils.url = "github:numtide/flake-utils";
	};
	outputs = { self, nixpkgs, flake-utils }:
		flake-utils.lib.eachDefaultSystem (system: 
			let
				pkgs = nixpkgs.legacyPackages.${system};
				llvm = pkgs.llvmPackages_latest;
			in {
				devShell = pkgs.mkShell {
					buildInputs = with pkgs; [
						flutter
						# Didn't use to ask for this but whateva
						cmake
						# Linux deps
						llvm.libstdcxxClang
						llvm.libcxx
						clang-tools
						llvm.lldb
						ninja
						pkg-config
						gtk3
						pcre2
					];
					CHROME_EXECUTABLE = "google-chrome-stable";
				};
			}
		);
}