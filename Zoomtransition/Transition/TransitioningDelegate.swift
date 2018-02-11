//
//  MasterDetailTransitioningDelegate.swift
//  Zoomtransition
//
//  Created by Jairo Bambang Oetomo on 05-02-18.
//  Copyright © 2018 Jairo Bambang Oetomo. All rights reserved.
//

import UIKit

class TransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    var selectedIndexPath: IndexPath?
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MasterDetailAnimator()
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = DetailMasterAnimator(selectedIndexPath: selectedIndexPath)
        return animator
    }
}




class MasterDetailAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        
        guard let masterVC = transitionContext.viewController(forKey: .from) as? MasterTableViewController,
            let tableView = masterVC.tableView,
            let cell = tableView.cellForRow(at: tableView.indexPathForSelectedRow ?? IndexPath(row:1, section:0)) as? Cell,
            let detailVC = transitionContext.viewController(forKey: .to) as? DetailViewController else {
                transitionContext.completeTransition(true)
                return
        }
        
        let containerView = transitionContext.containerView
        detailVC.view.frame = transitionContext.finalFrame(for: detailVC)
        detailVC.view.layoutIfNeeded()
        containerView.addSubview(detailVC.view)
        
        cell.isHidden = true
        detailVC.view.isHidden = true
        detailVC.hideStatusBar = true
        masterVC.isStatusBarHidden = true
        
        let parentView = UIView(frame: CGRect(origin: CGPoint(x: 0, y: 0 ), size: UIScreen.main.bounds.size))
        parentView.backgroundColor = .white
        containerView.addSubview(parentView)
        
        let originY = 60 + CGFloat(tableView.indexPathForSelectedRow!.row) * tableView.bounds.width - tableView.contentOffset.y
        var cellFrame = tableView.rectForRow(at: tableView.indexPathForSelectedRow!)
        cellFrame.origin.y = originY
        
        let delay = 0.15
        
        
        let effectView = UIVisualEffectView(effect: nil)
        effectView.frame = containerView.bounds
        let effect = UIBlurEffect(style: .dark)
        containerView.insertSubview(effectView, at: 2)
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            effectView.effect = effect
        }, completion: nil)
        
        
        
        
        let imageView = UIImageView(frame: cellFrame.offsetBy(dx: 0, dy: 20))
        imageView.image = detailVC.imageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        parentView.addSubview(imageView)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            imageView.frame.origin.y += imageView.frame.origin.y > detailVC.imageView.frame.origin.y ? 10 : -10
        }) { (finished) in
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
                imageView.frame = detailVC.imageView.frame
                detailVC.setNeedsStatusBarAppearanceUpdate()
            }, completion: { finished in
                parentView.removeFromSuperview()
                detailVC.view.isHidden = false
                cell.isHidden = false
                effectView.removeFromSuperview()
                transitionContext.completeTransition(finished)
            })
        }
        
        
        
        let closeImage = UIImageView(frame: detailVC.closeButton.frame)
        closeImage.image = detailVC.closeButton.imageView?.image
        closeImage.alpha = 0
        imageView.addSubview(closeImage)
        UIView.animate(withDuration: 0.5, delay: delay, options: [], animations: {
            closeImage.alpha = 1
        }, completion: nil)
        
        
        
        let titleLabel = UILabel()
        titleLabel.font = cell.label.font
        titleLabel.textColor = cell.label.textColor
        titleLabel.text = cell.label.text
        titleLabel.numberOfLines = 0
        titleLabel.frame.origin = cell.label.frame.origin
        titleLabel.sizeToFit()
        imageView.addSubview(titleLabel)
        UIView.animate(withDuration: 0.5, delay: delay, options: .curveEaseIn, animations: {
            titleLabel.frame.origin = detailVC.titleLabel.frame.origin
        }, completion: nil)
        
        
        let bodyLabel = UILabel()
        bodyLabel.font = detailVC.bodyLabel.font
        bodyLabel.textColor = detailVC.bodyLabel.textColor
        bodyLabel.text = detailVC.bodyLabel.text
        bodyLabel.numberOfLines = 0
        bodyLabel.frame.origin = cellFrame.origin.applying(CGAffineTransform(translationX: 20, y: cellFrame.height + 20))
        bodyLabel.frame.size.width = imageView.frame.width - 40
        bodyLabel.sizeToFit()
        bodyLabel.alpha = 0
        parentView.addSubview(bodyLabel)
        UIView.animate(withDuration: 1, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            bodyLabel.alpha = 1
            bodyLabel.frame.origin = detailVC.bodyLabel.frame.origin
        }, completion: nil)
        

        let mask = CAShapeLayer()
        mask.frame = containerView.frame
        let path1 = UIBezierPath(roundedRect: cellFrame.insetBy(dx: 20, dy: 20).offsetBy(dx: 0, dy: 20), cornerRadius: 20).cgPath
        let path2 = UIBezierPath(roundedRect: cellFrame.insetBy(dx: 25, dy: 25).offsetBy(dx: 0, dy: 20), cornerRadius: 15).cgPath
        let path3 = UIBezierPath(roundedRect: parentView.frame, cornerRadius: 1).cgPath
        mask.path = path3
        parentView.layer.mask = mask
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.duration = 0.5
        animation.keyTimes = [NSNumber(value: 0), NSNumber(value: 0.35),NSNumber(value: 1)]
        animation.values = [path1, path2, path3]
        animation.calculationMode = "cubic"
        mask.add(animation, forKey: "path")
        
        
    }
    
}

class DetailMasterAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var selectedIndexPath: IndexPath?
    
    init(selectedIndexPath: IndexPath?) {
        self.selectedIndexPath = selectedIndexPath
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let masterVC = transitionContext.viewController(forKey: .to) as? MasterTableViewController,
            let detailVC = transitionContext.viewController(forKey: .from) as? DetailViewController,
            let tableView = masterVC.tableView,
            let cell = tableView.cellForRow(at: selectedIndexPath!) as? Cell else { return }
        
        let containerView = transitionContext.containerView
        masterVC.view.frame = containerView.frame
        masterVC.view.layoutIfNeeded()
        containerView.addSubview(masterVC.view)
        
        masterVC.isStatusBarHidden = false
        cell.isHidden = true
        
        
        let originY = 100 + CGFloat(selectedIndexPath!.row) * tableView.bounds.width - tableView.contentOffset.y
        var cellFrame = tableView.rectForRow(at: selectedIndexPath!)
        cellFrame.origin.y = originY
        
        
        let parentView = UIView(frame: containerView.frame)
        parentView.backgroundColor = .white
        containerView.addSubview(parentView)
        
        
        let imageView = UIImageView(frame: detailVC.imageView.frame)
        imageView.image = detailVC.imageView.image
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        parentView.addSubview(imageView)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            imageView.frame = cellFrame
            masterVC.setNeedsStatusBarAppearanceUpdate()
        }) { (finished) in
            cell.isHidden = false
            transitionContext.completeTransition(finished)
        }
        
        
        let titleLabel = UILabel()
        titleLabel.font = detailVC.titleLabel.font
        titleLabel.textColor = detailVC.titleLabel.textColor
        titleLabel.text = detailVC.titleLabel.text
        titleLabel.frame.origin = detailVC.titleLabel.frame.origin
        titleLabel.numberOfLines = 0
        titleLabel.sizeToFit()
        imageView.addSubview(titleLabel)
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            titleLabel.frame.origin = CGPoint(x: cell.label.frame.origin.x, y: cell.label.frame.origin.y)
        }, completion: nil)
        
        
        let bodyLabel = UILabel()
        bodyLabel.font = detailVC.bodyLabel.font
        bodyLabel.textColor = detailVC.bodyLabel.textColor
        bodyLabel.text = detailVC.bodyLabel.text
        bodyLabel.numberOfLines = 0
        bodyLabel.frame.origin = detailVC.bodyLabel.frame.origin
        bodyLabel.frame.size.width = detailVC.bodyLabel.frame.width
        bodyLabel.sizeToFit()
        parentView.addSubview(bodyLabel)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [], animations: {
            bodyLabel.alpha = 0
            bodyLabel.frame.origin.y = cellFrame.origin.y + cellFrame.height + 20
        }, completion: nil)
        
        
        let closeImage = UIImageView(frame: detailVC.closeButton.frame)
        closeImage.image = detailVC.closeButton.imageView?.image
        imageView.addSubview(closeImage)
        UIView.animate(withDuration: 0.5, delay: 0, options: [], animations: {
            closeImage.alpha = 0
        }, completion: nil)
        
        
        let mask = CAShapeLayer()
        mask.frame = containerView.frame
        let path1 = UIBezierPath(roundedRect: mask.frame, cornerRadius: 1).cgPath
        let path2 = UIBezierPath(roundedRect: cellFrame.insetBy(dx: 24, dy: 24), cornerRadius: 15).cgPath
        let path3 = UIBezierPath(roundedRect: cellFrame.insetBy(dx: 20, dy: 20), cornerRadius: 20).cgPath
        mask.path = path3
        parentView.layer.mask = mask
        let animation = CAKeyframeAnimation(keyPath: "path")
        animation.duration = 0.4
        animation.keyTimes = [NSNumber(value: 0), NSNumber(value: 0.65),NSNumber(value: 1)]
        animation.values = [path1, path2, path3]
        animation.calculationMode = "cubic"
        mask.add(animation, forKey: "path")
        
        let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        effectView.frame = containerView.bounds
        containerView.insertSubview(effectView, at: 2)
        UIView.animate(withDuration: 0.5, animations: {
            effectView.effect = nil
        }, completion: { finished in
            effectView.removeFromSuperview()
        })
        
    }
}


