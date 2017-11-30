//
//  SignatureViewController.swift
//  Pods
//
//  Created by Prabaharan Elangovan on 13/01/16.
//
//

import UIKit

// MARK: - SignatureVCDelegate
public protocol SignatureVCDelegate: class {
    func signatureVCCancelled(_ vc: SignatureVC)
    func signature(vc: SignatureVC, signed image : UIImage, in rect: CGRect)
}

open class SignatureVC: UIViewController {

    // MARK: - IBOutlets
    
    @IBOutlet private weak var switchSaveSignature: UISwitch!
    @IBOutlet private weak var lblSignatureSubtitle: UILabel!
    @IBOutlet private weak var lblDefaultSignature: UILabel!
    @IBOutlet private weak var lblDate: UILabel!
    @IBOutlet private weak var viewMargin: UIView!
    @IBOutlet private weak var lblX: UILabel!
    @IBOutlet public private (set) weak var signatureView: SignatureView!
    
    // MARK: - Public Vars
    
    open var showsDate: Bool = true
    open var showsSaveSignatureOption: Bool = true
    open weak var signatureDelegate: SignatureVCDelegate?
    open var subtitleText = "Sign Here"
    // MARK: - Life cycle methods
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(onTouchCancelButton))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(onTouchDoneButton))
        let clearButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.trash, target: self, action: #selector(onTouchClearButton))
        
        if showsDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle  = DateFormatter.Style.short
            dateFormatter.timeStyle  = DateFormatter.Style.none
            lblDate.text = dateFormatter.string(from: Date())
        } else {
            lblDate.isHidden = true
        }
        
        if showsSaveSignatureOption {
            let actionButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.action, target:   self, action: #selector(onTouchActionButton(_:)))
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton, actionButton]
        } else {
            self.navigationItem.rightBarButtonItems = [doneButton, clearButton]
            lblDefaultSignature.isHidden = true
            switchSaveSignature.isHidden = true
        }
        
        lblSignatureSubtitle.text = subtitleText
        switchSaveSignature.setOn(false, animated: true)
    }

    // MARK: - Initializers
    public init(signatureDelegate: SignatureVCDelegate, showsDate: Bool = true, showsSaveSignatureOption: Bool = false) {
        self.showsDate = showsDate
        self.showsSaveSignatureOption = showsSaveSignatureOption
        self.signatureDelegate = signatureDelegate
        let bundle = Bundle(for: SignatureVC.self)
        super.init(nibName: String(describing: SignatureVC.self), bundle: bundle)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Button Actions
    
    @objc func onTouchCancelButton() {
        signatureDelegate?.signatureVCCancelled(self)
    }

    @objc func onTouchDoneButton() {
        if let signature = signatureView.getSignatureAsImage() {
            if switchSaveSignature.isOn {
                let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
                let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
                signatureView.saveSignature(filePath)
            }
            signatureDelegate?.signature(vc: self, signed: signature, in: signatureView.getSignatureBoundsInCanvas())
        } else {
            let alert = UIAlertController(title: "No Signature", message: "Please sign on the line", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                //
            }))
            self.present(alert, animated: true, completion: {
                //
            })
        }
    }
    
    @objc func onTouchActionButton(_ barButton: UIBarButtonItem) {
        let action = UIAlertController(title: "Action", message: "", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        action.addAction(UIAlertAction(title: "Load default signature", style: UIAlertActionStyle.default, handler: { action in
            let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let filePath = (docPath! as NSString).appendingPathComponent("sig.data")
            self.signatureView.loadSignature(filePath)
        }))
        
        action.addAction(UIAlertAction(title: "Delete default signature", style: UIAlertActionStyle.destructive, handler: { action in
            self.signatureView.removeSignature()
        }))
        
        action.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        if let popOver = action.popoverPresentationController {
            popOver.barButtonItem = barButton
        }
        present(action, animated: true, completion: nil)
    }

    @objc func onTouchClearButton() {
        signatureView.clear()
    }
    
    override open func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        signatureView.reposition()
    }
}
