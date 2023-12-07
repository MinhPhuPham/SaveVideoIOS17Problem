//
//  MediaHelper.swift
//  SaveVideoProblem
//
//  Created by Phu Pham on 07/12/2023.
//

import SwiftUI
import Photos

class MediaHelper: NSObject {
    func downloadVideoToAlbum(videoURL: URL) {
        doVertifyAccessAblum() {
            DispatchQueue.global(qos: .background).async {
                if let urlData = NSData(contentsOf: videoURL) {
                    let galleryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0];
                    let filePath="\(galleryPath)/\(videoURL.lastPathComponent).mp4"
                    
                    DispatchQueue.main.async {
                        urlData.write(toFile: filePath, atomically: true)

                        PHPhotoLibrary.shared().performChanges({
                            let changeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: URL(fileURLWithPath: filePath))
                            changeRequest?.creationDate = Date()
                        }) { success, error in
                            print("Save video with status: success=\(success) error=\(String(describing: error))")
                        }
                    }
                }
            }
        }
    }
    
    private func doVertifyAccessAblum(completion: @escaping () -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                completion()
            } else {
                let alertVC = UIAlertController(title: "Allow to access Photos", message: "Go setting and set permission", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Go Settings", style: .default) { (action: UIAlertAction) in
                    if let url = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
                alertVC.addAction(okAction)
                
                UIApplication.shared.windows.first?.rootViewController?.present(alertVC, animated: true, completion: nil)
            }
        }
    }
}
