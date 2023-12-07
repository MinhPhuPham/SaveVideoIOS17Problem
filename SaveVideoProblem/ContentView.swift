//
//  ContentView.swift
//  SaveVideoProblem
//
//  Created by Phu Pham on 07/12/2023.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @State var isPresentMediaPicker: Bool = false
    
    var body: some View {
        VStack(spacing: 10) {
            if let videoURL = URL(string: "https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4") {
                
                VideoPlayerView(videoURL: videoURL)
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 1.5)
                    .edgesIgnoringSafeArea(.all)
                
                Button(action: {
                    MediaHelper().downloadVideoToAlbum(videoURL: videoURL)
                }) {
                    Text("Save Video")
                }
                .frame(width: 150, height: 50)
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(10)
                
            }
            
            Button(action: {
                isPresentMediaPicker = true
            }) {
                Text("Open Picker")
            }
            .frame(width: 150, height: 50)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            
        }
        .sheet(isPresented: $isPresentMediaPicker) {
            MediaPicker()
        }
    }
}

struct VideoPlayerView: UIViewControllerRepresentable {
    let videoURL: URL

    class Coordinator: NSObject {
        var videoURL: URL
        var player: AVPlayer?
        
        init(videoURL: URL, player: AVPlayer? = nil) {
            self.videoURL = videoURL
            self.player = player
        }
        
        @objc func saveButtonTapped() {
            // Add code to save the video here
            
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(videoURL: videoURL)
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        let playerViewController = AVPlayerViewController()
        playerViewController.player = AVPlayer(url: videoURL)

        let saveButton = Button("Save Video") {
            context.coordinator.saveButtonTapped()
        }


        let buttonView = UIHostingController(rootView: saveButton)

        playerViewController.addChild(buttonView)
        playerViewController.view.addSubview(buttonView.view)

        return playerViewController
    }

    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: Context) {
        // Update the player or perform other updates here
    }
}
