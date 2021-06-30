//
//  TwilioViewControllerVoiceExtension.swift
//  KKdayPortal
//
//  Created by KKday on 2021/6/30.
//  Copyright © 2021 WEI-TSUNG CHENG. All rights reserved.
//

// 📳 => TwilioVoice
// ☎️ => CallKit
// 📻 => AVFoundation
// 〽️ => PushKit

// 🍕 => set delegate

import UIKit
import Foundation

import CallKit
import AVFoundation
import TwilioVoice
import PushKit


// MARK: AudioSession
extension TwilioServiceViewController {
    func toggleAudioRoute(toSpeaker: Bool) {
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
    func playRingback() {
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
    
    func stopRingback() {
        guard let ringtonePlayer = ringtonePlayer, ringtonePlayer.isPlaying else { return }
        
        ringtonePlayer.stop()
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
                                      self.twimlParamCompanyIdentifier: self.companyIdentifierTextField.text ?? "",
                                      self.twimlParamCountryCode: info?.countryCode ?? ""
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
