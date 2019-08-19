//
//  ModalMusic.swift
//  itunes-poc
//
//  Created by David Duarte on 18/08/2019.
//  Copyright © 2019 David Duarte. All rights reserved.
//

import UIKit



extension MusicTableViewController {
    enum SongPlayerState {
        case collapsed
        case expanded
    }
    
    func showModal(song: Music, image: UIImage) {
        // Setup starting and ending modal height
        endPlayerHeight = self.view.frame.height * 0.85
        startPlayerHeight = 0.0
        
        // Add Visual Effects View
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.parent?.view.addSubview(visualEffectView)
        // Add SongViewController xib to the screen, clipping bounds so that the corners can be rounded
        songViewController = SongPlayerController(song: song, image: image)
        
        self.parent?.view.addSubview(songViewController.view)
        songViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - startPlayerHeight, width: self.view.bounds.width, height: endPlayerHeight)
        songViewController.view.clipsToBounds = true
        
        // Add tap and pan recognizers
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MusicTableViewController.handlePlayerTap(recognzier:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MusicTableViewController.handlePlayerPan(recognizer:)))
        
        animateTransitionIfNeeded(state: nextState, duration: 0.9)
        songViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        songViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
    }
    
    // Handle tap gesture recognizer
    @objc
    func handlePlayerTap(recognzier:UITapGestureRecognizer) {
        switch recognzier.state {
        // Animate card when tap finishes
        case .ended:
            animateTransitionIfNeeded(state: nextState, duration: 0.9)
        default:
            break
        }
    }
    
    // Handle pan gesture recognizer
    @objc
    func handlePlayerPan (recognizer:UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // Start animation if pan begins
            startInteractiveTransition(state: nextState, duration: 0.9)
        case .changed:
            // Update the translation according to the percentage completed
            let translation = recognizer.translation(in: self.songViewController.handleArea)
            var fractionComplete = translation.y / endPlayerHeight
            fractionComplete = songPlayerVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            // End animation when pan ends
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    
    // Animate transistion function
    func animateTransitionIfNeeded (state:SongPlayerState, duration:TimeInterval) {
        // Check if frame animator is empty
        if runningAnimations.isEmpty {
            // Create a UIViewPropertyAnimator depending on the state of the popover view
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    // If expanding set popover y to the ending height and blur background
                    self.songViewController.view.frame.origin.y = self.view.frame.height - self.endPlayerHeight
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                    
                case .collapsed:
                    // If collapsed set popover y to the starting height and remove background blur
                    self.songViewController.view.frame.origin.y = self.view.frame.height - self.startPlayerHeight
                    
                    self.visualEffectView.effect = nil
                    
                }
            }
            
            // Complete animation frame
            frameAnimator.addCompletion { _ in
                self.songPlayerVisible = !self.songPlayerVisible
                self.runningAnimations.removeAll()
                switch state {
                case .collapsed:
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                    self.visualEffectView.removeFromSuperview()
                    self.songViewController.view.removeFromSuperview()
                    self.songViewController.removeFromParent()
                    self.tableView.isScrollEnabled = true
                    self.tableView.allowsSelection = true
                    
                    
                case .expanded: break
                }
            }
            
            // Start animation
            frameAnimator.startAnimation()
            
            // Append animation to running animations
            runningAnimations.append(frameAnimator)
            
            // Create UIViewPropertyAnimator to round the popover view corners depending on the state of the popover
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .expanded:
                    // If the view is expanded set the corner radius to 30
                    self.songViewController.view.layer.cornerRadius = 30
                    
                case .collapsed:
                    // If the view is collapsed set the corner radius to 0
                    self.songViewController.view.layer.cornerRadius = 0
                }
            }
            
            // Start the corner radius animation
            cornerRadiusAnimator.startAnimation()
            
            // Append animation to running animations
            runningAnimations.append(cornerRadiusAnimator)
            
        }
    }
    
    // Function to start interactive animations when view is dragged
    func startInteractiveTransition(state:SongPlayerState, duration:TimeInterval) {
        
        // If animation is empty start new animation
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Pause animation and update the progress to the fraction complete percentage
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    // Funtion to update transition when view is dragged
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Update the fraction complete value to the current progress
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
    }
    
    // Function to continue an interactive transisiton
    func continueInteractiveTransition (){
        // For each animation in runningAnimations
        for animator in runningAnimations {
            // Continue the animation forwards or backwards
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
