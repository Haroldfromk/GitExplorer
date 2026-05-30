//
//  WatchConnectivityService.swift
//  GitExplorerWatch Watch App
//
//  Created by Dongik Song on 5/28/26.
//


import WatchConnectivity
import Combine

final class WatchConnectivityService: NSObject, WCSessionDelegate, ObservableObject {
    
    @Published var users: [GithubUser] = []
    private var session = WCSession.default
    
    override init() {
        super.init()
            session.delegate = self
            session.activate()
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {
        if let error = error {
            print(error.localizedDescription)
        } else {
            print("The session has completed activation.")
        }
    }
    
    func session(_ session: WCSession, didReceiveMessageData messageData: Data) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            guard let userData = try? JSONDecoder().decode([GithubUser].self, from: messageData) else { return }
            users = userData
        }
    }
    
    func sendDeleteMessage(_ user: String) {
        guard session.activationState == .activated else { return }
        let message = ["delete": user]
        session.sendMessage(message, replyHandler: nil)
    }
    
    
//    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
//        print("watch received context")
//        guard let data = applicationContext["users"] as? Data else { return }
//        guard let userData = try? JSONDecoder().decode([GithubUser].self, from: data) else { return }
//        DispatchQueue.main.async {
//            self.users = userData
//        }
//    }
}
