//
//  LUTRender.swift
//  Kontax Cam
//
//  Created by Kevin Laminto on 1/7/20.
//  Copyright © 2020 Kevin Laminto. All rights reserved.
//

import CoreMedia
import CoreVideo
import CoreImage

// Modified from AVCAMFilter by Apple
// https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/avcamfilter_applying_filters_to_a_capture_stream
class LUTRender: FilterRenderer {
    var filterName: FilterName
    var isPrepared = false
    
    private let lutImageFilter = LUTImageFilter()
    
    private var ciContext = CIContext()
    private var filter: CIFilter?
    private var outputColorSpace: CGColorSpace?
    private var outputPixelBufferPool: CVPixelBufferPool?
    private(set) var outputFormatDescription: CMFormatDescription?
    private(set) var inputFormatDescription: CMFormatDescription?
    
    init(filterName: FilterName = .a1) {
        self.filterName = filterName
    }
    
    // MARK: - Protocol methods
    func prepare(with formatDescription: CMFormatDescription, outputRetainedBufferCountHint: Int) {
        reset()
        
        (outputPixelBufferPool,
         outputColorSpace,
         outputFormatDescription) = allocateOutputBufferPool(with: formatDescription, outputRetainedBufferCountHint: outputRetainedBufferCountHint)
        
        if outputPixelBufferPool == nil { return }
        
        inputFormatDescription = formatDescription
        filter = lutImageFilter.convertToCIFilter(withName: filterName)
        
        isPrepared = true
    }
    
    func render(pixelBuffer: CVPixelBuffer) -> CVPixelBuffer? {
        guard let filter = filter, isPrepared else {
            assertionFailure("Invalid state: Not prepared.")
            return nil
        }
        
        let sourceImage = CIImage(cvImageBuffer: pixelBuffer)
        filter.setValue(sourceImage, forKey: kCIInputImageKey)
        
        guard let filteredImage = filter.value(forKey: kCIOutputImageKey) as? CIImage else {
            print("CIFilter failed to render image")
            return nil
        }
        
        var pbuf: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(kCFAllocatorDefault, outputPixelBufferPool!, &pbuf)
        guard let outputPixelBuffer = pbuf else {
            print("Allocation failure")
            return nil
        }
        
        // Render the filtered image out to a pixel buffer (no locking needed, as CIContext's render method will do that)
        ciContext.render(filteredImage, to: outputPixelBuffer, bounds: filteredImage.extent, colorSpace: outputColorSpace)
        return outputPixelBuffer
    }
    
    func reset() {
        filter = nil
        outputColorSpace = nil
        outputPixelBufferPool = nil
        outputFormatDescription = nil
        inputFormatDescription = nil
        isPrepared = false
    }
}
