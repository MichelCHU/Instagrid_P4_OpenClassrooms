//
//  HomeViewController.swift
//  instagrid
//
//  Created by Square on 20/06/2021.
//

import UIKit

final class HomeViewController: UIViewController {

    // MARK: - Properties

    private var buttonTapped: UIButton?
    private let imagePicker = UIImagePickerController()
    private var swipeGestureRecognizer: UISwipeGestureRecognizer!
    private var transformAnimation: CGAffineTransform?
    var windowInterfaceOrientation: UIInterfaceOrientation? {
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        } else {
            return UIApplication.shared.statusBarOrientation
        }
    }

    // MARK: - Outlets

    @IBOutlet weak var gridMainView: UIView!
    @IBOutlet var layoutButtons: [UIButton]!
    @IBOutlet weak var buttonTopRight: UIButton!
    @IBOutlet weak var buttonBottomRight: UIButton!
    
    // MARK: - View life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(onSwipe(_:)))
        gridMainView.addGestureRecognizer(swipeGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(resetOrientation), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func didPressGridButton(_ sender: UIButton) {
        layoutButtons.forEach { $0.isSelected = false }
        sender.isSelected = true
        switch sender.tag {
        case 1:
            buttonTopRight.isHidden = true
            buttonBottomRight.isHidden = false
        case 2:
            buttonTopRight.isHidden = false
            buttonBottomRight.isHidden = true
        case 3:
            buttonTopRight.isHidden = false
            buttonBottomRight.isHidden = false
        default:
            break
        }
    }
    
    @IBAction func didPressForHavePicture(_ sender: UIButton) {
        buttonTapped = sender
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
    
    // MARK: - Swipe Guesture
    
    @objc
    private func onSwipe(_ sender: UISwipeGestureRecognizer) {
        animateMainView()
    }
    
    private func animateMainView() {
        UIView.animate(withDuration: 0.3, animations: {
            guard let transformAnimation = self.transformAnimation else { return }
            self.gridMainView.transform = transformAnimation
        }, completion: { _ in
            self.share()
        })
    }

    /// return to the initial position
    private func gridMainViewReset() {
        UIView.animate(withDuration: 0.2, animations: {
            self.gridMainView.transform = .identity
        })
    }
    
    @objc
    private func resetOrientation() {
        guard let interfaceOrientation = windowInterfaceOrientation else { return }
        if interfaceOrientation.isPortrait {
            swipeGestureRecognizer.direction = .up
            transformAnimation = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.height)
        } else {
            swipeGestureRecognizer.direction = .left
            transformAnimation = CGAffineTransform(translationX: -UIScreen.main.bounds.width, y: 0)
        }
    }
    
    // MARK: - Sharing

    private func share() {
        let activityViewController = UIActivityViewController(activityItems: [gridMainView.image], applicationActivities: [])
        present(activityViewController, animated: true, completion: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            self.gridMainViewReset()
        }
    }
}

// MARK: - UIImagePickerControllerDelegate

extension HomeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // MARK: - UIImagePickerControllerDelegate ( after selected and change UIbutton ) OK
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage =  info[.originalImage] as? UIImage {
            buttonTapped?.setImage(pickedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}

