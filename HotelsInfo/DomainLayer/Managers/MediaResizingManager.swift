import UIKit

protocol IMediaResizeManager {
    func resize(
        imageData: Data,
        padding: CGFloat
    ) async -> UIImage?
}

final class MediaResizeManager: IMediaResizeManager {
    init() {}

    @MainActor
    func resize(
        imageData: Data,
        padding: CGFloat = 1
    ) async -> UIImage? {
        await Task.detached(priority: .medium) {
            guard !Task.isCancelled else { return nil }

            guard let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
                  let cgImage = CGImageSourceCreateImageAtIndex(imageSource, 0, nil) else {
                return nil
            }

            let originalWidth = CGFloat(cgImage.width)
            let originalHeight = CGFloat(cgImage.height)
            let newWidth = originalWidth - padding * 2
            let newHeight = originalHeight - padding * 2

            guard newWidth > 0, newHeight > 0 else { return UIImage(cgImage: cgImage) }

            let croppedImage = cgImage.cropping(to: CGRect(
                    x: padding,
                    y: padding,
                    width: newWidth,
                    height: newHeight
                ))

            guard let croppedImage else { return UIImage(cgImage: cgImage) }

            return UIImage(cgImage: croppedImage)
        }.value
    }
}
