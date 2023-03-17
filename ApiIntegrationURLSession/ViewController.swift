//
//  ViewController.swift
//  ApiIntegrationURLSession
//
//  Created by Sumayya Siddiqui on 17/03/23.
//

import UIKit
import Reachability
import MBProgressHUD

class ViewController: UIViewController {
    
    var reachability : Reachability?
    var taskelement = [TaskElement]()

    @IBOutlet var myImg: UIImageView!
    @IBOutlet var lbl1: UILabel!
    @IBOutlet var lbl2: UILabel!
    @IBOutlet var lbl3: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        oyeLabsApi()
    }


}

extension ViewController {
    func oyeLabsApi(){
        do {
            self.reachability = try Reachability.init()
        } catch {
            print("Unable tp start notifier")
        }
        if ((reachability?.connection) != .unavailable) {
            MBProgressHUD.showAdded(to: self.view, animated: true)
            
            let url = URL(string: APIManager.shared.oyeLabs)!
//            let tokenId = UserDefaults.standard.string(forKey: "token")
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            
            let sessionConfig = URLSessionConfiguration.default
            let session = URLSession(configuration: sessionConfig, delegate: self as? URLSessionDelegate, delegateQueue: nil)
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                
                
                if error == nil && data != nil {
                    
                    let httpResponse = response as? HTTPURLResponse
                    print(httpResponse?.statusCode ?? 0)
                    if httpResponse?.statusCode == 200 {
                        let loginResponse = try? JSONDecoder().decode(TaskElement.self, from: data!)
                        print(loginResponse)
//                        self.lbl1.taskelement.append(taskelement)
                        
                        
                    }
                    
                }
            }
            dataTask.resume()
            
            //        else {
            //            self.SimpleAlert(withTitle: "", message: "Please Check your Internet")
            //        }
            
        }
    }
}
