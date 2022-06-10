//
//  ViewController.swift
//  DribbleLoader
//
//  Created by Александр Дергилёв on 10.06.2022.
//

import UIKit

class ViewController: UIViewController {
    
    // blur view behind loading scren
    private lazy var blurry: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return blurEffectView
    }()
    
    // loading screen
    private let loadingLabel: UILabel = {
        let l = UILabel()
        // text
        l.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        l.textColor = .label
        l.numberOfLines = 0
        l.textAlignment = .center
        l.text = "loading..."
        // position
        l.frame = CGRect(x: 20, y: 250, width: UIScreen.main.bounds.width-40, height: 100)
        // shadow
        l.layer.shadowRadius = 5
        l.layer.shadowColor = UIColor.black.cgColor
        l.layer.shadowOffset = CGSize.zero
        l.layer.shadowOpacity = 0.5
        return l
    }()

    private let circeImage = UIImage(systemName: "circle.hexagongrid")

    private lazy var circleIV: UIImageView = {
        let iv = UIImageView(image: circeImage)
        iv.alpha = 0
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var circleFillIV: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "circle.hexagongrid.fill"))
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    // strings to show on loading
    private let randomStrings = [
        "Picking flowers from Eden Garden...",
        "Making flower crowns for nymphs...",
        "Spreading petals along the lake...",
        "Smelling cherry blossoms off a tree...",
        "Blowing poplar fluff in the wind...",
        "Painting orchids baby blue...",
        "Watching the lotus floating in the pond...",
        "Clipping daisies in my hair...",
        "Caressing young doves...",
        "Singing spring songs with the nightingale...",
        "Catching the treasure at the end of the rainbow...",
        "Napping on a cloud...",
        "Sipping tea with a wood fairy..."
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingScreen(animating: true)
    }
    
    func blurView(completion: @escaping (_ success: Bool) -> ()) {
        
        // check that users settings allow blur view
        if !UIAccessibility.isReduceTransparencyEnabled {
            
            // add subview and bring to front
            view.addSubview(blurry)
            view.bringSubviewToFront(blurry)
            
            // animate the view
            UIView.animate(withDuration: 1) {
                self.blurry.alpha = 0.75
                completion(true)
            }
        }
    }
    
    func labelText() {
        // show a random sentence
        loadingLabel.text = randomStrings.randomElement()
        
        // change sentence after 6 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(6)) {
            self.loadingLabel.isHidden == true ? nil : self.labelText()
        }
    }
    
    func loadingScreen(animating: Bool) {
        guard animating else {
            // remove blur view and image views
            UIView.animate(withDuration: 1, delay: 0) {
                // find image views by tag
                for view in [self.blurry, self.circleIV, self.circleFillIV] {
                    view.alpha = 0
                    view.removeFromSuperview()
                    
                }
                
                // hide loading label
                self.loadingLabel.isHidden = true
                
            }
            return
        }
        
        // add the label
        labelText()
        
        // add the circles
        let images = [circleIV, circleFillIV]

        // set up both images at once
        for image in images {
            // set the circles position
            let hw: CGFloat = 100
            image.frame = CGRect(x: UIScreen.main.bounds.width/2 - hw/2,
                                 y: 100,
                                 width: hw,
                                 height: hw)

            // set the circles colors
            if #available(iOS 15.0, *) {
                image.tintColor = (image.image == circeImage ? .systemMint : .systemPink)
            } else {
                image.tintColor = (image.image == circeImage ? .systemGreen : .systemRed)
            }

            // rotation animation
            UIView.animate(withDuration: 2, delay: 0, options: [.repeat, .curveLinear]) {
                image.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            }
            
        }
        
        // add blur view
        self.blurView {[weak self] success in
            guard let self = self else { return }
            // bring the circles in front of the blurred view
            self.view.addSubview(self.circleIV)
            self.view.addSubview(self.circleFillIV)
            self.view.contains(self.loadingLabel) ? self.loadingLabel.isHidden = false :  self.view.addSubview(self.loadingLabel)
            // switch views
            UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse]) {
                self.circleFillIV.alpha = 0
                self.circleIV.alpha = 1
            }
            UIView.animate(withDuration: 1, delay: 1, options: [.repeat, .autoreverse]) {
                self.circleFillIV.alpha = 1
                self.circleIV.alpha = 0
            }
        }
    }
}

