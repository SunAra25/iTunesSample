//
//  SearchResultResponse.swift
//  iTunesSample
//
//  Created by 아라 on 8/8/24.
//

import Foundation

struct SearchResultResponse: Codable {
    let results: [SearchResult]
}

struct SearchResult: Codable {
    let wrapperType: WrapperType
    let kind: String
    let artistName: String
    let collectionName: String?
    let trackName: String
    let collectionCensoredName: String?
    let trackCensoredName: String
    let collectionArtistViewURL, collectionViewURL: String?
    let trackViewURL: String
    let previewURL: String?
    let artworkUrl100: String
    let collectionPrice, trackPrice, trackRentalPrice, collectionHDPrice: Int?
    let trackHDPrice, trackHDRentalPrice: Int?
    let releaseDate: String
    let primaryGenreName: String
    let contentAdvisoryRating: String?
    let longDescription, shortDescription: String?
    let feedURL: String?
    let genres: [String]?
    let artistViewURL: String?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case collectionArtistViewURL = "collectionArtistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl100, collectionPrice, trackPrice, trackRentalPrice
        case collectionHDPrice = "collectionHdPrice"
        case trackHDPrice = "trackHdPrice"
        case trackHDRentalPrice = "trackHdRentalPrice"
        case releaseDate, primaryGenreName, contentAdvisoryRating, longDescription, shortDescription
        case feedURL = "feedUrl"
        case genres
        case artistViewURL = "artistViewUrl"
    }
}

enum WrapperType: String, Codable {
    case track
    case collection
    case artist
}
