# music_box

Pickin' with Banjo and Guitar Flutter app

## App icons

`brew install imagemagick` is required

```
flutter pub run flutter_launcher_icons:main # todo replace with magick cmd
magick assets/icon.png -resize 192 web/icons/Icon-192.png
magick assets/icon.png -resize 512 web/icons/Icon-512.png
magick assets/icon.png -resize 16 web/favicon.png
magick assets/icon.png -resize 512 web/icons/Icon-maskable-512.png
magick assets/icon.png -resize 192 web/icons/Icon-maskable-192.png
cp assets/icon.png macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_1024.png
magick assets/icon.png -resize 512 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_512.png
magick assets/icon.png -resize 256 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_256.png
magick assets/icon.png -resize 128 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_128.png
magick assets/icon.png -resize 64 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_64.png
magick assets/icon.png -resize 32 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_32.png
magick assets/icon.png -resize 16 macos/Runner/Assets.xcassets/AppIcon.appiconset/app_icon_16.png
```
