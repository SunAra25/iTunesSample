//
//  SearchResultResponse.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import Foundation

struct SearchResultResponse: Codable {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let screenshotUrls: [String]
    let artworkUrl512: String
    let artistViewURL: String
    let currentVersionReleaseDate: String
    let description: String
    let artistName: String
    let genres: [String]
    let price: Int
    let releaseDate: String
    let releaseNotes: String
    let primaryGenreName: String
    let sellerName: String
    let trackName: String
    let currency: String
    let averageUserRatingForCurrentVersion, averageUserRating: Double
    let trackCensoredName: String
    let fileSizeBytes: String
    let sellerURL: String?
    let formattedPrice: String
    let contentAdvisoryRating: String
    let userRatingCountForCurrentVersion, userRatingCount: Int
    let trackViewURL: String
    let trackContentRating: String
    let minimumOSVersion, version: String

    enum CodingKeys: String, CodingKey {
        case screenshotUrls, artworkUrl512
        case artistViewURL = "artistViewUrl"
        case currentVersionReleaseDate, description
        case artistName, genres, price, releaseDate
        case releaseNotes, primaryGenreName
        case sellerName
        case trackName, currency, averageUserRatingForCurrentVersion, averageUserRating, trackCensoredName, fileSizeBytes
        case sellerURL = "sellerUrl"
        case formattedPrice, contentAdvisoryRating, userRatingCountForCurrentVersion
        case trackViewURL = "trackViewUrl"
        case trackContentRating
        case minimumOSVersion = "minimumOsVersion"
        case version, userRatingCount
    }
}
