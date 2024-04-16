# Chamasoft Android & iOS App

The Chamasoft Android & iOS app, flavored.

## App variables

`chamasoftDev`, `chamasoftProd`, `eazzyclubDev` and `eazzyclubProd`

## Run in development

`flutter run --flavor {flavorName} --dart-define=flavor={flavorName}`

## Build for production
`flutter build appbundle --flavor {flavorName} --dart-define=flavor={flavorName}`git 

`flutter build apk --flavor {flavorName} --dart-define=flavor={flavorName}`

flutter run --flavor chamasoftProd --dart-define=flavor=chamasoftProd --no-sound-null-safety
flutter build apk --flavor chamasoftProd --dart-define=flavor=chamasoftProd --no-sound-null-safety
flutter build appbundle --flavor chamasoftProd --dart-define=flavor=chamasoftProd --no-sound-null-safety