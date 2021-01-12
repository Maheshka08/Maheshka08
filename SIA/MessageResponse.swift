//
//  MessageResponse.swift
//  SIA
//
//  Created by Mehera on 10/01/21.
//

import Foundation

struct MessageResponse: Codable {
    var callStatus: String
    var data: [BOTMessages]
}

struct BOTMessages: Codable {
    var siac_id: Int
    var siac_code: String
    var siac_lang: String
    var siac_text: String
    var siac_pid: Int
    var siac_order: Int
    var siac_type: String
    var siac_img_url: String
    var siac_link: String
    var cellType = "RECEIVER"
    var userInteraction = true
}


