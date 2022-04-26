//
//  ProcessingView.swift
//  OpenChargeApp
//
//  Created by Nadheer on 15/02/2022.
//

import SwiftUI
import Lottie

struct ProcessingView: UIViewRepresentable {
    var name = "5695-circle-loading"
    var loopMode: LottieLoopMode = .loop

    private let view = UIView(frame: .zero)
    private let animationView = AnimationView()

    func makeUIView(context: UIViewRepresentableContext<ProcessingView>) -> UIView {
        
        setupAnimationView()
        makeConstraints()

        return view
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<ProcessingView>) {}
    
    private func setupAnimationView() {
        let animation = Animation.named(name)

        animationView.backgroundColor = .black
        animationView.layer.opacity = 0.9
        
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
    }
    
    private func makeConstraints() {
        view.addSubview(animationView)
        
        let centerXConstraint = NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 40)
        
        let centerYConstraint = NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 40)
        
        view.addConstraints([
            centerXConstraint, centerYConstraint
        ])
    }
}
