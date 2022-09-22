//
//  IndicatorView.swift
//  Roll Time
//
//  Created by Akif Demirezen on 12.06.2022.
//

import UIKit
import Lottie

@IBDesignable
class IndicatorView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupThisView()
    }
    
    override init(frame: CGRect) {
        super.init(frame : frame)
        setupThisView()
    }
    
    private func setupThisView(){
        guard let view = loadViewFromNib() else { return }
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
        self.animationStart()
    }
    
    func animationStart(){
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 2
        animationView.play()
    }
    
    func loadViewFromNib() -> UIView? {
        let nibName = String(describing: IndicatorView.self)
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self,options: nil).first as? UIView
    }
    
}
