//
//  AudioItem.swift
//  ChatKit
//
//  Created by John on 2019/10/24.
//  Copyright © 2019 ChatKit. All rights reserved.
//

import class AVFoundation.AVAudioPlayer

/// A protocol used to represent the data for an audio message.
public protocol AudioItem {
    /// The url where the audio file is located.
    var url: URL { get }
    /// The audio file duration in seconds.
    var duration: Float { get }
    /// The size of the audio item.
    var size: CGSize { get }
    /// 音频播放按钮
    var audioPlayImage: UIImage? { get }
    /// 音频暂停按钮
    var audioPauseImage: UIImage? { get }
}
