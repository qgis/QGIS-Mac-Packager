# QGIS Mac Packager

Set of scripts to create MacOS standalone QGIS package (dmg)

To know when we release, see [QGIS release schedule](https://www.qgis.org/en/site/getinvolved/development/roadmap.html#release-schedule)

# How to report issues 

- Add link to the installed package
- Add crash report if QGIS crashed
- State MacOS version (e.g. 10.14.1)
- Run `open /Applications/QGISxy.app` from Terminal and add the output
- Append any messages from QGIS message log or python warnings log if present

# Debugging Tips
- [gatekeeper](https://stackoverflow.com/a/29221163/2838364): `codesign --verbose --deep-verify /Applications/QGIS.app/` 
- loaded dylibs: `ps -A | grep -i qgis; vmmap <pid>`
- signature: `codesign -d -vvvv <file>` 

# Server Setup 

- Get Mojave server
- Get Apple Development Program for your Apple ID
- Login to the server (have static IP)
- Change default password to some secure one
- Install XCode from App Store 
- Go to Apple Developer Download page -> More and command line tools. Install both
- Sign out from the apple developer page and app store
- Open XCode and accept license
- install homebrew and QGIS deps by running `install_brew.bash`
- Download MrSID SDK [referenced in](https://github.com/OSGeo/homebrew-osgeo4mac/blob/master/Formula/osgeo-mrsid-sdk.rb) and place it in the folder `$HOME/Library/Caches/Homebrew`
- Download erdas-ecw-jp2 [referenced in](https://github.com/OSGeo/homebrew-osgeo4mac/blob/master/Formula/ecwjp2-sdk.rb). Open dmg, open pkg and install to default location (Desktop Read-Only Free type)
- install homebrew packages by `install_brew_packages.bash`
- get proj datumgrids by running `scripts/fetch_proj-datumgrid.bash`
- Update `~/.bash_profile` from `scrips/bash_profile`
- now clone this repository
- to upload to Dropbox
    1. Create App with a folder to upload a files, get a token
    2. Create File ~/Projects/dropbox_token.txt and paste the token inside
- copy `run_cronjob` one folder above
- to Code Signing 
    - You need application certificate from https://developer.apple.com/account
    - Generate production/development signing identify
    - Get cer file and scp to the server
    - Double click on cer file and install it on the server
    - On Machine where you created request, export private key and copy and install on server too.
    - `security find-identity -v` to find existing identities 
    - create `sing_identity.txt` with the ID of your identity
    - allow to use it in cronjob (https://stackoverflow.com/a/20324331/2838364)
    - create symbolic link to keychain with the imported identity

- so your folders structure is
```
  dropbox_token.txt
  sign_identity.txt
  qgis.keychain.db --> ~/Library/Keychains/login.keychain-db
  run_cronjob.bash
  qgis-mac-packager/
  proj-datumgrid/
  builds/
  logs/
```
- Run `run_*.bash` to build nightly/ltr/pr releases
- Nightly releases should be set as launchd once per day (use tabs!)
``` 
cp scripts/org.qgis.build.plist ~/Library/LaunchAgents/
plutil ~/Library/LaunchAgents/org.qgis.build.plist 
launchctl load ~/Library/LaunchAgents/org.qgis.build.plist
``` 

# Server Update

- remove all build folders 
- remove homebrew (`/usr/local/*`)
- reinstall homebrew packages
- update version & run `scripts/fetch_proj-datumgrid.bash`
- update docs/README.md with new set of used libs

# How to release new versions

- remove all build folders 
- update TAG in `scripts/run_ltr.bash`, `scripts/run_pr.bash`
- wait till next nightly build to build the package
- check `docs/README.md` if there are some references to old/new version to update