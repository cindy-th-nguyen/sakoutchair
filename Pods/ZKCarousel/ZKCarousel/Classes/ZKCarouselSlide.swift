//
//  ZKCarouselSlide.swift
//  ZKCarousel
//
//  Created by Zachary Khan on 8/22/20.
//

public struct ZKCarouselSlide {
    public var image : UIImage?
    public var title : String?
    public var description: String?
    
    public init(image: UIImage?, title: String?, description: String?) {
        self.image = image
        self.title = title
        self.description = description
    }
}