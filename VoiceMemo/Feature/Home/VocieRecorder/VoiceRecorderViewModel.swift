//
//  VoiceRecorderViewModel.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/18/23.
//

import Foundation
import AVFoundation

final class VoiceRecorderViewModel: NSObject, AVAudioPlayerDelegate, ObservableObject {
    
    @Published var isDisplayRemoveVoiceReocrderAlert: Bool
    @Published var isDisplayAlert: Bool
    @Published var errorAlertMessage: String
    
    // 음성메모 녹음 관련 프로퍼티
    var audioRecorder: AVAudioRecorder?
    @Published var isRecording: Bool
    
    // 음성메모 재생 관련 프로퍼티
    var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool
    @Published var isPaused: Bool
    @Published var playedTime: TimeInterval
    private var progressTimer: Timer?
    
    // 음성메모된 파일
    var recordedFiles: [URL]
    
    // 현재 선택된 음성메모 파일
    @Published var selectedRecoredFile: URL?
    
    init(
        isDisplayRemoveVoiceReocrderAlert: Bool = false,
        isDisplayAlert: Bool = false,
        errorAlertMessage: String = "",
        isRecording: Bool = false,
        isPlaying: Bool  = false,
        isPaused: Bool  = false,
        playedTime: TimeInterval = 0,
        recordedFiles: [URL] = [],
        selectedRecoredFile: URL? = nil) {
        self.isDisplayRemoveVoiceReocrderAlert = isDisplayRemoveVoiceReocrderAlert
        self.isDisplayAlert = isDisplayAlert
        self.errorAlertMessage = errorAlertMessage
        self.isRecording = isRecording
        self.isPlaying = isPlaying
        self.isPaused = isPaused
        self.playedTime = playedTime
        self.recordedFiles = recordedFiles
        self.selectedRecoredFile = selectedRecoredFile
    }
}

// 뷰에서 일어날 수 있는 로직
extension VoiceRecorderViewModel {
    
    func voiceRecordCellTapped(_ recordedFile: URL) {
        
        if selectedRecoredFile != recordedFile {
            // TODO: - 재생정리 메서드 호출
            stopPlaying()
            selectedRecoredFile = recordedFile
        }
    }
    
    func removeBtnTapped() {
        // TODO: - 삭제 얼럿 노출을 위한 상태 변경 메서드 호출
        setIsDisplayRemoveVoiceRecorderAlert(true)
    }
    
    func removeSelectedVocieRecord() {
        
        guard let fileToRemove = selectedRecoredFile,
              let indexToRemove = recordedFiles.firstIndex(of: fileToRemove) else {
            // TODO: - 선택된 음성 메모를 찾을 수 없다는 에러 노출
            displayAlert("선택된 음성메모 파일을 찾을 수 없습니다.")
            
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileToRemove)
            recordedFiles.remove(at: indexToRemove)
            selectedRecoredFile = nil
            
            // TODO: - 재생 정리 메서드 호출
            stopPlaying()
            
            // TODO: - 삭제 성공 얼럿 노출
            displayAlert("선택된 음성메모 파일을 성공적으로 삭제했습니다.")
            
            
        } catch {
            // TODO: - 삭제 실패 오류 얼럿 노출
            displayAlert("선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
        }
    }
    
    private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
        isDisplayRemoveVoiceReocrderAlert = isDisplay
    }
    
    private func setErrorAlertMessage(_ message: String) {
        errorAlertMessage = message
    }
    
    private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
        isDisplayAlert = isDisplay
    }
    
    private func displayAlert(_ message: String) {
        setErrorAlertMessage(message)
        setIsDisplayErrorAlert(true)
    }
}

// MARK: - 음성메모 녹음
extension VoiceRecorderViewModel {
    
    func recordBtnTapped() {
        selectedRecoredFile = nil
        
        if isPlaying {
            // TODO: - 재생 정지 메서드 호출
            stopPlaying()
            
            // TODO: - 녹음 시작 메서드 호출
            startRecording()
            
        } else if isRecording {
            
            // TODO: - 녹음 정지 메서드 호출
            stopRecording()
            
        } else {
            // TODO: - 녹음 시작 메서드 호출
            startRecording()
        }
    }
    
    private func startRecording() {
        let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            
            self.isRecording = true
        } catch {
            displayAlert("음성메모 녹음 중 오류가 발생했습니다.")
        }
    }
    
    private func stopRecording() {
        
        audioRecorder?.stop()
        self.recordedFiles.append(self.audioRecorder!.url)
        
        self.isRecording = false
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

// MARK: - 음성메모 재생
extension VoiceRecorderViewModel {
    
    func startPlaying(recordingURL: URL) {
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            
            self.isPlaying = true
            self.isPaused = false
            self.progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                // TODO: - 현재 시간 업데이트 메서드 호출
                self.updateCurrentTime()
            }
        } catch {
            displayAlert("음성메모 재생 중 오류가 발생했습니다.")
        }
    }
    
    private func updateCurrentTime() {
        self.playedTime = audioPlayer?.currentTime ?? 0
    }
    
    private func stopPlaying() {
        audioPlayer?.stop()
        playedTime = 0
        self.progressTimer?.invalidate()
        self.isPlaying = false
        self.isPaused = false
    }
    
    func pausePlaying() {
        audioPlayer?.pause()
        self.isPaused = true
    }
    
    func resumePlaying() {
        audioPlayer?.play()
        self.isPaused = false
    }
    
    // 성공적으로 재생이 끝났을 때
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.isPlaying = false
        self.isPaused = false
    }
    
    func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
        
        let fileManager = FileManager.default
        var creationDate: Date?
        var duration: TimeInterval?
        
        do {
            let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
            creationDate = fileAttributes[.creationDate] as? Date
        } catch {
            displayAlert("선택된 음성메모 파일 정보를 불러올 수 없습니다.")
        }
        
        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: url)
            duration = audioPlayer.duration
        } catch {
            displayAlert("선택된 음성 메모 파일의 재생 시간을 알 수 없습니다.")
        }
        
        return (creationDate, duration)
    }
}
