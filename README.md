## before you run the project

**YOU NEED SSH ACCESS TO BITBUCKET**
This project uses the authentication_repository package from our bitbucket account and to access it
you need an ssh key in your account. Please follow the instructions here to get started https://support.atlassian.com/bitbucket-cloud/docs/set-up-an-ssh-key/

**Run this to change your package name**

`flutter pub run change_app_package_name:main com.new.package.name`

**Run this to add flutter icon**
Icon must be located under `assets/icons/icon.png`

`flutter pub run flutter_launcher_icons:main`

**Flavors for app**
Define the properties within the `env/` directory and then run/build the project like this:
`flutter run --dart-define=ENVIRONMENT=DEV`
`flutter run --dart-define=ENVIRONMENT=STAGING`
`flutter run --dart-define=ENVIRONMENT=PROD`

## Localization

The project has a class called `LocalizationService` that gets the strings from a json file within the assets.

You can add as many languages as the project needs by doing localeCode.json files (e.g es.json).

To use the strings just call `LocalizationService.of(context)!.translate('json_property')` within your widget tree

To add extra locales to the class add them to the `supportedLocales` property.

## App theme

The app's theme is basic and default but you can customize it under `theme/models/app_theme.dart`

