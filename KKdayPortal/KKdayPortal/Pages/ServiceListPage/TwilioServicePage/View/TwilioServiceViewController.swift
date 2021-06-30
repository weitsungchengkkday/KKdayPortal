//
//  TwilioServiceViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//


// 🍕 => set delegate

import UIKit
import Foundation
import SnapKit

import CallKit
import TwilioVoice

final class TwilioServiceViewController: UIViewController, Localizable {
    
    // 🏞 UI element
    lazy var qualityWarningsToaster: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = ""
        lbl.textAlignment = .center
        return lbl
    }()

    lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "headphones.circle.fill") ?? #imageLiteral(resourceName: "icPicture")
        
        return img
    }()
    
    lazy var countryLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    lazy var countryCodePickerView: UIPickerView = {
        let pkv = UIPickerView()
        
        return pkv
    }()
    
    lazy var countryCodeTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        txf.keyboardType = .default
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txf.inputView = countryCodePickerView
        txf.adjustsFontSizeToFitWidth = true
        
        return txf
    }()
    
    lazy var companyIdentifierLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    lazy var companyIdentifierPickerView: UIPickerView = {
        let pkv = UIPickerView()
        
        return pkv
    }()
    
    lazy var companyIdentifierTextField: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        txf.keyboardType = .default
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txf.inputView = companyIdentifierPickerView
        txf.adjustsFontSizeToFitWidth = true
        
        return txf
    }()
    
    lazy var outgoingLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        lbl.adjustsFontSizeToFitWidth = true
        
        return lbl
    }()
    
    lazy var outgoingTextField: CleanButtonTextField = {
        let txf = CleanButtonTextField()
        txf.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        txf.keyboardType = .default
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        txf.attributedPlaceholder = NSAttributedString(string: "e.g.+886971532770",
                                                       attributes: [NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)])
        txf.keyboardType = .phonePad
        txf.adjustsFontSizeToFitWidth = true
        
        return txf
    }()
    
    lazy var placeCallButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "phone.fill.arrow.up.right") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        
        return btn
    }()
    
    lazy var callControlView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0)
        return view
    }()
    
    lazy var muteSwitch: UISwitch = {
        let swh = UISwitch()
        swh.isEnabled = true
        return swh
    }()
    
    lazy var muteLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    lazy var speakerSwitch: UISwitch = {
        let swh = UISwitch()
        swh.isEnabled = true
        swh.isOn = true
        return swh
    }()
    
    lazy var speakerLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.textAlignment = .center
        
        return lbl
    }()
    
    var observerLanguageChangedNotification: NSObjectProtocol?
    
    func refreshLanguage(_ nofification: Notification) {
        localizedText()
    }
    
    // CallKit
    var callKitProvider: CXProvider?
    let callKitCallController = CXCallController()
    var userInitiatedDisconnect: Bool = false
    
    var callKitCompletionCallBack: ((Bool) -> Void)? = nil
    
    let twimlParamTo = "To"
    
    let twimlPlatform = "p_platform"
    let twimlPlatformValue = "ios_kkportal"
    
    let twimlParamCompanyIdentifier = "p_company_identifier"
    let twimlParamCountryCode = "p_country_code"
    
    let identity: String = {
        let user: GeneralUser? = StorageManager.shared.loadObject(for: .generalUser)
        let userName: String = String(user?.account.split(separator: "@").first ?? "KKUser")
        
        return userName
    }()
    
    var activeCall: Call? = nil
    var activeCalls: [String: Call] = [:]
    var activeCallInvites: [String: CallInvite] = [:]
    
    var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    
    // AVAudio
    var ringtonePlayer: AVAudioPlayer? = nil
    var playCustomRingback = true
    
    // Device register Time-to-live(TTL) days
    static let kRegistrationTTLInDays = 365
    
    // Twilio User Default Key
    static let kCachedDeviceToken = "CachedDeviceToken"
    static let kCachedBindingDate = "CachedBindingDate"
    
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    var accessTokenURL: URL? = nil
    var kkOfficesInfos: [KKOfficesInfo] = []
    var viewModel: TwilioServiceViewModel
    
    init(viewModel: TwilioServiceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.setCallKit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupKKPortalTwilioConfig()
        setupUI()
        toggleUIState(isEnabled: true, showCallControl: false)
        setUIElementDelegate()
        setAction()
        registerLanguageManager()
        createGestureRecognizer()
        
        // TVOAudioDevice must be set before performing any other actions with the SDK
        TwilioVoiceSDK.audioDevice = audioDevice
    }
    
    deinit {
        unregisterLanguageManager()
        
        if let provider = callKitProvider {
            provider.invalidate()
        }
    }
    
    //  Load KKPortalTwilioConfig (accessToken URL and kkOfficesInfos)
    private func setupKKPortalTwilioConfig() {
        guard let config: PortalConfig = StorageManager.shared.loadObject(for: .portalConfig), let portalService = config.data.services.filter({$0.type == "cti" && $0.name == "twilio"}).first else {
            print("❌ Can't get plone portal service in portalConfig")
            return
        }
        
        guard let KKPortalTwilioConfigURL = URL(string: portalService.url) else {
            print("❌ Portal root URL is invalid")
            return
        }
        
        viewModel.loadKKPortalTwilioConfig(url: KKPortalTwilioConfigURL) { result in
            
            switch result {
            case .success(let data):
                do {
                    let KKPortalTwilioConfig = try JSONDecoder().decode(KKPortalTwilioConfig.self, from: data)
                    self.accessTokenURL = URL(string: KKPortalTwilioConfig.accessTokenURL)
                    self.kkOfficesInfos = KKPortalTwilioConfig.KKOfficesInfos
                    
                    // setup initail TextField value
                    self.countryCodeTextField.text = self.kkOfficesInfos.first?.country
                    
                    self.companyIdentifierTextField.text = self.kkOfficesInfos.first?.companyIdentifier.first
                
                } catch {
                    print("📄⚠️ \(error).localizedDescription")
                }
                
            case .failure(let error):
                print("📄⚠️ \(error).localizedDescription")
            }
        }
    }
    
    private func setupUI() {
        
        localizedText()
        
        self.view.addSubview(qualityWarningsToaster)
        self.view.addSubview(iconView)
        self.view.addSubview(countryLabel)
        self.view.addSubview(countryCodeTextField)
        self.view.addSubview(companyIdentifierLabel)
        self.view.addSubview(companyIdentifierTextField)
        self.view.addSubview(outgoingLabel)
        self.view.addSubview(outgoingTextField)
        self.view.addSubview(placeCallButton)
        
        self.view.addSubview(callControlView)
        self.callControlView.addSubview(muteSwitch)
        self.callControlView.addSubview(muteLabel)
        self.callControlView.addSubview(speakerSwitch)
        self.callControlView.addSubview(speakerLabel)
        
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        qualityWarningsToaster.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(18)
            maker.top.equalTo(self.view.snp.topMargin).offset(16)
            maker.width.equalTo(self.view.snp.width)
        }
      
        iconView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-240)
            maker.width.equalTo(120)
            maker.height.equalTo(120)
        }
        
        countryLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(iconView.snp.bottom).offset(8)
            maker.width.equalTo(256)
            maker.height.equalTo(40)
        }
        
        countryCodeTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(countryLabel.snp.bottom).offset(8)
            maker.width.equalTo(240)
        }
        
        companyIdentifierLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(countryCodeTextField.snp.bottom).offset(8)
            maker.width.equalTo(256)
            maker.height.equalTo(40)
        }
        
        companyIdentifierTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(companyIdentifierLabel.snp.bottom).offset(8)
            maker.width.equalTo(240)
        }
        
        outgoingLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(companyIdentifierTextField.snp.bottom).offset(8)
            maker.width.equalTo(256)
            maker.height.equalTo(40)
        }
        
        outgoingTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(outgoingLabel.snp.bottom).offset(8)
            maker.width.equalTo(240)
        }
        
        placeCallButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(40)
            maker.top.equalTo(outgoingTextField.snp.bottom).offset(42.5)
        }
        
        callControlView.snp.makeConstraints { maker in
            maker.top.equalTo(placeCallButton.snp.bottom).offset(8)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(88)
            maker.width.equalTo(240)
        }
        
        muteSwitch.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(12)
            maker.centerX.equalToSuperview().offset(-60)
        }
        
        muteLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(muteSwitch)
            maker.top.equalTo(muteSwitch.snp.bottom).offset(10)
        }
        
        speakerSwitch.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(12)
            maker.centerX.equalToSuperview().offset(60)
        }
        
        speakerLabel.snp.makeConstraints { maker in
            maker.centerX.equalTo(speakerSwitch)
            maker.top.equalTo(speakerSwitch.snp.bottom).offset(10)
        }
        
        setupUIAdvanced()
    }
    
    private func setupUIAdvanced() {
        switch UserResourceManager.shared.resourceType {
        case .kkMember:
            break
        case .custom(_):
            countryLabel.isHidden = true
            countryCodeTextField.isHidden = true
            companyIdentifierLabel.isHidden = true
            companyIdentifierTextField.isHidden = true
        }
    }
    
    private func setUIElementDelegate() {
        // 🍕 set TextFieldDelegate to TwilioServiceViewController
        outgoingTextField.delegate = self
        companyIdentifierTextField.delegate = self
        countryCodeTextField.delegate = self
        
        // 🍕 set UIPickerViewDelegate, UIPickerViewDataSource
        countryCodePickerView.delegate = self
        countryCodePickerView.dataSource = self
        companyIdentifierPickerView.delegate = self
        companyIdentifierPickerView.dataSource = self
    }
    
    // 🧾 localization
    private func localizedText() {
        countryLabel.text = "twilio_service_label_country".localize("請選擇辦公室位置", defaultValue: "Please select office location")
        companyIdentifierLabel.text = "twilio_service_label_company_identifier".localize("請選擇辦公室號碼", defaultValue: "Please select company phone number")
        outgoingLabel.text = "twilio_service_label_outgoing".localize("請輸入接聽者號碼", defaultValue: "Please input callee number")
        muteLabel.text = "twilio_service_label_mute".localize("靜音", defaultValue: "Mute")
        speakerLabel.text = "twilio_service_label_speaker".localize("擴音", defaultValue: "Speaker")
    }
    
    private func setAction() {
        placeCallButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        muteSwitch.addTarget(self, action: #selector(muteSwitchToggled), for: .valueChanged)
        speakerSwitch.addTarget(self, action: #selector(speakerSwitchToggled), for: .valueChanged)
    }
    
    private func createGestureRecognizer() {
        singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handerSingleTap))
        self.view.addGestureRecognizer(singleTapGestureRecognizer)
    }
    
    @objc func handerSingleTap() {
        self.outgoingTextField.resignFirstResponder()
        self.countryCodeTextField.resignFirstResponder()
        self.companyIdentifierTextField.resignFirstResponder()
    }
    
    private func setCallKit() {
        let configuration = CXProviderConfiguration()
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        
        callKitProvider = CXProvider(configuration: configuration)
        if let provider = callKitProvider {
            // 🍕 set CXProviderDelegate to TwilioServiceViewController
            provider.setDelegate(self, queue: nil)
        }
    }
    
    @objc private func mainButtonPressed(sender: UIButton) {
        
        guard activeCall == nil else {
            userInitiatedDisconnect = true
            performEndCallAction(uuid: activeCall!.uuid!)
            toggleUIState(isEnabled: false, showCallControl: false)
            
            return
        }
        
        checkRecordPermission { [weak self] permissionGranted in
            let uuid = UUID()
            let handle = "KKTwilio Phone Call"
            
            guard !permissionGranted else {
                self?.performStartCallAction(uuid: uuid, handle: handle)
                
                return
            }
            
            self?.showMicrophoneAccessRequest(uuid, handle)
        }
    }
    
    private func checkRecordPermission(completion: @escaping (_ permissionGranted: Bool) -> Void) {
        let permissionStatus = AVAudioSession.sharedInstance().recordPermission
        
        switch permissionStatus {
        case .granted:
            completion(true)
        case .denied:
            completion(false)
        case .undetermined:
            AVAudioSession.sharedInstance().requestRecordPermission { granted in completion(granted) }
        default:
            completion(false)
        }
    }
    
    @objc private func muteSwitchToggled(sender: UISwitch) {
        guard let activeCall = activeCall else {
            return
        }
        
        activeCall.isMuted = sender.isOn
        performMuteCallAction(uuid: activeCall.uuid!, muted: sender.isOn)
    }
    
    @objc private func speakerSwitchToggled(sender: UISwitch) {
        toggleAudioRoute(toSpeaker: sender.isOn)
    }
    
    func toggleUIState(isEnabled: Bool, showCallControl: Bool) {
        placeCallButton.isEnabled = isEnabled
        
        if showCallControl {
            callControlView.isHidden = false
            muteSwitch.isOn = false
            speakerSwitch.isOn = true
        } else {
            callControlView.isHidden = true
        }
    }
    
    func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
        let alertController = UIAlertController(title: "twilio_service_alert_microphone_permission_title".localize("KKPortal 聲音", defaultValue: "KKPortal Voice"),
                                                message: "twilio_service_alert_microphone_permission_message".localize("麥克風未被允許使用", defaultValue: "Microphone permission not granted"),
                                                preferredStyle: .alert)
        
        let continueWithoutMic = UIAlertAction(title: "twilio_service_alert_without_microphone".localize("繼續不使用麥克風", defaultValue: "Continue without microphone"), style: .default) { [weak self] _ in
            self?.performStartCallAction(uuid: uuid, handle: handle)
        }
        
        let goToSettings = UIAlertAction(title: "twilio_service_alert_settings".localize("設定", defaultValue: "Settings"), style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
                                      completionHandler: nil)
        }
        
        let cancel = UIAlertAction(title: "general_cancel".localize("取消", defaultValue: "Cancel"), style: .cancel) { [weak self] _ in
            self?.toggleUIState(isEnabled: true, showCallControl: false)
        }
        
        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
}

// MARK: - UITextFieldDelegate
extension TwilioServiceViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        switch textField {
        case countryCodeTextField, companyIdentifierTextField:
            return false
        case outgoingTextField:
            return true
        default:
            return true
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outgoingTextField.resignFirstResponder()
        
        return true
    }
}

// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension TwilioServiceViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch pickerView {
        case countryCodePickerView:
            return kkOfficesInfos.count
            
        case companyIdentifierPickerView:
            let info = kkOfficesInfos.filter { info in
                return info.country == countryCodeTextField.text
            }.first
            return info?.companyIdentifier.count ?? 1
            
        default:
            return 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        switch pickerView {
        case countryCodePickerView:
            var infosCountryCode: [String] = []
            let _ = kkOfficesInfos.map { info in
                infosCountryCode.append(info.country)
            }
            return infosCountryCode[row]
            
        case companyIdentifierPickerView:
        
            let info = kkOfficesInfos.filter { info in
                return info.country == countryCodeTextField.text
            }.first
            
            return info?.companyIdentifier[row]
            
        default:
            return nil
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView {
        case countryCodePickerView:
            var infosCountryCode: [String] = []
            let _ = kkOfficesInfos.map { info in
                infosCountryCode.append(info.country)
            }
            countryCodeTextField.text = infosCountryCode[row]
    
            // After countryCode change, set companyIdentifier to first
            let info = kkOfficesInfos.filter { info in
                return info.country == infosCountryCode[row]
            }.first
            companyIdentifierTextField.text = info?.companyIdentifier.first
            companyIdentifierPickerView.selectRow(0, inComponent: 0, animated: false)
            
        case companyIdentifierPickerView:
            let info = kkOfficesInfos.filter { info in
                return info.country == countryCodeTextField.text
            }.first
            companyIdentifierTextField.text = info?.companyIdentifier[row]
            
        default:
            return
        }
        
    }
    
}
