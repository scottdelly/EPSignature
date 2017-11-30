//
//  ViewController.swift
//  SDSignatureExample
//
//

import UIKit
import SDSignature

class ViewController: UIViewController {
    @IBOutlet weak var imgWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgViewSignature: UIImageView!

    @IBAction func onTouchSignatureButton(sender: AnyObject) {
        let signatureVC = SignatureVC(signatureDelegate: self)
        signatureVC.subtitleText = "I agree to the terms and conditions"
        signatureVC.title = "John Doe"
        let nav = UINavigationController(rootViewController: signatureVC)
        self.present(nav, animated: true, completion: nil)
    }
}

//MARK: - SignatureVCDelegate
extension ViewController: SignatureVCDelegate {
    func signatureVCCancelled(_ vc: SignatureVC) {
        print("User canceled")
        self.dismiss(animated: true) {
            //
        }
    }
    
    
    func signature(vc: SignatureVC, signed image: UIImage, in rect: CGRect) {
        print(image)
        imgViewSignature.image = image
        imgWidthConstraint.constant = rect.size.width
        imgHeightConstraint.constant = rect.size.height
        self.dismiss(animated: true) {
            //
        }
    }
}

