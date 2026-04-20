#!/usr/bin/env bash
#
# macOS defaults — curated system preferences.
#
# Run manually after a fresh install:
#   bash macos/defaults.sh
#
# Most changes take effect immediately. Some require logout/restart.
# Review before running — every line is intentional.

set -e

# Close System Settings to prevent it from overriding changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true

# Ask for sudo upfront (needed for a handful of settings)
sudo -v

# ─── General UI/UX ──────────────────────────────────────────────────────────

# Sidebar icon size: 1=small, 2=medium, 3=large
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1

# Always show scrollbars (values: WhenScrolling, Automatic, Always)
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"

# Expand save panel by default (no more clicking the disclosure triangle)
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Save to disk, not iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Auto-quit printer app when jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the "Are you sure you want to open this application?" quarantine dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# # Disable the crash reporter dialog
defaults write com.apple.CrashReporter DialogType -string "none"

# # Disable Notification Center and remove the menu bar icon (requires restart)
# # launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist 2>/dev/null

# # Set highlight color (Green)
# defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# # Disable the sound on boot (bong)
# sudo nvram SystemAudioVolume=" "

# # Disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# # Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# # Disable the "reopen windows" checkbox on logout
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
defaults write com.apple.loginwindow LoginwindowLaunchesRelaunchApps -bool false

# Disable Resume system-wide (don't reopen apps after restart)
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool false

# ─── Keyboard & Input ───────────────────────────────────────────────────────

# Disable press-and-hold for keys — enable key repeat instead
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Blazingly fast key repeat (lower = faster)
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10

# Disable all auto-correct annoyances when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# # Set language and text formats (Monday = first day of week)
defaults write NSGlobalDomain AppleFirstWeekday -dict gregorian -int 2

# Enable full keyboard access for all UI controls (Tab through all controls)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable the fn key changing input source (keep fn as fn)
# 0 = do nothing, 1 = change input source, 2 = show emoji picker
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# ─── Accessibility ──────────────────────────────────────────────────────────

# Ctrl+scroll to zoom (useful for demos and presentations)
sudo defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
sudo defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
sudo defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

# # Reduce motion (less fancy transitions, lighter on resources)
# defaults write com.apple.universalaccess reduceMotion -bool true

# # Reduce transparency (slightly better performance, less visual noise)
# defaults write com.apple.universalaccess reduceTransparency -bool true


# ─── Locale ─────────────────────────────────────────────────────────────────

defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_US@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Timezone
sudo ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

# Show language menu on login screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true

# ─── Screen ─────────────────────────────────────────────────────────────────

# Require password immediately after sleep or screen saver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screenshots: save to Desktop as PNG without shadow
defaults write com.apple.screencapture location -string "${HOME}/Desktop"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# # Enable subpixel font rendering on non-Apple LCDs (useful for external monitors)
# # 0 = off, 1 = light, 2 = medium, 3 = strong
# defaults write NSGlobalDomain AppleFontSmoothing -int 1

# # Enable HiDPI display modes (for non-Retina external monitors)
# sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true

# ─── Finder ─────────────────────────────────────────────────────────────────

# Allow quitting Finder via Cmd+Q (hides desktop icons)
defaults write com.apple.finder QuitMenuItem -bool true

# Disable Finder animations
defaults write com.apple.finder DisableAllAnimations -bool true

# New Finder windows open at Desktop
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show status bar, path bar, and full POSIX path in title
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable warning when changing file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Use list view by default (icnv=icon, clmv=column, glyv=gallery, Nlsv=list)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Enable spring loading for directories (instant)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Don't create .DS_Store on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Skip disk image verification (faster mount)
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Auto-open Finder when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true

# Show icons for external drives, servers, and removable media on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Disable warning before emptying Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Show /Volumes folder
sudo chflags nohidden /Volumes

# Expand File Info panes by default
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show the ~/Library folder (hidden by default)
chflags nohidden ~/Library

# Show the /tmp symlink
sudo chflags nohidden /tmp

# Disable the "Are you sure you want to open this application?" dialog for downloaded apps
# (You already have LSQuarantine above -- this targets Finder's Gatekeeper prompt)
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Enable snap-to-grid for icons on desktop and in icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Set icon size on desktop
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 48" ~/Library/Preferences/com.apple.finder.plist

# # Show item info below icons on desktop
# /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# # Set grid spacing for desktop icons
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" ~/Library/Preferences/com.apple.finder.plist

# ─── Dock ───────────────────────────────────────────────────────────────────

# Icon size
defaults write com.apple.dock tilesize -int 36

# Scale effect for minimize (instead of genie)
defaults write com.apple.dock mineffect -string "scale"

# Minimize into application icon
defaults write com.apple.dock minimize-to-application -bool true

# Show indicator lights for open apps
defaults write com.apple.dock show-process-indicators -bool true

# Wipe all default app icons — start with a clean Dock
defaults write com.apple.dock persistent-apps -array

# Only show currently open applications
defaults write com.apple.dock static-only -bool true

# Don't animate opening applications
defaults write com.apple.dock launchanim -bool false

# Speed up Mission Control animation
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don't rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Auto-hide with no delay
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0

# Translucent icons for hidden applications
defaults write com.apple.dock showhidden -bool true

# Don't show recent applications
defaults write com.apple.dock show-recents -bool false

# Hot corners
#  0: no-op          2: Mission Control   3: Application Windows
#  4: Desktop        5: Screen Saver     10: Put Display to Sleep
# 11: Launchpad     12: Notification Center  13: Lock Screen
defaults write com.apple.dock wvous-tl-corner -int 2     # top-left → Mission Control
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 4     # top-right → Desktop
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 5     # bottom-left → Screen Saver
defaults write com.apple.dock wvous-bl-modifier -int 0

# # Set Dock position: left, bottom, or right
defaults write com.apple.dock orientation -string "bottom"

# Group windows by application in Mission Control
defaults write com.apple.dock expose-group-apps -bool true


# ─── Energy ─────────────────────────────────────────────────────────────────

# Enable lid wakeup
sudo pmset -a lidwake 1

# Restart automatically on power loss
sudo pmset -a autorestart 1

# Display sleep: 5 min
sudo pmset -a displaysleep 5

# On battery: sleep after 10 min. On charger: never sleep.
sudo pmset -b sleep 10
sudo pmset -c sleep 0

# # ---- Safari (developer settings) -----------------------------------------------

# # Privacy: don't send search queries to Apple
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# # Show the full URL in the address bar (not just the domain)
# defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# # Set Safari home page to about:blank
# defaults write com.apple.Safari HomePage -string "about:blank"

# # Don't open "safe" files after downloading
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# # # Show the Develop menu and Web Inspector
# # defaults write com.apple.Safari IncludeDevelopMenu -bool true
# # defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
# # defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

# # # Enable the Web Inspector in all web views (context menu)
# # defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# # Disable Safari auto-fill
# defaults write com.apple.Safari AutoFillFromAddressBook -bool false
# defaults write com.apple.Safari AutoFillPasswords -bool true
# defaults write com.apple.Safari AutoFillCreditCardData -bool false
# defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# # Warn about fraudulent websites
# defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# # Block pop-up windows
# defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# # Enable Do Not Track header
# defaults write com.apple.Safari SendDoNotTrackHTTPHeader -bool true

# # Update extensions automatically
# defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# # ---- Terminal.app ---------------------------------------------------------------

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Enable Secure Keyboard Entry (prevents other apps from snooping on keystrokes)
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# # ---- Mail.app ------------------------------------------------------------------

# Copy email addresses as "foo@bar.com" instead of "Foo Bar <foo@bar.com>"
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Disable inline attachment previews (show as icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# # ---- Spotlight ------------------------------------------------------------------

# Disable Spotlight indexing for mounted volumes
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes" 2>/dev/null || true

# Change indexing order and disable some search results
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 0;"name" = "FONTS";}' \
    '{"enabled" = 1;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 1;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 1;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Reload Spotlight to pick up the changes
# killall mds > /dev/null 2>&1


# # ---- App Store ------------------------------------------------------------------

# Enable automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for updates daily instead of weekly
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install system data files and security updates automatically
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# # ---- Bluetooth ------------------------------------------------------------------

# # Increase Bluetooth audio quality (AAC/aptX)
# defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40

# # ---- Trackpad ------------------------------------------------------------------

# Enable tap to click for this user and for the login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Enable three-finger drag
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# Map bottom right corner of trackpad to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Set trackpad/mouse tracking speed (0.0 to 3.0)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 1.5
defaults write NSGlobalDomain com.apple.mouse.scaling -float 1.5

# Enable natural scrolling (set to false if you prefer "traditional")
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

# ─── Time Machine ───────────────────────────────────────────────────────────

# Don't prompt to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# ─── Activity Monitor ───────────────────────────────────────────────────────

# Show main window on launch
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show CPU usage in Dock icon
defaults write com.apple.ActivityMonitor IconType -int 5

# Show all processes, sorted by CPU usage
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# ─── TextEdit ───────────────────────────────────────────────────────────────

# Plain text by default, UTF-8 encoding
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# ─── Messages ───────────────────────────────────────────────────────────────

# Disable automatic emoji substitution (use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes (annoying when sharing code snippets)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# ─── Google Chrome ──────────────────────────────────────────────────────────

# Disable swipe navigation (trackpad and Magic Mouse)
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false

# Use native print dialog
defaults write com.google.Chrome DisablePrintPreview -bool true
defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true

# ─── Photos ─────────────────────────────────────────────────────────────────

# Don't open Photos when a device is plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# ─── Kill affected applications ─────────────────────────────────────────────

for app in "Activity Monitor" "Dock" "Finder" "Google Chrome" \
    "Messages" "Photos" "SystemUIServer"; do
    killall "${app}" &>/dev/null || true
done

echo ""
echo "macOS defaults applied."
echo "Some changes (keyboard repeat, screen saver password) require logout/restart."