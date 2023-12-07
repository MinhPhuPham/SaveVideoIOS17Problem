//
//  MediaPicker.swift
//  SaveVideoProblem
//
//  Created by Phu Pham on 07/12/2023.
//


import SwiftUI
import PhotosUI

import Photos
import AVFoundation

struct MediaPicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images, .videos])
        configuration.selectionLimit = 1
        // Make load more faster: https://developer.apple.com/forums/thread/652496
        configuration.preferredAssetRepresentationMode = .current
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: MediaPicker
        
        init(parent: MediaPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            print("\(Self.self) \(#function)", results)
            
            if results.isEmpty {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            
            guard let provider = results.first?.itemProvider else {
                return
            }
            
            if provider.canLoadObject(ofClass: UIImage.self) {
                print("\(Self.self) \(#function)", "got image")
                
                provider.loadObject(ofClass: UIImage.self) { image, error in
                    if let image = image as? UIImage {
                        print("image", image)
                    }
                    
                    if let error = error {
                        print("\(Self.self) \(#function)", "Error loading image: \(error.localizedDescription)")
                    }
                }
                
                self.parent.presentationMode.wrappedValue.dismiss()
            } else {
                print("\(Self.self) \(#function)", "got video")
                
                provider.loadFileRepresentation(forTypeIdentifier: "public.movie") { urlResult, error in
                    if let error = error {
                        // Handle errors loading video
                        print("\(Self.self) \(#function)", "Error loading video: \(error.localizedDescription)")
                        return
                    }
                    guard let urlFile = urlResult else {return}
                    // create a new filename
                    let fileName = "\(Int(Date().timeIntervalSince1970)).\(urlFile.pathExtension)"
                    // create new URL
                    let newUrl = URL(fileURLWithPath: NSTemporaryDirectory() + fileName)
                    // copy item to APP Storage
                    try? FileManager.default.copyItem(at: urlFile, to: newUrl)
                
                    print("videoURL", URL(string: newUrl.absoluteString))
                    
                    self.parent.presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

