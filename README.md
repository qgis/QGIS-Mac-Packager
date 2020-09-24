[![PR Status](https://qgis.org/downloads/macos/qgis-macos-pr.latest.png?raw=true)](https://qgis.org/downloads/macos/qgis-macos-pr.latest.log)

[![LTR Status](https://qgis.org/downloads/macos/qgis-macos-ltr.latest.png?raw=true)](https://qgis.org/downloads/macos/qgis-macos-ltr.latest.log)

[![NIGHTLY Status](https://qgis.org/downloads/macos/qgis-macos-nightly.latest.png?raw=true)](https://qgis.org/downloads/macos/qgis-macos-nightly.latest.log)

# Latest Passed Builds

| PR | LTR | Nightly |
|:---:|:-----:|:--------:|:--------:|
| [DMG](https://qgis.org/downloads/macos/qgis-macos-pr.dmg?raw=true) | [DMG](https://qgis.org/downloads/macos/qgis-macos-ltr.dmg?raw=true) | [DMG](https://qgis.org/downloads/macos/qgis-macos-nightly.dmg?raw=true)  |
| [SHA256](https://qgis.org/downloads/macos/qgis-macos-pr.sha256sum?raw=true) | [SHA256](https://qgis.org/downloads/macos/qgis-macos-ltr.sha256sum?raw=true) | [SHA256](https://qgis.org/downloads/macos/qgis-macos-nightly.sha256sum?raw=true) |
| [DEPS](https://qgis.org/downloads/macos/qgis-macos-pr.deps?raw=true) | [DEPS](https://qgis.org/downloads/macos/qgis-macos-ltr.deps?raw=true)| [DEPS](https://qgis.org/downloads/macos/qgis-macos-nightly.deps?raw=true) |

# QGIS Mac Packager

Set of scripts to create MacOS standalone QGIS package (dmg)

To know when we release, see [QGIS release schedule](https://www.qgis.org/en/site/getinvolved/development/roadmap.html#release-schedule)

# NOTE: QGIS LTR builds!

QGIS 3.10 LTR is still build with GDAL2 and homebrew-deps. Documentation can be found in [here](qmp/qmp.md)

# How to report issues 

- Add link to the installed package
- Add crash report if QGIS crashed
- State MacOS version (e.g. 10.14.1)
- Run `open /Applications/QGIS.app` from Terminal and add the output
- Append any messages from QGIS message log or python warnings log if present

# Debugging Tips
- [gatekeeper](https://stackoverflow.com/a/29221163/2838364): `codesign --verbose --deep-verify /Applications/QGIS.app/` 
- loaded dylibs: `ps -A | grep -i qgis; vmmap <pid>`
- signature: `codesign -d -vvvv <file>` 
- accept by gatekeeper: `spctl -a -t exec -vv <path>.dmg`
- signature: `codesign --verify --deep --strict --verbose=2`
- library deps (similar to Windows' Dependency Walker): https://github.com/kwin/macdependency

# Server Setup 

- Get Mojave server (Catalina?)
- Get Apple Development Program for your Apple ID
- Login to the server (have static IP)
- Change default password to some secure one
- Install XCode from App Store 
- Go to Apple Developer Download page -> More and command line tools. Install both
- Sign out from the apple developer page and app store
- Open XCode and accept license
- install homebrew and QGIS deps by running `install_brew.bash`
- Download MrSID SDK [referenced in](https://github.com/OSGeo/homebrew-osgeo4mac/blob/master/Formula/osgeo-mrsid-sdk.rb) and place it in the folder `$HOME/Library/Caches/Homebrew`. Make a symbolic link in `../external/MrSID_DSDK-<ver>-darwin14.universal.clang60`
- Download erdas-ecw-jp2 [referenced in](https://github.com/OSGeo/homebrew-osgeo4mac/blob/master/Formula/osgeo-ecwjp2-sdk.rb). Open dmg, open pkg and install to default location (Desktop Read-Only Free type). Make a symbolic link in `../external/ERDASEcwJpeg2000SDK<ver>`
- install homebrew packages by `install_brew_dev_packages.bash`
- get proj datumgrids by running `scripts/fetch_proj-datumgrid.bash`
- Update `~/.bash_profile` from `scrips/bash_profile`
- now clone this repository
- for upload, add you ssh keys to `qgis/ssh/` and secure them
- copy `run_cronjob` one folder above
- to Code Signing (you need Apple certificate to be "Indentified developer")
    - You need application certificate from https://developer.apple.com/account
    - Generate production/development signing identify
    - Get cer file and scp to the server
    - Double click on cer file and install it on the server
    - On Machine where you created request, export private key and copy and install on server too.
    - install p12 cert to `login` identity
    - `security find-identity -v` to find existing identities 
    - create `sing_identity.txt` with the ID of your identity
    - allow to use it in cronjob (https://stackoverflow.com/a/20324331/2838364)
    - create symbolic link to keychain with the imported identity

- so your folders structure is
```
  sign_identity.txt
  qgis.keychain.db --> ~/Library/Keychains/login.keychain-db
  run_cronjob.bash
  QGIS-Mac-Packager/
  proj-datumgrid/
  external/MrSid.. --> link to SDK
  external/MrSid.. --> link to SDK
  builds/
  logs/
  ssh/
```
- Run `run_pkg.bash` with nightly/ltr/pr to build releases/nightlies (detects the latest version)
- Nightly releases should be set as launchd once per day (use tabs!)
``` 
cp scripts/org.qgis.build.plist ~/Library/LaunchAgents/
plutil ~/Library/LaunchAgents/org.qgis.build.plist 
launchctl load ~/Library/LaunchAgents/org.qgis.build.plist
``` 

## Server Update

- remove all build folders 
- remove homebrew (`/usr/local/*`)
- reinstall homebrew packages
- update version & run `scripts/fetch_proj-datumgrid.bash`
