//
//  CustomImagePicker.swift
//  FoodManChu
//
//  Created by William Yeung on 3/4/21.
//

import SwiftUI
import Photos

struct CustomImagePicker: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            Text("Pick an image")
                .frame(maxWidth: .infinity, minHeight: UIScreen.main.bounds.height * 0.65)
                .cornerRadius(20)
        }
            .background(Color.black.opacity(0.25))
            .onAppear() {
                PHPhotoLibrary.requestAuthorization { (status) in
                    if status == .authorized {
                        print("get all images from photo lib")
                    } else {
                        print("not allowed")
                    }
                }
            }
    }
    
    func getImagesFromLibrary() {
        let opt = PHFetchOptions()
        opt.includeHiddenAssets = false
        let request = PHAsset.fetchAssets(with: .image, options: .none)
        
        DispatchQueue.global(qos: .background).async {
            let options = PHImageRequestOptions()
            options.isSynchronous = true

            for i in stride(from: 0, to: request.count, by: 3) {
                var iteration = [Images]()
                
                for j in i..<i+3 {
                    if j < request.count {
                        PHCachingImageManager.default().requestImage(for: request[j], targetSize: CGSize(width: 150, height: 150), contentMode: .default, options: options) { (image, _) in
                            if let image = image {
                                let data = Images(image: image, selected: false)
                                iteration.append(data)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct CustomImagePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomImagePicker()
    }
}


struct Images {
    var image: UIImage
    var selected: Bool
}
