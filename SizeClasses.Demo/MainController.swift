//
//  ContentView.swift
//  SizeClasses.Demo
//
//  Created by Art Arriaga on 2/25/20.
//  Copyright © 2020 ArturoArriaga.IO. All rights reserved.
//
import UIKit

//MARK: CollectionViewCell
class CollectionViewCell: UICollectionViewCell {
    
    let someOrangeView : UIView = {
        let v = UIView()
        v.backgroundColor = .orange
        return v
    }()
    
    let someRedView : UIView = {
           let v = UIView()
           v.backgroundColor = .red
           return v
       }()
    
    lazy var stackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [someOrangeView, someRedView])
        sv.axis = .vertical
        sv.distribution = .fillEqually
        sv.spacing = 8
        return sv
    }()
    
    let somePotentialImageView: UIView = {
        let v = UIView()
        v.backgroundColor = .purple
        return v
    }()
    
    lazy var baseStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [somePotentialImageView, stackView])
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        v.distribution = .fillEqually
        v.spacing = 10
        return v
    }()
    //MARK: Constraints
    var sharedConstraints: [NSLayoutConstraint] = []
    var landscapeContraints: [NSLayoutConstraint] = []
    var portraitConstraints: [NSLayoutConstraint] = []

    //Queston: Should trait collection be updated from the cell?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        addSubview(baseStackView)

        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        layoutTrait(traitCollection: UIScreen.main.traitCollection)

    }
    
    
    fileprivate func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            baseStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            baseStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        //constraints for landscape mode with compact height, regular width
        landscapeContraints.append(contentsOf: [
            baseStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7),
            baseStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
        ])
        //constraints for portrait mode with regular height, compact width
        portraitConstraints.append(contentsOf: [
            baseStackView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
            baseStackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.9)
        
        ])
    }
    
    
    func layoutTrait(traitCollection: UITraitCollection) {
        if (!sharedConstraints[0].isActive) {
            //activate constraints
            NSLayoutConstraint.activate(sharedConstraints)
        }
        //horizontal means compact width/ vertical means height
        // this is normal orientation.
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if landscapeContraints.count > 0 && landscapeContraints[0].isActive {
                NSLayoutConstraint.deactivate(landscapeContraints)
            }
            
            //activate portriat constraints
            NSLayoutConstraint.activate(portraitConstraints)
            baseStackView.axis = .vertical
        } else {
            // this is the portrait mode.
            if portraitConstraints.count > 0 && portraitConstraints[0].isActive {
                NSLayoutConstraint.deactivate(portraitConstraints)
            }
            //activate landscape constraints
            NSLayoutConstraint.activate(landscapeContraints)
            baseStackView.axis = .horizontal
        }
    }
//MARK: TraitCollectionDidChange
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print(self.traitCollection, baseStackView.frame)
        layoutTrait(traitCollection: traitCollection)
        print(self.traitCollection, baseStackView.frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: MainController
class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let cellId = "cellid"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        print(self.traitCollection)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    //the bug is here.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        return cell
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
