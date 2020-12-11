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

import UIKit
import SnapKit
import CallKit
import AVFoundation
import TwilioVoice

final class TwilioServiceViewController: UIViewController {
    
    // 🏞 UI element
    
    lazy var qualityWarningsToaster: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Warnings Message"
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var placeCallButton: UIButton = {
        let btn: UIButton = UIButton()
        btn.setBackgroundImage(UIImage(systemName: "phone.fill.arrow.up.right")!, for: .normal)
        
        return btn
    }()
    
    lazy var iconView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "headphones.circle.fill")
        
        return img
    }()
    
    lazy var outgoingValue: UITextField = {
        let txf = UITextField()
        txf.backgroundColor = #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        txf.keyboardType = .namePhonePad
        txf.borderStyle = .roundedRect
        txf.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        return txf
    }()
    
    lazy var outgoingLabel: UILabel = {
        let lbl: UILabel = UILabel()
        lbl.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        lbl.text = "Input Call Information"
        lbl.textAlignment = .center
        return lbl
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
    
    // ODOO Server (for creating accessToken)
    private var baseURLString: String {
        
        //  let url = ConfigManager.shared.model.host
        //  return url
        
        return "https://94195be30686.ngrok.io"
    }
    
    // CallKit
    private var callKitProvider: CXProvider?
    private let callKitCallController = CXCallController()
    private var userInitiatedDisconnect: Bool = false
    
    private var callKitCompletionCallBack: ((Bool) -> Void)? = nil
    
    // TwilioVoice
    private let accessTokenEndpoint = "/accessToken"
    private let identity = "defualt identity"
    private let twimlParamTo = "to"
    
    private var activeCall: Call? = nil
    private var activeCalls: [String: Call] = [:]
    private var activeCallInvites: [String: CallInvite] = [:]
    
    private var audioDevice: DefaultAudioDevice = DefaultAudioDevice()
    // AVAudio
    private var ringtonePlayer: AVAudioPlayer? = nil
    
    //    var myUUID = UUID()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUIElementDelegate()
        setAction()
        setCallKit()
        
        //   reportIncomingCall(from: "Bob", uuid: myUUID)
        //  performStartCallAction(uuid: myUUID, handle: "William Calling")
    }
    
    func fetchAccessToken() -> String? {
        let endpointWithIdentity = String(format: "%@?identity=%@", accessTokenEndpoint, identity)
        
        guard let accessTokenURL = URL(string: baseURLString + endpointWithIdentity) else { return nil }
        
        return try? String(contentsOf: accessTokenURL, encoding: .utf8)
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
    
    
    deinit {
        if let provider = callKitProvider {
            provider.invalidate()
        }
    }
    
    private func setCallKit() {
        // iOS 14 CXProviderConfiguration()
        let configuration = CXProviderConfiguration(localizedName: "Twilio Voice")
        configuration.maximumCallGroups = 1
        configuration.maximumCallsPerCallGroup = 1
        callKitProvider = CXProvider(configuration: configuration)
        if let provider = callKitProvider {
            provider.setDelegate(self, queue: nil)
        }
        
        
        //        let update = CXCallUpdate()
        //        update.remoteHandle = CXHandle(type: .generic, value: "I am calling you!")
        //        callKitProvider!.reportNewIncomingCall(with: UUID(), update: update, completion: { error in })
        //
        
        //
        //        let uuid = UUID()
        //        let update = CXCallUpdate()
        //        let controller = CXCallController()
        //        let action = CXStartCallAction(call: uuid, handle: CXHandle(type: .generic, value: "Calling Someone"))
        //        let transaction = CXTransaction(action: action)
        //
        //        controller.request(transaction) { error in
        //            self.callKitProvider?.reportOutgoingCall(with: uuid, connectedAt: nil)
        //
        //        }
        //
    }
    
    
    private func setupUI() {
        
        self.view.addSubview(qualityWarningsToaster)
        self.view.addSubview(iconView)
        self.view.addSubview(outgoingValue)
        self.view.addSubview(outgoingLabel)
        self.view.addSubview(placeCallButton)
        
        self.view.addSubview(callControlView)
        self.callControlView.addSubview(muteSwitch)
        self.callControlView.addSubview(muteLabel)
        self.callControlView.addSubview(speakerSwitch)
        self.callControlView.addSubview(speakerLabel)
        
        self.view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        qualityWarningsToaster.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.height.equalTo(18)
            maker.top.equalTo(self.view.snp.topMargin).offset(16)
            maker.width.equalTo(self.view.snp.width)
        }
        
        iconView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().offset(-150)
            maker.width.equalTo(240)
            maker.height.equalTo(240)
        }
        
        outgoingValue.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(iconView.snp.bottom).offset(42.5)
            maker.width.equalTo(240)
        }
        
        outgoingLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(outgoingValue.snp.bottom).offset(8)
            maker.width.equalTo(256)
            maker.height.equalTo(40)
        }
        
        placeCallButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.height.equalTo(40)
            maker.top.equalTo(outgoingLabel.snp.bottom).offset(8)
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
        outgoingValue.delegate = self
    }
    
    private func setAction() {
        placeCallButton.addTarget(self, action: #selector(mainButtonPressed), for: .touchUpInside)
        
        muteSwitch.addTarget(self, action: #selector(muteSwitchToggled), for: .valueChanged)
        
        speakerSwitch.addTarget(self, action: #selector(speakerSwitchToggled), for: .valueChanged)
    }
    
    @objc private func mainButtonPressed(sender: UIButton) {
        //        performEndCallAction(uuid: myUUID)
        //        performStartCallAction
        
        guard activeCall == nil else {
            userInitiatedDisconnect = true
            performEndCallAction(uuid: activeCall!.uuid!)
            toggleUIState(isEnabled: false, showCallControl: false)
            
            return
        }
        
        checkRecordPermission { [weak self] permissionGranted in
            let uuid = UUID()
            let handle = "William Call"
            
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
    }
    
    @objc private func speakerSwitchToggled(sender: UISwitch) {
        toggleAudioRoute(toSpeaker: sender.isOn)
    }
    
    // MARK: AudioSession
    func toggleAudioRoute(toSpeaker: Bool) {
        audioDevice.block = {
            do {
                if toSpeaker {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.speaker)
                } else {
                    try AVAudioSession.sharedInstance().overrideOutputAudioPort(.none)
                }
            } catch {
                print("📻⚠️ error.localizedDescription")
            }
        }
    }
    
    // MARK: Ringtone
    private func playRingback() {
        let ringtonePath = URL(fileURLWithPath: Bundle.main.path(forResource: "ringtone", ofType: "wav")!)
        
        do {
            ringtonePlayer = try AVAudioPlayer(contentsOf: ringtonePath)
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
    
    // 目前未使用
    func provider(_ provider: CXProvider, perform action: CXSetMutedCallAction) {
        print("☎️ provider:performSetMutedAction:")
        
        if let call = activeCalls[action.callUUID.uuidString] {
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
    
    // MARK: Twilio Voice Call
    func performVoiceCall(uuid: UUID, client: String?, completionHandler: @escaping (Bool) -> Void) {
        
        guard let accessToken = fetchAccessToken() else {
            completionHandler(false)
            print("📳⚠️ Can't get accessToken")
            return
        }
        
        print("📳 Start making a voice call")
        let connectOptions = ConnectOptions(accessToken: accessToken) { builder in
            builder.params = [self.twimlParamTo: self.outgoingValue.text ?? ""]
            builder.uuid = uuid
        }
        
        // Connect with Twilio Platform here !
        let call = TwilioVoice.connect(options: connectOptions, delegate: self)
        activeCall = call
        activeCalls[call.uuid!.uuidString] = call
        callKitCompletionCallBack = completionHandler
        
    }
    
    func performAnswerVoiceCall(uuid: UUID, completionHandler: @escaping (Bool) -> Void) {
        
        guard let callInvite = activeCallInvites[uuid.uuidString] else {
            print("📳⚠️ No CallInvite matches the UUID")
            return
        }
        
        print("📳 Start answer a voice call")
        let acceptOptions = AcceptOptions(callInvite: callInvite) { builder in
            builder.uuid = callInvite.uuid
        }
        
        let call = callInvite.accept(options: acceptOptions, delegate: self)
        activeCall = call
        activeCalls[call.uuid!.uuidString] = call
        callKitCompletionCallBack = completionHandler
        
        activeCallInvites.removeValue(forKey: uuid.uuidString)
        
    }
}

// MARK: - UITextFieldDelegate
extension TwilioServiceViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        outgoingValue.resignFirstResponder()
        
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

// MARK: - Twilio  TVOCallDelegate
extension TwilioServiceViewController: CallDelegate {
    
    func callDidConnect(call: Call) {
        
    }
    
    func callDidFailToConnect(call: Call, error: Error) {
        
    }
    
    func callDidDisconnect(call: Call, error: Error?) {
        
    }
    
    func callDidStartRinging(call: Call) {
        
    }
}
