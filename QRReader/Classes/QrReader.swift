import UIKit
import AVFoundation

public class QRReader {
    public init() {}
    
    private let captureSession = AVCaptureSession()
    private let videoDevice = AVCaptureDevice.default(for: .video)
    private var metadataOutput = AVCaptureMetadataOutput()
    
    private var forwardDelegate: AVCaptureMetadataOutputObjectsDelegate?
    private var preview: UIView?
    public var previewLayer = AVCaptureVideoPreviewLayer()
    
    private var QrBorderView = UIView()
    
    private var delegate: AVCaptureMetadataOutputObjectsDelegate? {
        get { self.forwardDelegate }
        set(delegate) {
            self.forwardDelegate = delegate
            self.metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
        }
    }
    
    public func setupCamera(vc: UIViewController,
                            frame: CGRect = CGRect(x: (1.0 - Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25)) / 2,
                                                   y: (1.0 - 0.25) / 2,
                                                   width: Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25),
                                                   height: 0.25)) {
        self.delegate = (vc as! AVCaptureMetadataOutputObjectsDelegate)
        self.preview = vc.view
        
        do {
            let videoInput = try AVCaptureDeviceInput(device: self.videoDevice!) as AVCaptureDeviceInput
            self.captureSession.addInput(videoInput)
        } catch {
            print(error)
        }
        
        self.captureSession.addOutput(self.metadataOutput)
        
        self.metadataOutput.metadataObjectTypes = [.qr]
        
        self.cameraPreview(vc.view)
        
        self.captureSession.startRunning()
        
        self.readRange(frame: frame)
    }
    
    public func stopCamera() {
        self.captureSession.stopRunning()
    }
    
    public func restartCamera(_ frame: CGRect = CGRect(x: (1.0 - Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25)) / 2,
                                                       y: (1.0 - 0.25) / 2,
                                                       width: Double(UIScreen.main.nativeBounds.height / UIScreen.main.nativeBounds.width * 0.25),
                                                       height: 0.25)) {
        self.QrBorderView.removeFromSuperview()
        self.captureSession.startRunning()
        self.readRange(frame: frame)
    }
    
    // 画面に表示
    private func cameraPreview(_ view: UIView) {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.previewLayer.frame = view.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(self.previewLayer)
    }
    
    /// 読み取り範囲の指定
    /// - Parameter frame: 読み取り範囲。初期値0.25
    public func readRange(frame: CGRect) {
        self.metadataOutput.rectOfInterest = CGRect(x: frame.minY,
                                                    y: 1 - frame.minX - frame.size.width,
                                                    width: frame.size.height,
                                                    height: frame.size.width)
        
        if let preview = self.preview {
            self.QrBorderView = QrBorderAroundView(frame: CGRect(x: preview.frame.size.width * frame.minX,
                                                                 y:  preview.frame.size.height * frame.minY,
                                                                 width: preview.frame.size.width * frame.size.width,
                                                                 height: preview.frame.size.height * frame.size.height))
            self.QrBorderView.center = preview.center
            preview.addSubview(self.QrBorderView)
        }
    }
    
    /// QRに追従させる
    /// - Parameter cgRect: ボーダーの大きさ
    public func followingBorder(_ cgRect: CGRect) {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: .curveEaseIn, animations: {
            self.QrBorderView.removeFromSuperview()
            if let preview = self.preview {
                self.QrBorderView = QrBorderAroundView(frame: cgRect)
                self.QrBorderView.frame = cgRect
                preview.addSubview(self.QrBorderView)
            }
        }, completion: nil)
    }
    
    // オブジェクトを読み込んだ時のdelegate AVCaptureMetadataOutputObjectsDelegate.metadataOutput
    func delegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate) {
        self.metadataOutput.setMetadataObjectsDelegate(delegate, queue: .main)
    }
}
