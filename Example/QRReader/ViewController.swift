//
//  ViewController.swift
//  QRReader
//
//  Created by KiraSoga on 08/18/2022.
//  Copyright (c) 2022 KiraSoga. All rights reserved.
//

import UIKit
import QRReader
import AVFoundation

class ViewController: UIViewController {
    
    private let myQRCodeReader = QRReader()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myQRCodeReader.setupCamera(vc: self)
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate{
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        //一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
            guard let barCode = self.myQRCodeReader.previewLayer.transformedMetadataObject(for: metadata),
                  let barCode = barCode as? AVMetadataMachineReadableCodeObject else {
                return
            }
            // 枠追従モード
            self.myQRCodeReader.followingBorder(barCode.bounds)
            // スキャン完了時にCameraのスキャンを停止
            self.myQRCodeReader.stopCamera()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                //QRデータを表示
                if let str = metadata.stringValue {
                    print(str)
                    let alert = UIAlertController(title: "スキャン完了",
                                                  message: str,
                                                  preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .default)
                    let restartAction = UIAlertAction(title: "再起動", style: .default, handler: {_ in 
                        self.myQRCodeReader.restartCamera()
                    })
                    alert.addAction(okAction)
                    alert.addAction(restartAction)
                    self.present(alert, animated: true)
                }
            }
        }
    }
}
