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
        self.myQRCodeReader.delegate = self
        self.myQRCodeReader.setupCamera(view:self.view)
        //読み込めるカメラ範囲
        self.myQRCodeReader.readRange()
    }
}

extension ViewController: AVCaptureMetadataOutputObjectsDelegate{
    //対象を認識、読み込んだ時に呼ばれる
    func metadataOutput(_ output: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from connection: AVCaptureConnection) {
        //一画面上に複数のQRがある場合、複数読み込むが今回は便宜的に先頭のオブジェクトを処理
        if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject{
            let barCode = self.myQRCodeReader.previewLayer.transformedMetadataObject(for: metadata) as! AVMetadataMachineReadableCodeObject
            //読み込んだQRを映像上で枠を囲む。ユーザへの通知。必要な時は記述しなくてよい。
            self.myQRCodeReader.qrView.frame = barCode.bounds
            //QRデータを表示
            if let str = metadata.stringValue {
                print(str)
                let alert = UIAlertController(title: "スキャン完了",
                                              message: str,
                                              preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            }
        }
    }
}
