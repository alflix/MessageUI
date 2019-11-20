//
//  AudioItem.swift
//  Worker
//
//  Created by John on 2019/11/20.
//  Copyright © 2019 Ganguo. All rights reserved.
//

import Foundation

import class AVFoundation.AVAudioPlayer

/// A protocol used to represent the data for an audio message.
public protocol AudioItem {
    /// The url where the audio file is located.
    var url: URL { get }

    /// The audio file duration in seconds.
    var duration: Float { get }

    /// The size of the audio item.
    var size: CGSize { get }
}
