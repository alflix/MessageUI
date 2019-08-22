//
//  PhotoPickerHelper.swift
//  GGUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit

public typealias PhotoPickerBlock = (_ selectImage: UIImage?) -> Void

public class PhotoPickerHelper: NSObject {
    public static let share = PhotoPickerHelper()

    private var completionBlock: PhotoPickerBlock?
    private var allowsEditing: Bool = false
    private lazy var imagePicker = UIImagePickerController()

    /// 打开相册
    ///
    /// - Parameters:
    ///   - controller: 用于 present 的控制器
    ///   - sourceType: 相册类型
    ///   - allowsEditing: 是否进行裁剪，默认 false
    ///     true 的话，由于使用系统自带的会有 bug，使用自定义的 ImageCropperViewController, 可以通过 ImageCropperConfig.shared 进行配置
    ///   - completionHandler: 完成
    public func presentImagePicker(byController controller: UIViewController,
                                   sourceType: UIImagePickerController.SourceType = .photoLibrary,
                                   allowsEditing: Bool = false,
                                   completionHandler: PhotoPickerBlock? = nil) {
        self.allowsEditing = allowsEditing
        completionBlock = completionHandler
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeLow
        imagePicker.delegate = self
        // 直接使用 imagePicker.allowsEditing， 遇到有透明通道的图片会显示错误（页面空白） 
        // viewServiceDidTerminateWithError:: Error Domain=_UIViewServiceInterfaceErrorDomain Code=3 "(null)" UserInfo={Message=Service Connection Interrupted
        // imagePicker.allowsEditing = true                
        controller.present(imagePicker, animated: true, completion: nil)
    }
}

extension PhotoPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionBlock?(nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let pickImage = info[.originalImage] as? UIImage else { return }
        if allowsEditing {
            let cropperViewController = ImageCropperViewController()
            cropperViewController.imageToCrop = pickImage
            cropperViewController.delegate = self
            picker.present(cropperViewController, animated: true, completion: nil)
            return
        }
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionBlock?(pickImage)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionBlock?(image)
    }
}

extension PhotoPickerHelper: ImageCropperViewControllerDelegate {
    public func cancelImageCropper(imageCropperViewController: ImageCropperViewController) {
        imageCropperViewController.dismiss(animated: true, completion: nil)
    }

    public func handleCroppedImage(imageCropperViewController: ImageCropperViewController, image: UIImage) {
        imagePicker.presentingViewController?.dismiss(animated: true, completion: nil)
        completionBlock?(image)
    }
}

extension UIImagePickerController {
    open override var childForStatusBarHidden: UIViewController? {
        return nil
    }

    open override var prefersStatusBarHidden: Bool {
        return true
    }
}
