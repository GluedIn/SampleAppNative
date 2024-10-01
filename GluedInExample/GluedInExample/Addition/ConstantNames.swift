//
//  ConstantNames.swift
//  GluedInExample
//
//  Created by Ashish Verma on 10/09/24.
//

import Foundation

enum StoryBoards: String {
    case SignIn             = "SignInStoryboard"
    case SignUp             = "SignUpStoryboard"
    case TabBar             = "TabBarStoryboard"
    
    var localizedString: String {
        return NSLocalizedString(rawValue, comment: "")
    }
}
