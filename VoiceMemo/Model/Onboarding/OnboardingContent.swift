//
//  OnboardingContent.swift
//  VoiceMemo
//
//  Created by geonhui Yu on 10/16/23.
//

import Foundation

struct OnboardingContent: Hashable { // 추후에 탭뷰에서도 사용할 예정이기 때문에
    
    var imageFileName: String
    var title: String
    var subTitle: String
    
    init(imageFileName: String, title: String, subTitle: String) {
        self.imageFileName = imageFileName
        self.title = title
        self.subTitle = subTitle
    }
}
