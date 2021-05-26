//
//  Leaderboard.swift
//  RocketShip
//
//  Created by Josh Manik on 25/05/2021.
//

import SwiftUI

import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
