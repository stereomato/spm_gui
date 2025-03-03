{
	inputs = {
		# testing, https://github.com/NixOS/nixpkgs/issues/260278
		nixpkgs.url = "github:nixos/nixpkgs/";
		flake-utils.url = "github:numtide/flake-utils";
	};
	outputs = { self, nixpkgs, flake-utils, ...  }@inputs:
		flake-utils.lib.eachDefaultSystem (system: 
			let
				# pkgs = nixpkgs.legacyPackages.${system};
				pkgs = import nixpkgs {
					system = system;
					config.android_sdk.accept_license = true;
					config.allowUnfree = true;
				};
				llvm = pkgs.llvmPackages_latest;
				androidComposition =  pkgs.androidenv.composeAndroidPackages {
					platformVersions = [ "34" ];
					buildToolsVersions = [ "30.0.3" ];
					includeEmulator = true;
					includeSystemImages = true;
					includeExtras = [
						"extras;google;gcm"
					];
					extraLicenses = [
					];
					
				};
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
						androidComposition.androidsdk
						jdk17
						
					];
					CHROME_EXECUTABLE = "google-chrome-stable";
					ANDROID_HOME = "${androidComposition.androidsdk}/libexec/android-sdk";
					ANDROID_SDK_ROOT = "${androidComposition.androidsdk}/libexec/android-sdk";
					
				};
			}
		);
}