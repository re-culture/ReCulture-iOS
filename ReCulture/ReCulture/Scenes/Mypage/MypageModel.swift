//
//  MypageModel.swift
//  ReCulture
//
//  Created by Jini on 6/13/24.
//

struct FollowModel {
    let id: Int
    let followerID: Int
    let followingID: Int
    let createdAt: String
    let follower: UserModel
    let following: UserModel
    
    struct UserModel {
        let id: Int
        let email: String
        let createdAt: String
    }

}

struct FollowStateModel {
    let id: Int
    let fromUserID: Int
    let toUserID: Int
    let status: String
    let createdAt: String
    let updatedAt: String
}
