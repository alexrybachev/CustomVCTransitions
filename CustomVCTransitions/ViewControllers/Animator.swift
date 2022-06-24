//
//  Animator.swift
//  CustomVCTransitions
//
//  Created by Aleksandr Rybachev on 21.06.2022.
//

import UIKit

final class Animator: NSObject, UIViewControllerAnimatedTransitioning {
    
    static let duration: TimeInterval = 1.25
    
    private let type: PresentationType
    private let firstViewController: FirstViewController
    private let secondViewController: SecondViewController
    private let cellImageViewRect: CGRect
    private let cellLabelRect: CGRect
    
    private var selectedCellImageViewSnapshot: UIView
    
    init?(type: PresentationType, firstViewController: FirstViewController, secondViewController: SecondViewController, selectedCellImageViewSnapshot: UIView) {
        self.type = type
        self.firstViewController = firstViewController
        self.secondViewController = secondViewController
        self.selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        
        guard let window = firstViewController.view.window ?? secondViewController.view.window,
              let selectedCell = firstViewController.selectedCell
        else { return nil }
        
        self.cellImageViewRect = selectedCell.locationImageView.convert(selectedCell.locationImageView.bounds, to: window)
        
        self.cellLabelRect = selectedCell.locationLabel.convert(selectedCell.locationLabel.bounds, to: window)
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return Self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let toView = secondViewController.view
        else {
            transitionContext.completeTransition(false)
            return
        }
        
        containerView.addSubview(toView)
        
        //        transitionContext.completeTransition(true)
        
        guard let selectedCell = firstViewController.selectedCell,
              let window = firstViewController.view.window ?? secondViewController.view.window,
              let cellImageSnapshot = selectedCell.locationImageView.snapshotView(afterScreenUpdates: true),
              let controllerImageSnapshot = secondViewController.locationImageView.snapshotView(afterScreenUpdates: true),
              let cellLabelSnapshot = selectedCell.locationLabel.snapshotView(afterScreenUpdates: true),
              let closeButtonSnapshot = secondViewController.closeButton.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = type.isPresenting
        
        let backgroundView: UIView
        let fadeView = UIView(frame: containerView.bounds)
        fadeView.backgroundColor = secondViewController.view.backgroundColor
        
//        let imageViewSnapshot: UIView
//
//        if isPresenting {
//            imageViewSnapshot = cellImageSnapshot
//        } else {
//            imageViewSnapshot = controllerImageSnapshot
//        }
        
        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot
            
            backgroundView = UIView(frame: containerView.bounds)
            backgroundView.addSubview(fadeView)
            fadeView.alpha = 0
        } else {
            backgroundView = firstViewController.view.snapshotView(afterScreenUpdates: true) ?? fadeView
            backgroundView.addSubview(fadeView)
        }
        
        toView.alpha = 0
        
//        [imageViewSnapshot].forEach { containerView.addSubview($0) }
        
        [backgroundView, selectedCellImageViewSnapshot, controllerImageSnapshot, cellLabelSnapshot, closeButtonSnapshot].forEach { containerView.addSubview($0) }
        
        let controllerImageViewRect = secondViewController.locationImageView.convert(secondViewController.locationImageView.bounds, to: window)
        let controllerLabelRect = secondViewController.locationLabel.convert(secondViewController.locationLabel.bounds, to: window)
        let closeButtonRect = secondViewController.closeButton.convert(secondViewController.closeButton.bounds, to: window)
        
//        [imageViewSnapshot].forEach {
//            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
//        }
        
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }
        
        controllerImageSnapshot.alpha = isPresenting ? 0 : 1
        
        cellLabelSnapshot.frame = isPresenting ? cellLabelRect : controllerLabelRect
        
        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0
        
        closeButtonSnapshot.frame = closeButtonRect
        closeButtonSnapshot.alpha = isPresenting ? 0 : 1
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                
//                imageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                
                fadeView.alpha = isPresenting ? 1 : 0
                
                cellLabelSnapshot.frame = isPresenting ? controllerLabelRect : self.cellLabelRect
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
                
                backgroundView.removeFromSuperview()
            }
            
            UIView.addKeyframe(withRelativeStartTime: isPresenting ? 0.7 : 0, relativeDuration: 0.3) {
                closeButtonSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            
//            imageViewSnapshot.removeFromSuperview()
            
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            
            cellLabelSnapshot.removeFromSuperview()
            
            closeButtonSnapshot.removeFromSuperview()
            
            toView.alpha = 1
            
            transitionContext.completeTransition(true)
        })
    }
}

enum PresentationType {
    
    case present
    case dismiss
    
    var isPresenting: Bool {
        return self == .present
    }
}
