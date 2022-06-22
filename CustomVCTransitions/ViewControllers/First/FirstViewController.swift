//
//  FirstViewController.swift
//  CustomVCTransitions
//
//  Created by Aleksandr Rybachev on 21.06.2022.
//

import UIKit

enum Constants {
    
    static let cellSpacing: CGFloat = 8
}

class FirstViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = Constants.cellSpacing
        layout.minimumInteritemSpacing = Constants.cellSpacing
        
        collectionView.setCollectionViewLayout(layout, animated: false)
    }
    
    func presentSecondViewController(with data: CellData) {
        guard let secondViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as? SecondViewController else { return }
        
        secondViewController.modalPresentationStyle = .fullScreen
        secondViewController.data = data
        secondViewController.transitioningDelegate = self
        
        present(secondViewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource and UICollectionViewDelegate

extension FirstViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataManager.data.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCellIdentifier", for: indexPath) as! CollectionViewCell
        cell.configure(with: DataManager.data[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presentSecondViewController(with: DataManager.data[indexPath.row])
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - Constants.cellSpacing) / 2
        return .init(width: width, height: width)
    }
}

// MARK: - UIViewControllerTransitioningDelegate

extension FirstViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    
}
