//
//  DataManager.swift
//  CustomVCTransitions
//
//  Created by Aleksandr Rybachev on 21.06.2022.
//

import Foundation

class DataManager {

    private init() {}

    static let data: [CellData] = [
        .init(image: #imageLiteral(resourceName: "images/1"), title: "Seychelles"),
        .init(image: #imageLiteral(resourceName: "images/2"), title: "Königssee"),
        .init(image: #imageLiteral(resourceName: "images/5"), title: "Zanzibar"),
        .init(image: #imageLiteral(resourceName: "images/6"), title: "Serengeti"),
        .init(image: #imageLiteral(resourceName: "images/3"), title: "Castle"),
        .init(image: #imageLiteral(resourceName: "images/4"), title: "Kyiv"),
        .init(image: #imageLiteral(resourceName: "images/7"), title: "Munich"),
        .init(image: #imageLiteral(resourceName: "images/8"), title: "Lake")
    ]
}
