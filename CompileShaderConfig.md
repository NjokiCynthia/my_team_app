Use this steps when generating an application with less junks(slow flames) and Shader Compilation issues.

# Chamasoft Android & iOS App

The Chamasoft Android & iOS app, flavored.

## App variables

`chamasoftDev`, `chamasoftProd`, `eazzyclubDev` and `eazzyclubProd`

## Run in development
`flutter run --flavor {flavorName} --dart-define=flavor={flavorName} --profile --cache-sksl`

## Record Shaders and junks

Play with the app to trigger as many animations as needed; particularly those with compilation jank.

## Write the captured SkSL

Press M at the command line of flutter run to write the captured SkSL shaders into a file named something like flutter_01.sksl.json. For best results, capture SkSL shaders on actual Android and iOS devices separately. 

## Build for production

`flutter build apk --flavor {flavorName} --dart-define=flavor={flavorName} --bundle-sksl-path flutter_01.sksl.json`

`flutter build appbundle  --flavor {flavorName} --dart-define=flavor={flavorName} --bundle-sksl-path flutter_01.sksl.json`

`flutter build ios --flavor {flavorName} --dart-define=flavor={flavorName} --bundle-sksl-path flutter_01.sksl.json`
