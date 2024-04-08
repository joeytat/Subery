//
//  TrackPresets.swift
//  Subery
//
//  Created by yu wang on 2023/12/3.
//

import Foundation

struct TrackPreset: Identifiable, Equatable, CustomStringConvertible {
    let name: String
    let category: Category
    
    var id: String { name }
    var description: String { name }
}

extension TrackPreset {
    enum Category: String, CaseIterable {
        case videoStreaming = "Video Streaming"
        case musicStreaming = "Music Streaming"
        case news = "News"
        case magazines = "Magazines"
        case productivity = "Productivity"
        case cloudStorage = "Cloud Storage"
        case fitness = "Fitness"
        case gaming = "Gaming"
        case education = "Education"
        case socialMedia = "Social Media"
        case dating = "Dating"
        case finance = "Finance"
        case software = "Software"
        case developerTools = "Developer Tools"
        case security = "Security"
        case vpn = "VPN"
        case webHosting = "Web Hosting"
        case ecommerce = "eCommerce"
    }
}

extension TrackPreset {
    static var popularPresets: [TrackPreset] {
        let raw: [String: TrackPreset.Category] = [
            "Netflix": .videoStreaming,
            "Hulu": .videoStreaming,
            "Disney+": .videoStreaming,
            "Spotify": .musicStreaming,
            "Apple Music": .musicStreaming,
            "Tidal": .musicStreaming,
            "New York Times": .news,
            "The Wall Street Journal": .news,
            "The Guardian": .news,
            "National Geographic": .magazines,
            "The Economist": .magazines,
            "Time Magazine": .magazines,
            "Evernote": .productivity,
            "Notion": .productivity,
            "Todoist": .productivity,
            "Dropbox": .cloudStorage,
            "Google Drive": .cloudStorage,
            "Microsoft OneDrive": .cloudStorage,
            "Peloton": .fitness,
            "MyFitnessPal": .fitness,
            "Strava": .fitness,
            "Xbox Game Pass": .gaming,
            "PlayStation Now": .gaming,
            "Nintendo Switch Online": .gaming,
            "Udemy": .education,
            "Coursera": .education,
            "Skillshare": .education,
            "Facebook": .socialMedia,
            "Twitter": .socialMedia,
            "Instagram": .socialMedia,
            "Tinder": .dating,
            "Bumble": .dating,
            "Hinge": .dating,
            "Mint": .finance,
            "QuickBooks": .finance,
            "Personal Capital": .finance,
            "Microsoft 365": .software,
            "Adobe Creative Cloud": .software,
            "AutoCAD": .software,
            "GitHub": .developerTools,
            "GitLab": .developerTools,
            "Bitbucket": .developerTools,
            "Norton": .security,
            "McAfee": .security,
            "Malwarebytes": .security,
            "NordVPN": .vpn,
            "ExpressVPN": .vpn,
            "Surfshark": .vpn,
            "Bluehost": .webHosting,
            "HostGator": .webHosting,
            "SiteGround": .webHosting,
            "Shopify": .ecommerce,
            "BigCommerce": .ecommerce,
            "WooCommerce": .ecommerce
        ]
        return raw.map { TrackPreset(name: $0.key, category: $0.value) }
    }
}
