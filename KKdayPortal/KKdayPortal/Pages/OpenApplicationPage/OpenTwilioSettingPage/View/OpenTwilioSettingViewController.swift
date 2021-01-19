//
//  OpenTwilioSettingViewController.swift
//  KKdayPortal-Open
//
//  Created by KKday on 2021/1/18.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

import UIKit

final class OpenTwilioSettingViewController: UIViewController, Keyboarder {

    // 🏞 UI element
    
    lazy var closeButton: UIButton = {
        let btn = UIButton()
        btn.setImage(#imageLiteral(resourceName: "icCrossWhite"), for: .normal)
        return btn
    }()
    
    lazy var scrollView: UIScrollView? = {
        let srv = UIScrollView()
        srv.keyboardDismissMode = .onDrag
        return srv
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var inputStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .center
        stv.spacing = 30
        return stv
    }()
    
    lazy var kanbanTextView: UITextView = {
        let txv = UITextView()
        txv.backgroundColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        txv.isScrollEnabled = false
        
        let currentTwilioHost: String? = StorageManager.shared.load(for: .twilioHost)
        let currentTwilioEndPoint: String? = StorageManager.shared.load(for: .twilioEndPoint)
        let currentTwilioIdentifier: String? = StorageManager.shared.load(for: .twilioIdentifier)
        
        txv.text = """
            <Current Call Information>
            TwilioHost: \(currentTwilioHost ?? "")
            TwilioEndPoint: \(currentTwilioEndPoint ?? "")
            TwilioIdentifier: \(currentTwilioIdentifier ?? "")
            """
        txv.isEditable = false
        return txv
    }()
    
    lazy var twilioURLStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var twilioURLLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.text = "Please enter your twilio website URL Host"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var twilioURLTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        txf.keyboardType = .URL
        txf.layer.cornerRadius = 12
        txf.returnKeyType = .next
        return txf
    }()
    
    lazy var endPointStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var endPointLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.text = "Please enter your twilio endPoint"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var endPointTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        txf.keyboardType = .default
        txf.layer.cornerRadius = 12
        txf.returnKeyType = .next
        return txf
    }()
    
    lazy var identifierStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.distribution = .fill
        stv.alignment = .leading
        return stv
    }()
    
    lazy var identifierLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.text = "Please enter your twilio identifier"
        lbl.adjustsFontSizeToFitWidth = true
        lbl.textAlignment = .left
        return lbl
    }()
    
    lazy var identifierTextFiled: TogglePasswordTextField = {
        let txf = TogglePasswordTextField()
        txf.backgroundColor = #colorLiteral(red: 0.3098039329, green: 0.2039215714, blue: 0.03921568766, alpha: 1)
        txf.keyboardType = .default
        txf.layer.cornerRadius = 12
        txf.returnKeyType = .go
        return txf
    }()
    
    lazy var okButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.setTitle("OK", for: .normal)
        btn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.isEnabled = false
        return btn
    }()
    
    
    // ⌨️ Keyboarder
    
    var isKeyboardShown: Bool = false
    
    var scrollViewOriginalContentInset: UIEdgeInsets = .zero
    
    var observerForKeyboardWillShowNotification: NSObjectProtocol?
    
    var observerForKeyboardDidShowNotification: NSObjectProtocol?
    
    var observerForKeyboardWillHideNotification: NSObjectProtocol?
    
    var observerForKeyboardDidHideNotification: NSObjectProtocol?
    
    var observerForKeyboardWillChangeFrameNotification: NSObjectProtocol?
    
    var observerForKeyboardDidChangeFrameNotification: NSObjectProtocol?
    
    private var viewModel: OpenTwilioSettingViewModel!
    
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    init(viewModel: OpenTwilioSettingViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIDelegate()
        createGestureRecognizer()
        setAction()
        registerKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollViewOriginalContentInset.bottom = 20
        
    }
    
    deinit {
        unRegisterKeyboard()
    }
    
    // 🎨 draw UI
    private func setupUI() {
        self.view.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        
        guard let scrollView = scrollView else {
            return
        }
        self.view.addSubview(scrollView)
        scrollView.addSubview(container)
        container.addSubview(inputStackView)
        self.view.addSubview(closeButton)
        
        inputStackView.addArrangedSubview(kanbanTextView)
        
        inputStackView.addArrangedSubview(twilioURLStackView)
        twilioURLStackView.addArrangedSubview(twilioURLLabel)
        twilioURLStackView.addArrangedSubview(twilioURLTextField)
        
        inputStackView.addArrangedSubview(endPointStackView)
        endPointStackView.addArrangedSubview(endPointLabel)
        endPointStackView.addArrangedSubview(endPointTextField)
       
        inputStackView.addArrangedSubview(identifierStackView)
        identifierStackView.addArrangedSubview(identifierLabel)
        identifierStackView.addArrangedSubview(identifierTextFiled)
    
        inputStackView.addArrangedSubview(okButton)
        
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        container.snp.makeConstraints { maker in
            maker.edges.equalTo(self.scrollView!)
            maker.height.equalToSuperview()
            maker.width.equalToSuperview()
        }
        
        inputStackView.snp.makeConstraints { maker in
            maker.centerX.centerY.equalToSuperview()
        }
        
        
        kanbanTextView.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-110)
        }

        
        twilioURLLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        
        twilioURLTextField.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        endPointLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        endPointTextField.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        identifierLabel.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-120)
        }
        identifierTextFiled.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-100)
            maker.height.equalTo(44)
        }
        
        okButton.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.width).offset(-180)
            maker.height.equalTo(50)
        }
        
        closeButton.snp.makeConstraints { maker in
            maker.width.height.equalTo(20)
            maker.top.equalToSuperview().offset(10)
            maker.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
    func setupUIDelegate() {
        twilioURLTextField.delegate = self
        endPointTextField.delegate = self
        identifierTextFiled.delegate = self
    }
    
    private func createGestureRecognizer() {
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handerSingleTap))
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc func handerSingleTap() {
        self.twilioURLTextField.resignFirstResponder()
        self.endPointTextField.resignFirstResponder()
        self.identifierTextFiled.resignFirstResponder()
    }
    
    // 🎬 set action
    private func setAction() {
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        okButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
    }
    
    @objc private func close() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func confirm() {
        
        StorageManager.shared.save(for: .twilioHost, value: twilioURLTextField.text)
        
    }
    
    
    private func setComfirmButtonState(_ isReady: Bool) {
        okButton.isEnabled = isReady
        okButton.backgroundColor = isReady ? #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1) : #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    }
}


extension OpenTwilioSettingViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        
        if let twilioURL = twilioURLTextField.text, !twilioURL.isEmpty,
           let endPoint = endPointTextField.text, !endPoint.isEmpty,
           let identifier = identifierTextFiled.text, !identifier.isEmpty {
            
            setComfirmButtonState(true)
        } else {
            setComfirmButtonState(false)
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        switch textField {
        case twilioURLTextField:
            textField.resignFirstResponder()
            endPointTextField.becomeFirstResponder()
        case endPointTextField:
            textField.resignFirstResponder()
            identifierTextFiled.becomeFirstResponder()
        case identifierTextFiled:
            textField.resignFirstResponder()
        default:
            break
        }
        return true
    }
}
