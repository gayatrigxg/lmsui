import SwiftUI
import AVFoundation
import PencilKit
import Combine

struct ESignatureView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var camera = CameraPreviewModel()
    @State private var signatureImage: UIImage?
    @State private var goToReview = false
    @State private var showSignatureRequired = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 24) {
                    headerSection
                    cameraSection
                    signatureSection

                    if showSignatureRequired {
                        Text("Please sign inside the box to continue.")
                            .font(.footnote)
                            .foregroundStyle(.red)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 28)
            }

            bottomBar
        }
        .background(Color(uiColor: .systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("E-Signature")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $goToReview) {
            KYCSubmissionSummaryView()
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                }
                .accessibilityLabel("Back")
            }
        }
        .task {
            await camera.requestAccessAndStart()
        }
        .onDisappear {
            camera.stop()
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Sign to confirm")
                .font(.system(size: 30, weight: .bold))
                .foregroundStyle(.primary)

            Text("Keep your face visible while signing. This confirms that you are submitting the onboarding details yourself.")
                .font(.system(size: 17))
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var cameraSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Camera verification")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.secondary)

            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(uiColor: .secondarySystemGroupedBackground))

                switch camera.authorizationState {
                case .authorized:
                    CameraPreviewView(session: camera.session)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(alignment: .topTrailing) {
                            Label("Live", systemImage: "video.fill")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 6)
                                .background(Color.black.opacity(0.45))
                                .clipShape(Capsule())
                                .padding(12)
                        }

                case .denied:
                    permissionMessage(
                        icon: "video.slash",
                        title: "Camera access is off",
                        message: "Enable camera permission in Settings to continue with e-signature verification."
                    )

                case .missingUsageDescription:
                    permissionMessage(
                        icon: "exclamationmark.triangle",
                        title: "Camera permission is missing",
                        message: "Add Privacy - Camera Usage Description in the app target Info settings."
                    )

                case .notDetermined:
                    permissionMessage(
                        icon: "video",
                        title: "Camera permission needed",
                        message: "We’ll use your camera only during this signing step."
                    )

                case .failed:
                    permissionMessage(
                        icon: "exclamationmark.triangle",
                        title: "Camera unavailable",
                        message: "Please try again or check your device camera."
                    )
                }
            }
            .frame(height: 210)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
    }

    private func permissionMessage(icon: String, title: String, message: String) -> some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 30, weight: .medium))
                .foregroundStyle(.blue)

            Text(title)
                .font(.headline)
                .foregroundStyle(.primary)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
        }
    }

    private var signatureSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Your signature")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.secondary)

                Spacer()

                Button("Clear") {
                    signatureImage = nil
                    showSignatureRequired = false
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.blue)
            }

            SignaturePadView(signatureImage: $signatureImage)
                .frame(height: 220)
                .background(Color(uiColor: .secondarySystemGroupedBackground))
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color(uiColor: .separator), lineWidth: 0.5)
                }
        }
    }

    private var bottomBar: some View {
        VStack(spacing: 8) {
            Button {
                guard signatureImage != nil else {
                    withAnimation(.easeOut(duration: 0.2)) {
                        showSignatureRequired = true
                    }
                    return
                }

                showSignatureRequired = false
                goToReview = true
            } label: {
                Text("Continue")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle(radius: 16))
            .controlSize(.large)
            .tint(.blue)

            Text("Your signature will be attached to this application.")
                .font(.system(size: 13))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
        .padding(.bottom, 10)
        .background(.regularMaterial)
    }
}

private struct SignaturePadView: UIViewRepresentable {
    @Binding var signatureImage: UIImage?

    func makeUIView(context: Context) -> PKCanvasView {
        let canvasView = PKCanvasView()
        canvasView.delegate = context.coordinator
        canvasView.backgroundColor = .secondarySystemGroupedBackground
        canvasView.drawingPolicy = .anyInput
        canvasView.tool = PKInkingTool(.pen, color: .label, width: 3)
        return canvasView
    }

    func updateUIView(_ canvasView: PKCanvasView, context: Context) {
        if signatureImage == nil && !canvasView.drawing.bounds.isEmpty {
            canvasView.drawing = PKDrawing()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(signatureImage: $signatureImage)
    }

    final class Coordinator: NSObject, PKCanvasViewDelegate {
        @Binding private var signatureImage: UIImage?

        init(signatureImage: Binding<UIImage?>) {
            _signatureImage = signatureImage
        }

        func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
            let bounds = canvasView.drawing.bounds

            guard !bounds.isEmpty else {
                signatureImage = nil
                return
            }

            signatureImage = canvasView.drawing.image(
                from: bounds.insetBy(dx: -12, dy: -12),
                scale: UIScreen.main.scale
            )
        }
    }
}

private struct CameraPreviewView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewContainerView {
        let view = PreviewContainerView()
        view.previewLayer.session = session
        view.previewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: PreviewContainerView, context: Context) {
        uiView.previewLayer.session = session
    }
}

private final class PreviewContainerView: UIView {
    override class var layerClass: AnyClass {
        AVCaptureVideoPreviewLayer.self
    }

    var previewLayer: AVCaptureVideoPreviewLayer {
        layer as! AVCaptureVideoPreviewLayer
    }
}

@MainActor
private final class CameraPreviewModel: ObservableObject {
    enum AuthorizationState {
        case notDetermined
        case authorized
        case denied
        case missingUsageDescription
        case failed
    }

    @Published var authorizationState: AuthorizationState = .notDetermined

    let session = AVCaptureSession()

    func requestAccessAndStart() async {
        guard Bundle.main.object(forInfoDictionaryKey: "NSCameraUsageDescription") != nil else {
            authorizationState = .missingUsageDescription
            return
        }

        let status = AVCaptureDevice.authorizationStatus(for: .video)

        switch status {
        case .authorized:
            authorizationState = .authorized
            start()

        case .notDetermined:
            let granted = await AVCaptureDevice.requestAccess(for: .video)
            authorizationState = granted ? .authorized : .denied

            if granted {
                start()
            }

        case .denied, .restricted:
            authorizationState = .denied

        @unknown default:
            authorizationState = .failed
        }
    }

    func start() {
        guard !session.isRunning else { return }

        session.beginConfiguration()
        session.sessionPreset = .medium
        session.inputs.forEach { session.removeInput($0) }

        guard
            let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
            let input = try? AVCaptureDeviceInput(device: device),
            session.canAddInput(input)
        else {
            authorizationState = .failed
            session.commitConfiguration()
            return
        }

        session.addInput(input)
        session.commitConfiguration()
        session.startRunning()
    }

    func stop() {
        guard session.isRunning else { return }
        session.stopRunning()
    }
}

struct ESignatureView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ESignatureView()
        }
    }
}
