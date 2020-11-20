//
//  SwifterFollowers.swift
//  Swifter
//
//  Copyright (c) 2014 Matt Donnelly.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

public extension Swifter {
    
    /**
    GET    friendships/no_retweets/ids

    Returns a collection of user_ids that the currently authenticated user does not want to receive retweets from. Use POST friendships/update to set the "no retweets" status for a given user account on behalf of the current user.
    */
    func listOfNoRetweetsFriends(success: SuccessHandler? = nil,
										failure: FailureHandler? = nil) {
        let path = "friendships/no_retweets/ids.json"
        let parameters = ["stringigy_ids": true]

        self.getJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in success?(json) }, failure: failure)
    }

    /**
    POST   friendships/create

    Allows the authenticating users to follow the user specified in the ID parameter.

    Returns the befriended user in the requested format when successful. Returns a string describing the failure condition when unsuccessful. If you are already friends with the user a HTTP 403 may be returned, though for performance reasons you may get a 200 OK message even if the friendship already exists.

    Actions taken in this method are asynchronous and changes will be eventually consistent.
    */
    func followUser(_ userTag: UserTag,
                    follow: Bool? = nil,
                    success: SuccessHandler? = nil,
                    failure: FailureHandler? = nil) {
        let path = "friendships/create.json"

        var parameters = [String: Any]()
        parameters[userTag.key] = userTag.value
        parameters["follow"] ??= follow

        self.postJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in
            success?(json)
            }, failure: failure)
    }

    /**
    POST	friendships/destroy

    Allows the authenticating user to unfollow the user specified in the ID parameter.

    Returns the unfollowed user in the requested format when successful. Returns a string describing the failure condition when unsuccessful.

    Actions taken in this method are asynchronous and changes will be eventually consistent.
    */
    func unfollowUser(_ userTag: UserTag,
                      success: SuccessHandler? = nil,
                      failure: FailureHandler? = nil) {
        let path = "friendships/destroy.json"

        var parameters = [String: Any]()
        parameters[userTag.key] = userTag.value

        self.postJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in
            success?(json)
            }, failure: failure)
    }

    /**
    POST	friendships/update

    Allows one to enable or disable retweets and device notifications from the specified user.
    */
    func updateFriendship(with userTag: UserTag,
                          device: Bool? = nil,
                          retweets: Bool? = nil,
                          success: SuccessHandler? = nil,
                          failure: FailureHandler? = nil) {
        let path = "friendships/update.json"

        var parameters = [String: Any]()
        parameters[userTag.key] = userTag.value
        parameters["device"] ??= device
        parameters["retweets"] ??= retweets

        self.postJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in
            success?(json)
            }, failure: failure)
    }

    /**
    GET    friendships/show

    Returns detailed information about the relationship between two arbitrary users.
    */
    func showFriendship(between sourceTag: UserTag,
                        and targetTag: UserTag,
                        success: SuccessHandler? = nil,
                        failure: FailureHandler? = nil) {
        let path = "friendships/show.json"

        var parameters = [String: Any]()
        switch sourceTag {
        case .id:           parameters["source_id"] = sourceTag.value
        case .screenName:   parameters["source_screen_name"] = sourceTag.value
        }
        
        switch targetTag {
        case .id:           parameters["target_id"] = targetTag.value
        case .screenName:   parameters["target_screen_name"] = targetTag.value
        }

        self.getJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in
            success?(json)
            }, failure: failure)
    }

    /**
    GET    friendships/lookup

    Returns the relationships of the authenticating user to the comma-separated list of up to 100 screen_names or user_ids provided. Values for connections can be: following, following_requested, followed_by, none.
    */
    func lookupFriendship(with usersTag: UsersTag,
                          success: SuccessHandler? = nil,
                          failure: FailureHandler? = nil) {
        let path = "friendships/lookup.json"

        var parameters = [String: Any]()
        parameters[usersTag.key] = usersTag.value

        self.getJSON(path: path, baseURL: .api, parameters: parameters, success: { json, _ in            
            success?(json)
            }, failure: failure)
    }
    
}
