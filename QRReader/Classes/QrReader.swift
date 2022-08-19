import UIKit
import AVFoundation

public class QRReader {
    public init() {}
    
    public let captureSession = AVCaptureSession()
    public let videoDevice = AVCaptureDevice.default(for: .video)
    public var metadataOutput = AVCaptureMetadataOutput()
    
    public var forwardDelegate: AVCaptureMetadataOutputObjectsDelegate?
    public var preview: UIView?
    public var previewLayer = AVCaptureVideoPreviewLayer()
    public let qrView = UIView()
    
    public var delegate: AVCaptureMetadataOutputObjectsDelegate? {
        get { self.forwardDelegate }
        set(delegate) {
            self.forwardDelegate = delegate
            self.metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
        }
    }
    
    public func setupCamera(view: UIView, borderWidth: Int = 2, borderColor: UIColor = .green) {
        
        self.preview = view
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        } catch {
            print(error)
        }
        
        self.captureSession.addOutput(self.metadataOutput)
        
        self.metadataOutput.metadataObjectTypes = [.qr]
        
        self.cameraPreview(view)
        
        self.targetCapture(borderWidth:borderWidth, borderColor: borderColor)
        
        self.captureSession.startRunning()
    }
    
    // 画面に表示
    private func cameraPreview(_ view: UIView) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = view.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(self.previewLayer)
    }
    
    private func targetCapture(borderWidth: Int, borderColor: UIColor) {
        self.qrView.layer.borderWidth = CGFloat(borderWidth)
        self.qrView.layer.borderColor = borderColor.cgColor
        self.qrView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        if let v = self.preview {
            v.addSubview(self.qrView)
        }
    }
    
    // 読み取り範囲の指定
    
    /// 読み取り範囲の指定
    /// - Parameter frame: 読み取り範囲。初期値0.25
    public func readRange(frame: CGRect = CGRect(x: (1.0 - Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25)) / 2,
                                                 y: (1.0 - 0.25) / 2,
                                                 width: Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25),
                                                 height: 0.25)) {
        
        self.metadataOutput.rectOfInterest = CGRect(x: frame.minY,
                                                    y: 1 - frame.minX - frame.size.width,
                                                    width: frame.size.height,
                                                    height: frame.size.width)
        
        let view = UIView()
        if let preview = self.preview {
            
            
            view.frame = CGRect(x: preview.frame.size.width * frame.minX,
                                y:  preview.frame.size.height * frame.minY,
                                width: preview.frame.size.width * frame.size.width,
                                height: preview.frame.size.height * frame.size.height)
            
            preview.addSubview(view)
            
            let dView = DashedBorderAroundView(frame: view.frame)
            dView.center = preview.center
            preview.addSubview(dView)
        }
    }
    
    // オブジェクトを読み込んだ時のdelegate AVCaptureMetadataOutputObjectsDelegate.metadataOutput
    func delegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate) {
        self.metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
    }
}
