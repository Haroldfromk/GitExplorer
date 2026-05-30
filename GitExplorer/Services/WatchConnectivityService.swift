//
//  WatchConnectivityService.swift
//  GitExplorer
//
//  Created by Dongik Song on 5/28/26.
//


import WatchConnectivity
import SwiftUI

final class WatchConnectivityService: NSObject, WCSessionDelegate {
    
    private var session = WCSession.default

    weak var viewModel: FavoriteViewModel?
    
    override init() {
        super.init()
        if WCSession.isSupported() {
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession inactive")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        self.session.activate()
    }
    
    func sendFavoriteUsers(_ users: [GithubUser]) {
        guard WCSession.default.activationState == .activated else { return }
        guard let data = try? JSONEncoder().encode(users) else {
            return
        }
        self.session.sendMessageData(data, replyHandler: nil)
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let user = message["delete"] as? String else { return }
            viewModel?.removeToFavorite(id: user)
        }
    }
//    func sendFavoriteUsers(_ users: [GithubUser]) {
//        print("send?")
//        guard WCSession.default.activationState == .activated else { return }
//        guard let data = try? JSONEncoder().encode(users) else { return }
//        try? session.updateApplicationContext(["users": data])
//    }
//    
}
