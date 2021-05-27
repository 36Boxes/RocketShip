//
//  Leaderboard.swift
//  RocketShip
//
//  Created by Josh Manik on 25/05/2021.
//

import SwiftUI

import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        authPlayer()
        load_leaderboards()
    }
    
    func load_leaderboards(){
        let Scores : GKLeaderboard = GKLeaderboard()
        Scores.timeScope = .allTime
        Scores.identifier = "IR_Scores"
        Scores.loadScores { scores, error in
            guard let scores = scores else {return}
            
        print(scores)
        
            for score in scores{
                print(score.value)
            }
    }
    }

    
    func showLeaderBoard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        gcvc.gameCenterDelegate = self
        viewController?.present(gcvc, animated: true, completion: nil)
    }
    
    
    func authPlayer(){
        let localPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil {
                
                self.present(view!, animated: true, completion: nil)
                
            }
            else {
                
                print(GKLocalPlayer.local.isAuthenticated)
                
            }
            
            
        }
    }
    
}
