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
            v.addSubview(qrView)
        }
    }
    
    //読み取り範囲の指定
    public func readRange(frame: CGRect = CGRect(x: 0.2,
                                                 y: 0.3,
                                                 width: 0.6,
                                                 height: 0.4)) {
        
        self.metadataOutput.rectOfInterest = CGRect(x: frame.minY,
                                                    y: 1 - frame.minX - frame.size.width,
                                                    width: frame.size.height,
                                                    height: frame.size.width)
        
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.red.cgColor
        if let preview = self.preview {
            view.frame = CGRect(x: preview.frame.size.width * frame.minX,
                                y:  preview.frame.size.height * frame.minY,
                                width: preview.frame.size.width * frame.size.width,
                                height: preview.frame.size.height * frame.size.height)
            preview.addSubview(view)
        }
    }
    
    // オブジェクトを読み込んだ時のdelegate AVCaptureMetadataOutputObjectsDelegate.metadataOutput
    func delegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate) {
        self.metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
    }
}
