//
//  TwilioServiceViewController.swift
//  KKdayPortal
//
//  Created by KKday on 2020/12/8.
//  Copyright © 2020 WEI-TSUNG CHENG. All rights reserved.
//

// 📳 => TwilioVoice
// ☎️ => CallKit
// 📻 => AVFoundation
// 〽️ => PushKit

// 🍕 => set delegate

import UIKit
import SnapKit
import CallKit
import AVFoundation
import TwilioVoice
import PushKit
import Foundation

final class TwilioServiceViewController: UIViewController {
    
    // 🏞 UI element
    lazy var qualityWarningsToaster: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = ""
        lbl.textAlignment = .center
        return lbl
    }()
    
//    lazy var transferValue: UITextField = {
//        let txf = UITextField()
//        txf.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        txf.keyboardType = .default
//        txf.borderStyle = .roundedRect
//        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//
//        return txf
//    }()
//
//    lazy var transferCallButton: UIButton = {
//        let btn: UIButton = UIButton()
//        btn.setBackgroundImage(UIImage(systemName: "phone.fill.arrow.up.right") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
//        return btn
//    }()
//
    
    lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "headphones.circle.fill") ?? #imageLiteral(resourceName: "icPicture")
        
        return img
    }()
    
    lazy var countryLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Please select office"
        lbl.textAlignment = .center
        
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
        
        return txf
    }()
    
    lazy var companyIdentifierLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Please input company identifier"
        lbl.textAlignment = .center
        
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
        
        return txf
    }()
    
    lazy var outgoingLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Please input callee number"
        lbl.textAlignment = .center
        
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
        lbl.text = "Mute"
        
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
        lbl.text = "Speaker"
        
        return lbl
    }()
    
    // CallKit
    private var callKitProvider: CXProvider?
    private let callKitCallController = CXCallController()
    private var userInitiatedDisconnect: Bool = false
    
    private var callKitCompletionCallBack: ((Bool) -> Void)? = nil
    
    private let twimlParamTo = "To"
    
    // kp = KKday Portal
    
    private let twimlPlatform = "kp_platform"
    private let twimlPlatformValue = "ios_kkportal"
    
    private let twimlUser: String = "kp_user"
    private let twimlUserValue: String = {
        let user: GeneralUser? = StorageManager.shared.loadObject(for: .generalUser)
        return user?.account ?? "KKUser"
    }()
    
    private let twimlParamCompanyIdentifier = "kp_company_identifier"
    private let twimlParamCountryCode = "kp_country_code"
//    private let twimlParamto = "to"
    
    private let identity: String = "KKPortal"
    
    private var activeCall: Call? = nil
    private var activeCalls: [String: Call] = [:]
    private var activeCallInvites: [String: CallInvite] = [:]
    
    private var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    
    // AVAudio
    private var ringtonePlayer: AVAudioPlayer? = nil
    private var playCustomRingback = true
    
    // Device register Time-to-live(TTL) days
    private static let kRegistrationTTLInDays = 365
    
    // Twilio User Default Key
    private static let kCachedDeviceToken = "CachedDeviceToken"
    private static let kCachedBindingDate = "CachedBindingDate"
    
    private var singleTapGestureRecognizer: UITapGestureRecognizer!
    
    private var accessTokenURL: URL? = nil

    private var kkOfficesInfos: [KKOfficesInfo] = []
    private var viewModel: TwilioServiceViewModel
    
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
        createGestureRecognizer()
        
        // TVOAudioDevice must be set before performing any other actions with the SDK
        TwilioVoiceSDK.audioDevice = audioDevice
    }
    
    deinit {
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
        
        self.view.addSubview(qualityWarningsToaster)
        
        ///
//        self.view.addSubview(transferValue)
//        self.view.addSubview(transferCallButton)
        ///
        
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
        
        ///
//        transferValue.snp.makeConstraints { maker in
//            maker.centerX.equalToSuperview()
//            maker.top.equalTo(qualityWarningsToaster.snp.bottom).offset(5)
//            maker.width.equalTo(240)
//        }
//
//        transferCallButton.snp.makeConstraints { maker in
//            maker.centerX.equalToSuperview()
//            maker.width.height.equalTo(40)
//            maker.top.equalTo(transferValue.snp.bottom).offset(5)
//        }
        
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
    
    private func setAction() {
        ///
//        transferCallButton.addTarget(self, action: #selector(transferButtonPressed), for: .touchUpInside)
        ///
        
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
        // iOS 14 CXProviderConfiguration(localizedName: "Twilio Voice") ->  CXProviderConfiguration()
        let configuration = CXProviderConfiguration(localizedName: "Twilio Voice")
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
    
    @objc private func transferButtonPressed(sender: UIButton) {
        
        
        // print(transferValue.text)
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
    
    private func toggleUIState(isEnabled: Bool, showCallControl: Bool) {
        placeCallButton.isEnabled = isEnabled
        
        if showCallControl {
            callControlView.isHidden = false
            muteSwitch.isOn = false
            speakerSwitch.isOn = true
        } else {
            callControlView.isHidden = true
        }
    }
    
    private func showMicrophoneAccessRequest(_ uuid: UUID, _ handle: String) {
        let alertController = UIAlertController(title: "KKday Voice",
                                                message: "Microphone permission not granted",
                                                preferredStyle: .alert)
        
        let continueWithoutMic = UIAlertAction(title: "Continue without microphone", style: .default) { [weak self] _ in
            self?.performStartCallAction(uuid: uuid, handle: handle)
        }
        
        let goToSettings = UIAlertAction(title: "Settings", style: .default) { _ in
            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!,
                                      options: [UIApplication.OpenExternalURLOptionsKey.universalLinksOnly: false],
                                      completionHandler: nil)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            self?.toggleUIState(isEnabled: true, showCallControl: false)
        }
        
        [continueWithoutMic, goToSettings, cancel].forEach { alertController.addAction($0) }
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: AudioSession
    private func toggleAudioRoute(toSpeaker: Bool) {
        audioDevice.block = {
            
            DefaultAudioDevice.DefaultAVAudioSessionConfigurationBlock()
            do {
                if toSpeaker {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                }
            } catch {
                print("📻⚠️ \(error).localizedDescription")
            }
        }
        
        audioDevice.block()
    }
    
    // MARK: Ringtone
    private func playRingback() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "wav")!)
        
        do {
            ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
            // 🍕 set AVAudioPlayerDelegate to TwilioServiceViewController
            ringtonePlayer?.delegate = self
            ringtonePlayer?.numberOfLoops = -1
            
            ringtonePlayer?.volume = 1.0
            ringtonePlayer?.play()
        } catch {
            print("📻 Failed to initialize audio player")
        }
    }
    
    private func stopRingback() {
        guard let ringtonePlayer = ringtonePlayer, ringtonePlayer.isPlaying else { return }
        
        ringtonePlayer.stop()
    }
}


// MARK: - CXProviderDelegate
extension TwilioServiceViewController: CXProviderDelegate {
    
    // MARK: Delegate funcitons
    func providerDidReset(_ provider: CXProvider) {
        print("☎️ providerDidReset:")
        audioDevice.isEnabled = false
    }
    
    func providerDidBegin(_ provider: CXProvider) {
        print("☎️ providerDidBegin")
    }
    
    func provider(_ provider: CXProvider, didActivate audioSession: AVAudioSession) {
        print("☎️ provider:didActivateAudioSession:")
        audioDevice.isEnabled = true
    }
    
    func provider(_ provider: CXProvider, didDeactivate audioSession: AVAudioSession) {
        print("☎️provider:didDeactivateAudioSession:")
        audioDevice.isEnabled = false
    }
    
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        print("☎️provider:timedOutPerformingAction:")
    }
    
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("☎️ provider:performStartCallAction:")
        
        toggleUIState(isEnabled: false, showCallControl: false)
        
        provider.reportOutgoingCall(with: action.callUUID, startedConnectingAt: Date())
        
        performVoiceCall(uuid: action.callUUID, client: "") { success in
            if success {
                print("📳✅ performVoiceCall() successful")
                provider.reportOutgoingCall(with: action.callUUID, connectedAt: Date())
            } else {
                print("📳⚠️ performVoiceCall() failed")
            }
        }
        
        action.fulfill()
        
    }
    
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        print("☎️ provider:performAnswerCallAction:")
        
        performAnswerVoiceCall(uuid: action.callUUID) { success in
            if success {
                print("📳✅ performAnswerVoiceCall() successful")
            } else {
                print("📳⚠️ performAnswerVoiceCall() failed")
            }
        }
        
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        print("☎️ provider:performEndCallAction:")
        
        if let invite = activeCallInvites[action.callUUID.uuidString] {
            invite.reject()
            activeCallInvites.removeValue(forKey: action.callUUID.uuidString)
        } else if let call = activeCalls[action.callUUID.uuidString] {
            call.disconnect()
        } else {
            print("📳⚠️ Unknown UUID to perform end-call action with")
        }
        
        action.fulfill()
    }
    
    // 目前未使用
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        print("☎️ provider:performSetHeldAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
            call.isOnHold = action.isOnHold
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("☎️ provider:performSetMutedAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
            print(action.isMuted)
            call.isMuted = action.isMuted
            action.fulfill()
        } else {
            action.fail()
        }
    }
    
    // MARK: Call Kit Actions
    func performStartCallAction(uuid: UUID, handle: String) {
        guard let provider = callKitProvider else {
            print("☎️⚠️ CallKit provider not available")
            return
        }
        
        let callHandle = CXHandle(type: .generic, value: handle)
        let starCallAction = CXStartCallAction(call: uuid, handle: callHandle)
        let transaction = CXTransaction(action: starCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("☎️⚠️ StartCallAction transaction request failed: \(error.localizedDescription)")
                return
            }
            
            print("☎️✅ StartCallAction transaction request successful")
            
            let callUpdate = CXCallUpdate()
            
            callUpdate.remoteHandle = callHandle
            callUpdate.supportsDTMF = true
            callUpdate.supportsHolding = true
            callUpdate.supportsGrouping = false
            callUpdate.supportsUngrouping = false
            callUpdate.hasVideo = false
            
            provider.reportCall(with: uuid, updated: callUpdate)
            
        }
    }
    
    func reportIncomingCall(from: String, uuid: UUID) {
        guard let provider = callKitProvider else {
            print("☎️⚠️ CallKit provider not available")
            return
        }
        
        let callHandle = CXHandle(type: .generic, value: from)
        let callUpdate = CXCallUpdate()
        
        callUpdate.remoteHandle = callHandle
        callUpdate.supportsDTMF = true
        callUpdate.supportsHolding = true
        callUpdate.supportsGrouping = false
        callUpdate.supportsUngrouping = false
        callUpdate.hasVideo = false
        
        provider.reportNewIncomingCall(with: uuid, update: callUpdate) { error in
            
            if let error = error {
                print("☎️⚠️ Failed to report incoming call successfully: \(error.localizedDescription).")
            } else {
                print("☎️✅ Incoming call successfully reported.")
            }
        }
        
    }
    
    func performEndCallAction(uuid: UUID) {
        let endCallAction = CXEndCallAction(call: uuid)
        let transaction = CXTransaction(action: endCallAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("☎️⚠️ EndCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                print("☎️✅ EndCallAction transaction request successful")
            }
        }
    }
    
    // Mute Action
    func performMuteCallAction(uuid: UUID, muted: Bool) {
        let muteAction = CXSetMutedCallAction(call: uuid, muted: muted)
        let transaction = CXTransaction(action: muteAction)
        
        callKitCallController.request(transaction) { error in
            if let error = error {
                print("☎️⚠️ MuteCallAction transaction request failed: \(error.localizedDescription).")
            } else {
                print("☎️✅ MuteCallAction (muted is \(muted)) transaction request successful")
            }
        }
    }
    
    
    // MARK: Perform Twilio Voice Call
    private func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
        
        guard let url = accessTokenURL else {
            print("❌ No twilio accessToken URL in portal config")
            return
        }
        
        viewModel.loadTwilioAccessToken(url: url, identity: identity) { result in
            
            switch result {
            case .success(let accessToken):
                
                print("📳 Start making a voice call")
                
                let info = self.kkOfficesInfos.filter { info in
                    return info.country == self.countryCodeTextField.text
                }.first
                
                
                let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
                    builder.params = [self.twimlParamTo: self.outgoingTextField.text ?? "",
                                      self.twimlPlatform: self.twimlPlatformValue,
                                      self.twimlUser: self.twimlUserValue,
                                      self.twimlParamCompanyIdentifier: self.companyIdentifierTextField.text ?? "",
                                      self.twimlParamCountryCode: info?.countryCode ?? ""
//                                      ,self.twimlParamto: self.transferValue.text ?? ""
                    ]
                    builder.uuid = uuid
                }
                
                // Connect with Twilio Platform here!
                // 🍕 TVOCallDelegate to TwilioServiceViewController
                let call = TwilioVoiceSDK.connect(options: connectOptions, delegate: self)
                self.activeCall = call
                self.activeCalls[call.uuid!.uuidString] = call
                
                // Pass completionHandler to outside variable callKitCompletionCallBack
                self.callKitCompletionCallBack = completionHandler
                
            case .failure(let error):
                print("❌ Get Twilio AccessToken Error: \(error)")
                
                self.callKitCompletionCallBack = completionHandler
                
            }
        }
        
    }
    
    private func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
        guard let callInvite = activeCallInvites[uuid.uuidString] else {
            print("📳⚠️ No CallInvite matches the UUID")
            return
        }
        
        print("📳 Start answer a voice call")
        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
            builder.uuid = callInvite.uuid
        }
        
        // 🍕 TVOCallDelegate to TwilioServiceViewController
        let call = callInvite.accept(options: acceptOptions, delegate: self)
        activeCall = call
        activeCalls[call.uuid!.uuidString] = call
        callKitCompletionCallBack = completionHandler
        
        activeCallInvites.removeValue(forKey: uuid.uuidString)
        
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


// MARK: - AVAudioPlayerDelegate
extension TwilioServiceViewController: AVAudioPlayerDelegate {
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if flag {
            print("📻✅ Audio player finished playing successfully");
        } else {
            print("📻⚠️ Audio player finished playing with some error");
        }
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let error = error {
            print("📻⚠️ Decode error occurred: \(error.localizedDescription)")
        }
    }
}


// MARK: - Twilio TVOCallDelegate
extension TwilioServiceViewController: CallDelegate {
    
    // MARK: Delegate functions
    func callDidConnect(call: Call) {
        print("📳 CallDidConnect")
        if playCustomRingback {
            stopRingback()
        }
        
        if let completion = callKitCompletionCallBack {
            completion(true)
        }
        
        placeCallButton.setBackgroundImage(UIImage(systemName: "phone.down.fill") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        toggleUIState(isEnabled: true, showCallControl: true)
        
        toggleAudioRoute(toSpeaker: true)
    }
    
    func call(call: Call, isReconnectingWithError error: Error) {
        print("📳 call:isReconnectingWithError:\(error.localizedDescription)")
        placeCallButton.setBackgroundImage(UIImage(systemName: "phone.connection") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        toggleUIState(isEnabled: false, showCallControl: false)
        
    }
    
    func callDidReconnect(call: Call) {
        print("📳 callDidReconnect:")
        placeCallButton.setBackgroundImage(UIImage(systemName: "phone.down.fill") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        toggleUIState(isEnabled: true, showCallControl: true)
    }
    
    
    func callDidFailToConnect(call: Call, error: Error) {
        print("📳⚠️ Call fialed to connect: \(error.localizedDescription)")
        
        if let completion = callKitCompletionCallBack {
            completion(false)
        }
        
        if let provider = callKitProvider {
            // tell CallKit provider call failed
            provider.reportCall(with: call.uuid!, endedAt: Date(), reason: CXCallEndedReason.failed)
        }
        
        callDisconnected(call: call)
    }
    
    func callDidDisconnect(call: Call, error: Error?) {
        if let error = error {
            print("📳⚠️ Call failed: \(error.localizedDescription)")
        } else {
            print("📳 Call did disconnected")
        }
        
        if !userInitiatedDisconnect {
            var reason = CXCallEndedReason.remoteEnded
            
            if error != nil {
                reason = .failed
            }
            
            if let provider = callKitProvider {
                provider.reportCall(with: call.uuid!, endedAt: Date(), reason: reason)
            }
        }
        
        callDisconnected(call: call)
        
    }
    
    func callDidStartRinging(call: Call) {
        print("📳 callDidStartRinging:")
        placeCallButton.setBackgroundImage(UIImage(systemName: "phone.fill.connection") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
        
        if playCustomRingback {
            playRingback()
        }
    }
    
    func callDidReceiveQualityWarnings(call: Call, currentWarnings: Set<NSNumber>, previousWarnings: Set<NSNumber>) {
        var warningsIntersection: Set<NSNumber> = currentWarnings
        warningsIntersection = warningsIntersection.intersection(previousWarnings)
        
        var newWarnings: Set<NSNumber> = currentWarnings
        newWarnings.subtract(warningsIntersection)
        
        if newWarnings.count > 0 {
            qualityWarningsUpdatePopup(newWarnings, isCleared: false)
        }
        
        var clearWarnings: Set<NSNumber> = previousWarnings
        clearWarnings.subtract(warningsIntersection)
        
        if clearWarnings.count > 0 {
            qualityWarningsUpdatePopup(clearWarnings, isCleared: false)
        }
        
    }
    
    // Handle call connect state
    private func callDisconnected(call: Call) {
        if call == activeCall {
            activeCall = nil
        }
        
        activeCalls.removeValue(forKey: call.uuid!.uuidString)
        userInitiatedDisconnect = false
        
        if playCustomRingback {
            stopRingback()
        }
        
        toggleUIState(isEnabled: true, showCallControl: false)
        // set button backgroundImage to origin
        placeCallButton.setBackgroundImage(UIImage(systemName: "phone.fill.arrow.up.right") ?? #imageLiteral(resourceName: "icPicture"), for: .normal)
    }
    
    // Handle quality warnings message (qualityWarningsToaster label)
    private func qualityWarningsUpdatePopup(_ warnings: Set<NSNumber>, isCleared: Bool) {
        var popupMessage: String = "Warnings detected: "
        if isCleared {
            popupMessage = "Warnings cleared: "
        }
        
        let mappedWarnings: [String] = warnings.map { number -> String in
            warningString(Call.QualityWarning(rawValue: number.uintValue)!)
        }
        
        popupMessage += mappedWarnings.joined(separator: ", ")
        
        qualityWarningsToaster.alpha = 0.0
        qualityWarningsToaster.text = popupMessage
        
        UIView.animate(withDuration: 1.0) {
            self.qualityWarningsToaster.isHidden = false
            
            
        } completion: { [weak self] finish in
            guard let strongSelf = self else { return }
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(5)) {
                
                UIView.animate(withDuration: 1.0) {
                    strongSelf.qualityWarningsToaster.alpha = 0.0
                } completion: { finished in
                    strongSelf.qualityWarningsToaster.isHidden = true
                }
            }
        }
    }
    
    private func warningString(_ warning: Call.QualityWarning) -> String {
        switch warning {
        case .highRtt: return "high-rtt"
        case .highJitter: return "high-jitter"
        case .highPacketsLostFraction: return "high-packets-lost-fraction"
        case .lowMos: return "low-mos"
        case .constantAudioInputLevel: return "constant-audio-input-level"
        default: return "Unknown warning"
        }
    }
    
}


// MARK: - PushEventDelegate
extension TwilioServiceViewController: PushKitEventDelegate {
    
    // MARK: Delegate funcitons
    func credentialsUpdated(credentials: PKPushCredentials) {
        guard  (registrationRequired() || UserDefaults.standard.data(forKey: TwilioServiceViewController.kCachedDeviceToken) != credentials.token) else {
            print("📳⚠️ registrationRequired == false")
            return
        }
        
        let cachedDeviceToken = credentials.token
        
        guard let url = accessTokenURL else {
            print("❌ No twilio accessToken URL in portal config")
            return
        }
        
        viewModel.loadTwilioAccessToken(url: url, identity: identity) { result in
            
            switch result {
            case .success(let accessToken):
                
                TwilioVoiceSDK.register(accessToken: accessToken, deviceToken: cachedDeviceToken) { error in
                    if let error = error {
                        print("〽️⚠️ An error occurred while registering: \(error.localizedDescription)")
                    } else {
                        print("〽️✅ Successfully registered for VoIP push notifications.")
                    
                        UserDefaults.standard.set(cachedDeviceToken, forKey: TwilioServiceViewController.kCachedDeviceToken)
                        UserDefaults.standard.set(Date(), forKey: TwilioServiceViewController.kCachedBindingDate)
                    }
                }
                
            case .failure(let error):
                print("❌ Get Twilio AccessToken Error: \(error)")
            }
        }
    }
    
    func credentialsInvalidated() {
        guard let deviceToken = UserDefaults.standard.data(forKey: TwilioServiceViewController.kCachedDeviceToken) else {
            
            print("📳⚠️ No deviceToken in UserDefaults")
            return
        }
        
        guard let url = accessTokenURL else {
            print("❌ No twilio accessToken URL in portal config")
            return
        }
        
        viewModel.loadTwilioAccessToken(url: url, identity: identity) { result in
            
            switch result {
            case .success(let accessToken):
                
                TwilioVoiceSDK.unregister(accessToken: accessToken, deviceToken: deviceToken) { error in
                    if let error = error {
                        print("〽️⚠️ An error occurred while unregistering: \(error.localizedDescription)")
                    } else {
                        print("〽️✅ Successfully unregistered from VoIP push notifications.")
                    }
                }
                
                UserDefaults.standard.removeObject(forKey: TwilioServiceViewController.kCachedDeviceToken)
                UserDefaults.standard.removeObject(forKey: TwilioServiceViewController.kCachedBindingDate)
                
            case .failure(let error):
                print("❌ Get Twilio AccessToken Error: \(error)")
            }
            
        }
        
    }
    
    func incomingPushReceived(payload: PKPushPayload, completion: @escaping () -> Void) {
        // 🍕 NotificationDelegate to TwilioServiceViewController
        
        ///  TEST 進線的會議室
        //        if let payload_dic = payload.dictionaryPayload as? [String: AnyHashable],
        //            var twiParam = payload_dic["twi_params"] as? String {
        //
        //            print(twiParam)
        //
        //            let decipheredIngredients = twiParam.split(separator: "&").reduce(into: [String: String]()) {
        //              let ingredient = $1.split(separator: "=")
        //
        //              if let key = ingredient.first, let value = ingredient.last {
        //                $0[String(key)] = String(value)
        //              }
        //            }
        //
        //            self.outgoingLabel.text = decipheredIngredients["CONF"]
        //
        //        } else {
        //            return
        //        }
        ///
        
        TwilioVoiceSDK.handleNotification(payload.dictionaryPayload, delegate: self, delegateQueue: nil)
        
    }
    
    // MARK: check regisrtration function and push handled function
    private func registrationRequired() -> Bool {
        guard let lastBindCreated = UserDefaults.standard.object(forKey: TwilioServiceViewController.kCachedBindingDate)  else {
            return true
        }
        
        let date = Date()
        var compoents = DateComponents()
        compoents.setValue(TwilioServiceViewController.kRegistrationTTLInDays/2, for: .day)
        let expirationDate = Calendar.current.date(byAdding: compoents, to: lastBindCreated as! Date)!
        if expirationDate.compare(date) == ComparisonResult.orderedDescending {
            return false
        }
        return true
    }
    
}


// MARK: - Twilio NotificationDelegate
extension TwilioServiceViewController: NotificationDelegate {
    
    func callInviteReceived(callInvite: CallInvite) {
        print("📳 kCachedBindingDate")
        
        UserDefaults.standard.set(Date(), forKey: TwilioServiceViewController.kCachedBindingDate)
        
        let callerInfo: TVOCallerInfo = callInvite.callerInfo
        if let verified: NSNumber = callerInfo.verified {
            if verified.boolValue {
                print("📳 Call invite received from verified caller number!")
            }
        }
        
        let form = (callInvite.from ?? "default caller").replacingOccurrences(of: "client:", with: "")
        
        // Report to CallKit
        reportIncomingCall(from: form, uuid: callInvite.uuid)
        activeCallInvites[callInvite.uuid.uuidString] = callInvite
    }
    
    func cancelledCallInviteReceived(cancelledCallInvite: CancelledCallInvite, error: Error) {
        print("📳⚠️ cancelledCallInviteCanceled:error:, error: \(error.localizedDescription)")
        
        guard !activeCallInvites.isEmpty else {
            print("📳⚠️ No pending call invite")
            return
        }
        
        let callInvite = activeCallInvites.values.first { invite -> Bool in
            return invite.callSid == cancelledCallInvite.callSid
        }
        
        if let callInvite = callInvite {
            performEndCallAction(uuid: callInvite.uuid)
        }
        
    }
    
}


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
