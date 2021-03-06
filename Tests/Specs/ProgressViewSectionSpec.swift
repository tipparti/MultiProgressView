//
//  ProgressViewSectionSpec.swift
//  MultiProgressView_Tests
//
//  Created by Mac Gallagher on 12/26/18.
//  Copyright © 2018 Mac Gallagher. All rights reserved.
//

import Quick
import Nimble

@testable import MultiProgressView

class ProgressViewSectionSpec: QuickSpec {
    
    override func spec() {
        
        describe("ProgressViewSection") {
            var mockLayoutCalculator: MockLayoutCalculator!
            var subject: TestableProgressViewSection!
            
            beforeEach {
                mockLayoutCalculator = MockLayoutCalculator()
                subject = TestableProgressViewSection(layoutCalculator: mockLayoutCalculator)
            }
            
            //MARK: - Initialization
            
            describe("initialization") {
                var section: ProgressViewSection!
                
                context("when initializing a new section with the default initializer") {
                    
                    beforeEach {
                        section = ProgressViewSection()
                    }
                    
                    testInitialProperties()
                }
                
                context("when initializing a new section with the required initializer") {
                    
                    beforeEach {
                        //TODO: - Find a non-deprecated way to accomplish this
                        let coder = NSKeyedUnarchiver(forReadingWith: Data())
                        section = ProgressViewSection(coder: coder)
                    }
                    
                    testInitialProperties()
                }
                
                func testInitialProperties() {
                    
                    it("should have a title label") {
                        expect(section.titleLabel).toNot(beNil())
                    }
                    
                    it("should have title edge insets equal to zero") {
                        expect(section.titleEdgeInsets).to(equal(.zero))
                    }
                    
                    it("should have a center title alignment") {
                        expect(section.titleAlignment).to(equal(.center))
                    }
                    
                    it("should have an image view") {
                        expect(section.imageView).toNot(beNil())
                    }
                    
                    it("should have a black background color") {
                        expect(section.backgroundColor).to(equal(.black))
                    }
                    
                    it("should have it's layer mask to bounds") {
                        expect(section.layer.masksToBounds).to(beTrue())
                    }
                    
                    it("should have it's imageView as a subview") {
                        expect(section.subviews.contains(section.imageView)).to(beTrue())
                    }
                    
                    it("should have it's titleLabel as a subview") {
                        expect(section.subviews.contains(section.titleLabel)).to(beTrue())
                    }
                }
            }
            
            //MARK: - Title Insets
            
            describe("title insets") {
                
                context("when setting the title insets") {
                    
                    beforeEach {
                        subject.titleEdgeInsets = UIEdgeInsets()
                    }
                    
                    it("should trigger a layout update") {
                        expect(subject.setNeedsLayoutCalled).to(beTrue())
                    }
                }
            }
            
            //MARK: - Title Alignment
            
            describe("title alignment") {
                
                context("when setting the title alignment") {
                    
                    beforeEach {
                        subject.titleAlignment = .bottom
                    }
                    
                    it("should trigger a layout update") {
                        expect(subject.setNeedsLayoutCalled).to(beTrue())
                    }
                }
            }
            
            //MARK: - Layout
            
            describe("layout") {
                
                context("when calling the layoutSubviews method") {
                    let titleAlignment: AlignmentType = .topLeft
                    let titleEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 1, left: 2, bottom: 3, right: 4)
                    let labelConstraints: [NSLayoutConstraint] = [NSLayoutConstraint]()
                    let imageViewFrame: CGRect = CGRect(x: 1, y: 2, width: 3, height: 4)
                    
                    beforeEach {
                        mockLayoutCalculator.testAnchorConstraints = labelConstraints
                        mockLayoutCalculator.testSectionImageViewFrame = imageViewFrame
                        subject.titleAlignment = titleAlignment
                        subject.titleEdgeInsets = titleEdgeInsets
                        subject.layoutSubviews()
                    }
                    
                    it("should correctly set the title label's constraints") {
                        expect(subject.labelConstraints).to(be(labelConstraints))
                        expect(mockLayoutCalculator.anchorToSuperviewAlignment).to(equal(titleAlignment))
                        expect(mockLayoutCalculator.anchorToSuperviewInsets).to(equal(titleEdgeInsets))
                    }
                    
                    it("should correctly set the imageView's frame") {
                        expect(subject.imageView.frame).to(equal(imageViewFrame))
                    }
                    
                    it("should send the the imageView to the back of the view hierarchy") {
                        expect(subject.sendSubviewToBackView).to(be(subject.imageView))
                    }
                }
            }
            
            //MARK: - Setter Methods
            
            describe("setter methods") {
                
                context("when calling the setTitle method") {
                    let title: String = "title"
                    
                    beforeEach {
                        subject.setTitle(title)
                    }
                    
                    it("should set the titleLabel's title") {
                        expect(subject.titleLabel.text).to(equal(title))
                    }
                }
                
                context("when calling the setAttributedTitle method") {
                    let attributedTitle: NSAttributedString = NSAttributedString(string: "title")
                    
                    beforeEach {
                        subject.setAttributedTitle(attributedTitle)
                    }
                    
                    it("should set the titleLabel's attributed title") {
                        expect(subject.titleLabel.attributedText).to(equal(attributedTitle))
                    }
                }
                
                context("when calling the setImage method") {
                    let image: UIImage = UIImage()
                    
                    beforeEach {
                        subject.setImage(image)
                    }
                    
                    it("should set the imageView's image") {
                        expect(subject.imageView.image).to(equal(image))
                    }
                }
            }
        }
    }
}
