//
//  UIViewController+Extension.swift
//  game-assignment
//
//  Created by Huzaifa Ali Abbasi on 22/05/2023.
//

import UIKit


//MARK: - Loader
extension UIViewController {
    
    func showloader(){
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor.black
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        
    }
    
    func dismissloader(){
        DispatchQueue.main.async {
            self.dismiss(animated: false, completion: nil)
        }
    }
}
