//
//  HomeSongView.swift
//  music-player
//

import UIKit

class HomeSongView: UIView {
    @IBOutlet weak var vRoot: UIView!

    @IBOutlet weak var skv: UIStackView!
    
    @IBOutlet weak var vTitleContainer: UIView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initNib()
    }
    
    private func initNib() {
        self.backgroundColor = .clear
        Bundle(for: HomeSongView.self).loadNibNamed("HomeSongView", owner: self, options: nil)
        self.addSubview(self.vRoot)
        self.vRoot.frame = bounds
        self.vRoot.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.vTitleContainer.isHidden = true
    }
    
    func setTitle(title strTitle: String? = nil) {
        self.vTitleContainer.isHidden = false
        self.lblTitle.text = strTitle
    }
}
