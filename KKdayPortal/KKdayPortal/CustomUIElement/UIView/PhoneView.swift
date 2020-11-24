//
//  PhoneView.swift
//  KKdayPortal
//
//  Created by KKday on 2020/11/24.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class PhoneView: UIView {
    
    var numberLabel: UILabel = UILabel()
    
    private let oneView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "1.circle.fill")!)
    let twoView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "2.circle.fill")!)
    let threeView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "3.circle.fill")!)
    let numStackViewOne: UIStackView = UIStackView()
    
    let fourView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "4.circle.fill")!)
    let fiveView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "5.circle.fill")!)
    let sixView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "6.circle.fill")!)
    let numStackViewTwo: UIStackView = UIStackView()
    
    let sevenView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "7.circle.fill")!)
    let eightView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "8.circle.fill")!)
    let nineView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "9.circle.fill")!)
    let numStackViewThree: UIStackView = UIStackView()
    
    let asteriskView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "staroflife.circle.fill")!)
    let zeroView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "0.circle.fill")!)
    let poundSignView: PhoneNumberView = PhoneNumberView(image: UIImage(systemName: "number.circle.fill")!)
    let numStackVuewFour: UIStackView = UIStackView()
    
    let numStackView: UIStackView = UIStackView()
    
    let sendNumberButton: UIButton = UIButton()
    var sendNumberHandler: (String?) -> Void = { _ in }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
        bindHandler()
        addAction()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        numberLabel.text = ""
        
        self.addSubview(oneView)
        self.addSubview(twoView)
        self.addSubview(threeView)
        self.addSubview(fourView)
        self.addSubview(fiveView)
        self.addSubview(sixView)
        self.addSubview(sevenView)
        self.addSubview(eightView)
        self.addSubview(sendNumberButton)
        
        
    }
    
    func bindHandler() {
        
    }

    func addAction() {
        
        oneView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "1"
        }
        twoView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "2"
        }
        threeView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "3"
        }
        fourView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "4"
        }
        fiveView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "5"
        }
        sixView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "6"
        }
        sevenView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "7"
        }
        eightView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "8"
        }
        asteriskView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "*"
        }
        zeroView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "0"
        }
        poundSignView.addNumHandler = { [weak self] in
            self?.numberLabel.text! += "#"
        }
        
        sendNumberButton.addTarget(self, action: #selector(sendNumber), for: .touchUpInside)
    }
    
    @objc func sendNumber() {
        sendNumberHandler(numberLabel.text)
    }
    
    
}
