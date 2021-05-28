//
//  Leaderboard.swift
//  RocketShip
//
//  Created by Josh Manik on 25/05/2021.
//

import SwiftUI

import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate, UITableViewDelegate, UITableViewDataSource  {
    
    var s_ores = [Int64()]
    var names = [String()]
    var ranks = [Int()]
    

    @IBOutlet weak var tableView: UITableView!
    @IBAction func showleaders(_ sender: Any) {
        showLeader()
    }
    
    @IBAction func reload(_ sender: Any) {
        tableView.reloadData()
    }
        
        
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return s_ores.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LeaderboardCell", for: indexPath) as!
            LeaderboardCell
        let score = s_ores[indexPath.row]
        let name = names[indexPath.row]
        let rank = ranks[indexPath.row]
        
        cell.name.text = name
        cell.rank.text = String(rank)
        cell.score.text = String(score)
        
        return cell
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "LeaderboardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "LeaderboardCell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        authPlayer()
        
        load_leaderboards()
        showLeader()
    }
    
    func load_leaderboards(){
        let Scores : GKLeaderboard = GKLeaderboard()
        Scores.timeScope = .allTime
        Scores.identifier = "IR_Scores"
        Scores.loadScores { scores, error in
            guard let scores = scores else {return}
            self.s_ores.removeAll()
            self.ranks.removeAll()
            self.names.removeAll()
            for score in scores{
                let name = score.player.displayName
                let scored = score.value
                let rank = score.rank
                self.s_ores.append(scored)
                self.ranks.append(rank)
                self.names.append(name)
                
                
            }
    }
    }
        

    
    func showLeader(){
        
        // This code gets the active view controller so we can post the game center leaderboard
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
                let gcvc = GKGameCenterViewController()
                gcvc.gameCenterDelegate = self
                topController.present(gcvc, animated: true, completion: nil)
            }
        }

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
