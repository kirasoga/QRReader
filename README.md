# QRReader

[![CI Status](https://img.shields.io/travis/KiraSoga/QRReader.svg?style=flat)](https://travis-ci.org/KiraSoga/QRReader)
[![Version](https://img.shields.io/cocoapods/v/QRReader.svg?style=flat)](https://cocoapods.org/pods/QRReader)
[![License](https://img.shields.io/cocoapods/l/QRReader.svg?style=flat)](https://cocoapods.org/pods/QRReader)
[![Platform](https://img.shields.io/cocoapods/p/QRReader.svg?style=flat)](https://cocoapods.org/pods/QRReader)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.
<br>
サンプル プロジェクトを実行するには、リポジトリのクローンを作成し、最初にサンプル ディレクトリから「pod install」を実行します。

## Requirements(要件)
・iOS 13.0
<br>
・Swift 5.0

## Installation(導入方法)

QRReader is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:
<br>
QRReader は [CocoaPods](https://cocoapods.org) から入手できます。インストールするには
Podfile に次の行を追加するだけです。

```ruby
pod 'QRReader'
```

## How to Use(利用方法)
create an instance
<br>
インスタンスを作成する。

```Swift
let myQRCodeReader = QRReader()
```

Show camera screen.Delegate is tied.(You can also set the reading range with frame)

<br>
カメラの画面を表示する。delegateの紐付けがされる。(frameで読み込み範囲の設定もできる)

```Swift
self.myQRCodeReader.setupCamera(vc:self)
```

Processing when the QR code is read
<br>
⚠️please write to extension
<br>
QRコードを読み込んだ時の処理。
<br>
⚠️extensionに書いてください。

```Swift
func metadataOutput(_ output: AVCaptureMetadataOutput,
                    didOutput metadataObjects: [AVMetadataObject],
                    from connection: AVCaptureConnection) {
    if let metadata = metadataObjects.first as? AVMetadataMachineReadableCodeObject {
        guard let barCode = self.myQRCodeReader.previewLayer.transformedMetadataObject(for: metadata),
              let barCode = barCode as? AVMetadataMachineReadableCodeObject else {
            return
        }
        // frame following mode(枠追従モード)
        self.myQRCodeReader.followingBorder(barCode.bounds)
        // stopCamera
        self.myQRCodeReader.stopCamera()
        
        if let str = metadata.stringValue {
              print(str)
        }
    }
}

```

## Author(作成者)

KiraSoga, sogakira0202@gmail.com
<br>
曽我 滉

## License(ライセンス)

QRReader is available under the MIT license. See the LICENSE file for more info.
<br>
QRReader は MIT ライセンスの下で利用できます。詳細については、LICENSE ファイルを参照してください。
