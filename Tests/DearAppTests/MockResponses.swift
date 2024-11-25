import Foundation

enum Mock {
  static func searchResultJson(results: String) -> String {
    """
    {
      "resultCount": 1,
      "results": [
        \(results)
      ]
    }
    """
  }

  static let developerJson: String = """
  {
    "wrapperType": "artist",
    "artistType": "Software Artist",
    "artistName": "Nicolas Vergoz",
    "artistLinkUrl": "https://apps.apple.com/us/developer/nicolas-vergoz/id1533526465?uo=4",
    "artistId": 1533526465
  }
  """

  static let appJson: String = """
    {
      "isGameCenterEnabled": false,
      "supportedDevices": [
          "iPhone5s-iPhone5s"
      ],
      "features": [
          "iosUniversal"
      ],
      "advisories": [],
      "kind": "software",
      "screenshotUrls": [],
      "ipadScreenshotUrls": [],
      "appletvScreenshotUrls": [],
      "artworkUrl512": "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/ee/7d/b5/ee7db520-38a9-38f6-4587-45eebd48509f/AppIcon-0-0-1x_U007epad-0-1-85-220.png/512x512bb.jpg",
      "artistViewUrl": "https://apps.apple.com/fr/developer/nicolas-vergoz/id1533526465?uo=4",
      "artworkUrl60": "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/ee/7d/b5/ee7db520-38a9-38f6-4587-45eebd48509f/AppIcon-0-0-1x_U007epad-0-1-85-220.png/60x60bb.jpg",
      "artworkUrl100": "https://is1-ssl.mzstatic.com/image/thumb/Purple211/v4/ee/7d/b5/ee7db520-38a9-38f6-4587-45eebd48509f/AppIcon-0-0-1x_U007epad-0-1-85-220.png/100x100bb.jpg",
      "price": 0.00,
      "primaryGenreName": "Utilities",
      "primaryGenreId": 6002,
      "trackId": 1533526463,
      "trackName": "Pour100% Calculatrice",
      "genreIds": [
          "6002",
          "6007"
      ],
      "releaseNotes": "Application refaite complètement de zéro ! Découvrez une nouvelle interface époustouflante, de belles animations et une expérience plus fluide et intuitive. Essayez-la !\nEt quelques ajustement UX entre la 2.0.0 et la 2.0.1",
      "bundleId": "com.vrgz.per100",
      "releaseDate": "2020-10-18T07:00:00Z",
      "isVppDeviceBasedLicensingEnabled": true,
      "sellerName": "Nicolas Vergoz",
      "currentVersionReleaseDate": "2024-11-20T13:36:18Z",
      "version": "2.0.1",
      "wrapperType": "software",
      "currency": "EUR",
      "description": "Découvrez la façon la plus simple et élégante de calculer vos pourcentages. Que ce soit pour une augmentation, une diminution ou une variation, cette application rend cela facile. Son design épuré, ses animations fluides et son interface intuitive assurent une expérience utilisateur agréable !",
      "languageCodesISO2A": [
          "EN",
          "FR",
          "ES"
      ],
      "fileSizeBytes": "2650112",
      "formattedPrice": "Gratuit",
      "userRatingCountForCurrentVersion": 6,
      "trackContentRating": "4+",
      "averageUserRatingForCurrentVersion": 4.833330000000000126192389870993793010711669921875,
      "trackCensoredName": "Pour100% Calculatrice",
      "trackViewUrl": "https://apps.apple.com/fr/app/pour100-calculatrice/id1533526463?uo=4",
      "contentAdvisoryRating": "4+",
      "averageUserRating": 4.833330000000000126192389870993793010711669921875,
      "minimumOsVersion": "17.0",
      "artistId": 1533526465,
      "artistName": "Nicolas Vergoz",
      "genres": [
          "Utilitaires",
          "Productivité"
      ],
      "userRatingCount": 6
    }
    """
}
