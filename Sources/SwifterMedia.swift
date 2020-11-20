//
//  SwifterMedia.swift
//  Swifter
//
//  Created by Takuto Nakamura on 2020/07/25.
//  Copyright © 2020 Matt Donnelly. All rights reserved.
//

import Foundation

public enum MediaType: String {
    case png = "image/png"
    case jpeg = "image/jpeg"
    case gif = "image/gif"
    case mov = "video/mov"
    case mp4 = "video/mp4"
}

public enum MediaCategory: String {
    case gif = "tweet_gif"
    case video = "tweet_video"
}

/**
Uploading media
INIT -> APPEND 🔄 -> FINALIZE (if async response -> STATUS 🔄)

See:
- https://developer.twitter.com/en/docs/media/upload-media/uploading-media/media-best-practices
- https://developer.twitter.com/en/docs/media/upload-media/api-reference/post-media-upload-init
- https://developer.twitter.com/en/docs/media/upload-media/api-reference/post-media-upload-append
- https://developer.twitter.com/en/docs/media/upload-media/api-reference/post-media-upload-finalize
- https://developer.twitter.com/en/docs/media/upload-media/api-reference/get-media-upload-status
*/
public extension Swifter {

    internal func prepareUpload(data: Data, type: MediaType, category: MediaCategory, success: DataSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "media/upload.json"
        let parameters: [String : Any] = ["command": "INIT",
                                          "total_bytes": data.count,
                                          "media_type": type.rawValue,
                                          "media_category": category.rawValue]
        self.postJSON(path: path, baseURL: .upload, parameters: parameters, success: success, failure: failure)
    }

    internal func appendUpload(_ mediaId: String, data: Data, name: String? = nil, index: Int = 0, success: DataSuccessHandler? = nil, failure: FailureHandler? = nil) {
        let path = "media/upload.json"
        let chunkSize: Int = 2 * 1024 * 1024
        let location = index * chunkSize
        let length: Int = (data.count < chunkSize) ? data.count : min(data.count - location, chunkSize)
        let range: Range<Data.Index> = (location ..< location + length)
        let subData = data.subdata(in: range)
        let parameters : [String : Any] = ["command": "APPEND",
                                           "media_id": mediaId,
                                           "segment_index": index,
                                           Swifter.DataParameters.dataKey: "media",
                                           Swifter.DataParameters.fileNameKey: name ?? "Swifter.media",
                                           "media": subData]
        self.jsonRequest(path: path, baseURL: .upload, method: .POST, parameters: parameters, success: { (json, response) in
            let next = index + 1
            if data.count < next * chunkSize {
                success?(json, response)
            } else {
                self.appendUpload(mediaId, data: data, name: name, index: next, success: success, failure: failure)
            }
        }, failure: failure)
    }

    internal func finalizeUpload(mediaId: String, success: DataSuccessHandler? = nil, failure: FailureHandler? = nil) {
        assertionFailure("finalizeUpload not supported")
    }

    private func statusUpload(mediaId: String, success: DataSuccessHandler? = nil, failure: FailureHandler? = nil) {
        assertionFailure("statusUpload not supported")
    }

    private func statusCheck(processingInfo: [String: JSON],
                             json: JSON,
                             response: HTTPURLResponse,
                             mediaId: String,
                             success: DataSuccessHandler? = nil,
                             failure: FailureHandler? = nil) {
        assertionFailure("statusCheck not supported")
    }

}
