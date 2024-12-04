//
//  ProfileStatsCache.swift
//  5palas12-iOS
//
//  Created by santiago on 3/12/24.
//

final class ProfileStatsCache {
    static let shared = ProfileStatsCache()
    private init() {}

    var stats: (moneySaved: Double, co2Saved: Double, weightSaved: Double)?
    var treesPlanted: String?

    func clearCache() {
        stats = nil
        treesPlanted = nil
        print("Cache cleared.")
    }
}
