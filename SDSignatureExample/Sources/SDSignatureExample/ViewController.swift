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
        let signatureVC = EPSignatureViewController(signatureDelegate: self, showsDate: true, showsSaveSignatureOption: true)
        signatureVC.subtitleText = "I agree to the terms and conditions"
        signatureVC.title = "John Doe"
        let nav = UINavigationController(rootViewController: signatureVC)
        present(nav, animated: true, completion: nil)
    }

}

//MARK: - SignatureVCDelegate
extension ViewController: SignatureVCDelegate {
    func epSignature(_: EPSignatureViewController, didCancel error : NSError) {
        print("User canceled")
    }
    
    func epSignature(_: EPSignatureViewController, didSign signatureImage : UIImage, boundingRect: CGRect) {
        print(signatureImage)
        imgViewSignature.image = signatureImage
        imgWidthConstraint.constant = boundingRect.size.width
        imgHeightConstraint.constant = boundingRect.size.height
    }
}
