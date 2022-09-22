//
//  PhotoLibrary.swift
//  Roll Time
//
//  Created by Akif Demirezen on 21.06.2022.
//

import UIKit
import Photos

public extension PHPhotoLibrary {
    static func execute(controller: UIViewController,
                        onAccessHasBeenGranted: @escaping () -> Void,
                        onAccessHasBeenDenied: (() -> Void)? = nil) {
        
        let onDeniedOrRestricted = onAccessHasBeenDenied ?? {
            let alert = UIAlertController(
                title: "We were unable to load your album groups. Sorry!",
                message: "You can enable access in Privacy Settings",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { _ in
                if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settingsURL)
                }
            }))
            controller.present(alert, animated: true)
        }
        
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAccessHasBeenGranted)
        case .denied, .restricted:
            onDeniedOrRestricted()
        case .authorized:
            onAccessHasBeenGranted()
        case .limited:
            onAccessHasBeenGranted()
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
        
    }
    
    public func getStatusPermission(_ onStatus: @escaping ((PHAuthorizationStatus)->Void)) {
        PHPhotoLibrary.requestAuthorization({ status in
            switch status {
            case .notDetermined:
                onStatus(PHAuthorizationStatus.notDetermined)
            case .denied, .restricted:
                onStatus(PHAuthorizationStatus.denied)
            case .authorized:
                onStatus(PHAuthorizationStatus.authorized)
            case .limited:
                onStatus(PHAuthorizationStatus.authorized)
            @unknown default:
                fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
            }
        })
    }
}

private func onNotDetermined(_ onDeniedOrRestricted: @escaping (()->Void), _ onAuthorized: @escaping (()->Void)) {
    
    
    PHPhotoLibrary.requestAuthorization({ status in
        switch status {
        case .notDetermined:
            onNotDetermined(onDeniedOrRestricted, onAuthorized)
        case .denied, .restricted:
            onDeniedOrRestricted()
        case .authorized:
            onAuthorized()
        case .limited:
            onAuthorized()
        @unknown default:
            fatalError("PHPhotoLibrary::execute - \"Unknown case\"")
        }
    })
    
    
}
