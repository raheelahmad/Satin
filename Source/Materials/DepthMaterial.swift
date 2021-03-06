//
//  DepthMaterial.swift
//  Satin
//
//  Created by Reza Ali on 6/24/20.
//

import Metal
import simd

open class DepthMaterial: Material {
    var invert = BoolParameter("Invert", .toggle)
    var color = BoolParameter("Color", .toggle)
    var near = FloatParameter("Near", -1, .inputfield)
    var far = FloatParameter("Far", -1, .inputfield)
    
    public init(_ color: Bool = true, _ invert: Bool = false) {
        super.init()
        self.color.value = color
        self.invert.value = invert
        parameters.append(self.near)
        parameters.append(self.far)
        parameters.append(self.invert)
        parameters.append(self.color)        
    }
        
    open override func compileSource() -> String? {
        return DepthPipelineSource.setup(label: label, parameters: parameters)
    }
}

class DepthPipelineSource {
    static let shared = DepthPipelineSource()
    private static var sharedSource: String?

    class func setup(label: String, parameters: ParameterGroup) -> String? {
        guard DepthPipelineSource.sharedSource == nil else { return sharedSource }
        do {
            if let source = try compilePipelineSource(label, parameters) {
                DepthPipelineSource.sharedSource = source
            }
        }
        catch {
            print(error)
        }
        return sharedSource
    }
}
