//
//  DownloadableImage.swift
//  MarathonSwiftUI
//
//  Created by Илья Шаповалов on 06.08.2023.
//

import SwiftUI
import Combine
import OSLog

public struct DownloadableImage<Content, Placeholder, Failure>: View where Content: View,
                                                                           Placeholder: View,
                                                                           Failure: View {
    
    @Environment(\.imageCache) var imageCache
    @State private var dataLoadingStatus: DataLoadingStatus = .image(UIImage(systemName: "photo") ?? .init())
    
    private let imageProcessingQueue = DispatchQueue(label: "DownloadableImage: image processing")
    private let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: Self.self)
    )
    private let animation: Animation = .easeInOut(duration: 1)
    private let transition: AnyTransition = .opacity
    private let image: (Image) -> Content
    private let placeholder: Placeholder
    private let errorView: () -> Failure
    private let url: URL?
    
    //MARK: - Body
    public var body: some View {
        Group {
            switch dataLoadingStatus {
            case let .image(uIImage):
                image(Image(uiImage: uIImage))
                    .transition(transition)
            case .loading:
                placeholder
                    .transition(transition)
            case .error:
                errorView()
                    .transition(transition)
            }
        }
        .animation(animation, value: dataLoadingStatus)
        .onAppear(perform: loadImage)
    }
    
    //MARK: - init(_:)
    public init(
        url: URL?,
        @ViewBuilder image: @escaping (Image) -> Content,
        @ViewBuilder placeholder: @escaping () -> Placeholder = ProgressView.init,
        @ViewBuilder onError: @escaping () -> Failure = EmptyView.init
    ) {
        self.url = url
        self.image = image
        self.placeholder = placeholder()
        self.errorView = onError
    }
    
}

private extension DownloadableImage {
    //MARK: - Private methods
    func loadImage() {
        guard let url = url else {
            dataLoadingStatus = .error
            logger.error("Invalid URL: \(String(describing: url))")
            return
        }
        
        guard dataLoadingStatus != .loading else {
            logger.debug("Loading in progress...")
            return
        }
        
        if let image = imageCache[url] {
            logger.debug("Receive image from cache.")
            dataLoadingStatus = .image(image)
            return
        }
        
        _ = URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: imageProcessingQueue)
            .map(\.data)
            .map(UIImage.init)
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: handle(completion:),
                receiveValue: set(image:)
            )
    }
    
    func handle(completion: Subscribers.Completion<URLSession.DataTaskPublisher.Failure>) {
        logger.debug("Receive publisher completion.")
        switch completion {
        case .finished:
            break
        case let .failure(failure):
            logger.error("Publisher failure: \(failure.localizedDescription)")
        }
    }
    
    func set(image: UIImage?) {
        guard let image = image else {
            logger.error("Unable to decode image.")
            dataLoadingStatus = .error
            return
        }
//        if let url = url {
//            imageCache[url] = image
//        }
        dataLoadingStatus = .image(image)
    }
}

//MARK: - DataLoadingStatus
private extension DownloadableImage {
    enum DataLoadingStatus: Equatable {
        case image(UIImage)
        case loading
        case error
        
        static func == (
            lhs: DownloadableImage<Content, Placeholder, Failure>.DataLoadingStatus,
            rhs: DownloadableImage<Content, Placeholder, Failure>.DataLoadingStatus
        ) -> Bool {
            String(describing: lhs) == String(describing: rhs)
        }
    }
}

#Preview {
    DownloadableImage(
        url: URL(string: "https://img.freepik.com/premium-vector/young-girl-anime-style-character-vector-illustration-design-manga-anime-girl_147933-100.jpg?w=1380"),
        image: { $0.resizable().scaledToFit() },
        placeholder: ProgressView.init,
        onError: EmptyView.init)
}
