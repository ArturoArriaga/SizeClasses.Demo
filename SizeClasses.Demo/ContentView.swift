//
//  ContentView.swift
//  SizeClasses.Demo
//
//  Created by Art Arriaga on 2/25/20.
//  Copyright © 2020 ArturoArriaga.IO. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class CollectionViewCell: UICollectionViewCell {
    
    let someView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    
    var sharedConstraints: [NSLayoutConstraint] = []
    var regularConstraints: [NSLayoutConstraint] = []
    var compactConstraints: [NSLayoutConstraint] = []

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .green
        
        addSubview(someView)

        setupConstraints()
        NSLayoutConstraint.activate(sharedConstraints)
        
    }
    
    override func layoutSubviews() {
        layoutTrait(traitCollection: UIScreen.main.traitCollection)
    }
    
    fileprivate func setupConstraints() {
        sharedConstraints.append(contentsOf: [
            someView.centerXAnchor.constraint(equalTo: centerXAnchor),
            someView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        regularConstraints.append(contentsOf: [
            someView.heightAnchor.constraint(equalToConstant: 300),
            someView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        compactConstraints.append(contentsOf: [
            someView.heightAnchor.constraint(equalToConstant: 200),
            someView.widthAnchor.constraint(equalToConstant: 400)
        
        ])
    }
    
    
    func layoutTrait(traitCollection: UITraitCollection) {
        if (!sharedConstraints[0].isActive) {
            //activate constraints
            NSLayoutConstraint.activate(sharedConstraints)
        }
        //horizontal means compact width/ vertical means height
        if traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            if regularConstraints.count > 0 && regularConstraints[0].isActive {
                NSLayoutConstraint.deactivate(regularConstraints)
            }
            //activate compact constraints
            NSLayoutConstraint.activate(compactConstraints)
        } else {
            if compactConstraints.count > 0 && compactConstraints[0].isActive {
                NSLayoutConstraint.deactivate(compactConstraints)
            }
            //activate regular constraints
            NSLayoutConstraint.activate(regularConstraints)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        print(self.traitCollection)
        layoutTrait(traitCollection: traitCollection)
        print(self.traitCollection)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CollectionViewCell
        cell.layoutIfNeeded()
        return cell
    }
    
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
