//
//  ContentViewModel.swift
//  VideoFeed
//
//  Created by Al-Amin on 2023/06/17.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestoreSwift

class ContentViewModel: ObservableObject {
    @Published var videos = [Video]()
    
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            Task {
                try await uploadVideo()
            }
        }
    }
    
    init() {
        Task {
            try await fetchVideo()
        }
    }
    
    func uploadVideo() async throws {
        guard let item = selectedItem else { return }
        guard let videoData = try await item.loadTransferable(type: Data.self) else { return }
        
        print("DEBUG: Video data is \(videoData)")
        
        guard let videoUrl = try await VideoUploader.uploadVideo(withData: videoData) else { return }
        try await Firestore.firestore().collection("videos").document().setData(["videoUrl" : videoUrl])
        
        print("DEBUG: Finished video upload")
    }
    
    @MainActor
    func fetchVideo() async throws {
        let snapshot = try await Firestore.firestore().collection("videos").getDocuments()
        videos = snapshot.documents.compactMap({ try? $0.data(as: Video.self)})
    }
}
