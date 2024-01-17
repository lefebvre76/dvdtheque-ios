//
//  BarcodeScannerView.swift
//  dvdtheque
//
//  Created by loic lefebvre on 16/01/2024.
//

import SwiftUI
import CodeScanner
import AVFoundation

struct BarCodeScannerView: View {
    
    @StateObject var barCodeScannerViewModel = BarCodeScannerViewModel()
    
    var body: some View {
        AuthContainerView(authContainerViewModel: barCodeScannerViewModel) {
            ZStack() {
                CodeScannerView(codeTypes: [.ean13],
                                scanMode: barCodeScannerViewModel.scanMode,
                                shouldVibrateOnSuccess: (!barCodeScannerViewModel.searchInProgress && !barCodeScannerViewModel.showFoundedBox),
                                isTorchOn: barCodeScannerViewModel.isTorchOn,
                                videoCaptureDevice: AVCaptureDevice.default(.builtInTrueDepthCamera, for: AVMediaType.video, position: .back),
                                completion: barCodeScannerViewModel.barCodeFound)
                VStack {
                    HStack() {
                        Spacer()
                        Button(action: {
                            barCodeScannerViewModel.toogleTorch()
                        }, label: {
                            if barCodeScannerViewModel.isTorchOn {
                                Image(systemName: "flashlight.slash.circle")
                                    .font(.system(size: 30))
                                    .padding()
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "flashlight.on.circle")
                                    .font(.system(size: 30))
                                    .padding()
                                    .foregroundColor(.white)
                            }
                        }).background {
                            Color.black
                                .blur(radius: 20, opaque: false)
                                .opacity(0.7)
                        }.padding()
                    }
                    Spacer()
                    HStack() {
                        if barCodeScannerViewModel.searchInProgress {
                            LoadView(font: .body, loaderColor: .black).padding()
                        } else if let message = barCodeScannerViewModel.errorMessage {
                            Text(message).padding().foregroundStyle(.red)
                        } else {
                            Text("scan.instruction").padding().foregroundStyle(.gray)
                        }
                    }.frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 20).foregroundColor(.white)
                            .shadow(color: .black, radius: 5, x: 0, y: 0)
                    )
                    .padding()
                }
            }
        }
        .sheet(isPresented: $barCodeScannerViewModel.showFoundedBox, onDismiss: barCodeScannerViewModel.closeBoxDetails) {
            if let box = barCodeScannerViewModel.foundedBox {
                ScannedBoxView(scannedBoxViewModel: ScannedBoxViewModel(box: box,
                                                                        completion: barCodeScannerViewModel.showMessage))
            }
        }
    }
}
