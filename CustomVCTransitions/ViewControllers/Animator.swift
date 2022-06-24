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
              let controllerImageSnapshot = secondViewController.locationImageView.snapshotView(afterScreenUpdates: true)
        else {
            transitionContext.completeTransition(true)
            return
        }
        
        let isPresenting = type.isPresenting
        
//        let imageViewSnapshot: UIView
//
//        if isPresenting {
//            imageViewSnapshot = cellImageSnapshot
//        } else {
//            imageViewSnapshot = controllerImageSnapshot
//        }
        
        if isPresenting {
            selectedCellImageViewSnapshot = cellImageSnapshot
        }
        
        toView.alpha = 0
        
//        [imageViewSnapshot].forEach { containerView.addSubview($0) }
        
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach { containerView.addSubview($0) }
        
        let controllerImageViewRect = secondViewController.locationImageView.convert(secondViewController.locationImageView.bounds, to: window)
        
        
//        [imageViewSnapshot].forEach {
//            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
//        }
        
        [selectedCellImageViewSnapshot, controllerImageSnapshot].forEach {
            $0.frame = isPresenting ? cellImageViewRect : controllerImageViewRect
        }
        
        controllerImageSnapshot.alpha = isPresenting ? 0 : 1
        
        selectedCellImageViewSnapshot.alpha = isPresenting ? 1 : 0
        
        
        UIView.animateKeyframes(withDuration: Self.duration, delay: 0, options: .calculationModeCubic, animations: {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
                
//                imageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                self.selectedCellImageViewSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                controllerImageSnapshot.frame = isPresenting ? controllerImageViewRect : self.cellImageViewRect
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.6) {
                self.selectedCellImageViewSnapshot.alpha = isPresenting ? 0 : 1
                controllerImageSnapshot.alpha = isPresenting ? 1 : 0
            }
        }, completion: { _ in
            
//            imageViewSnapshot.removeFromSuperview()
            
            self.selectedCellImageViewSnapshot.removeFromSuperview()
            controllerImageSnapshot.removeFromSuperview()
            
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
