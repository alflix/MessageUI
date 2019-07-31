//
//  PhotoPickerHelper.swift
//  GGUI
//
//  Created by John on 2019/5/22.
//  Copyright © 2018 Ganguo. All rights reserved.
//

import UIKit

public class PhotoPickerHelper: NSObject {
    public static let share = PhotoPickerHelper()

    /// 打开相册
    ///
    /// - Parameters:
    ///   - controller: 控制器
    ///   - sourceType: 相册类型
    ///   - allowsEditing: 是否进行裁剪，默认 true
    ///   - completionHandler: 完成
    public func presentImagePicker(byController controller: UIViewController,
                                   sourceType: UIImagePickerController.SourceType = .photoLibrary,
                                   allowsEditing: Bool = true,
                                   completionHandler: @escaping ((UIImagePickerController, UIImage?) -> Void)) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.videoQuality = .typeLow
        imagePicker.delegate = self
        imagePicker.allowsEditing = allowsEditing
        imagePicker.view.tintColor = controller.view.tintColor
        imagePicker.imagePickerCompletionHandlerWrapper = ClosureDecorator(completionHandler)
        controller.present(imagePicker, animated: true, completion: nil)
    }
}

extension PhotoPickerHelper: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, nil))
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        var image: UIImage?
        if picker.allowsEditing {
            image = info[.editedImage] as? UIImage
        } else {
            image = info[.originalImage] as? UIImage
        }
        guard let pickImage = image else { return }
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, pickImage))
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String: AnyObject]?) {
        picker.imagePickerCompletionHandlerWrapper.invoke((picker, image))
        picker.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// ## UIImagePicker
private struct AssociationKey {
    fileprivate static var imagePickerCompletionHandlerWrapper = "com.ganguo.uiimagepickercontroller.imagePickerCompletionHandlerWrapper"
}

private extension UIImagePickerController {
    var imagePickerCompletionHandlerWrapper: ClosureDecorator<(UIImagePickerController, UIImage?)> {
        get {
            return associatedObject(forKey: &AssociationKey.imagePickerCompletionHandlerWrapper) as! ClosureDecorator<(UIImagePickerController, UIImage?)>
        }
        set {
            associate(retainObject: newValue, forKey: &AssociationKey.imagePickerCompletionHandlerWrapper)
        }
    }
}
