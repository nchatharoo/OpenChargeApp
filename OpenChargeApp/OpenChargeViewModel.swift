//
//  OpenChargeViewModel.swift
//  OpenChargeApp
//
//  Created by Nadheer on 17/01/2022.
//

import Foundation
import MapKit
import Combine

class OpenChargeViewModel: ObservableObject {
    let openchargeloader: OpenChargeLoader
    @Published public var item = Charge()
    
    init(openchargeloader: OpenChargeLoader) {
        self.openchargeloader = openchargeloader
    }

    func loadItem(with coordinate: CLLocationCoordinate2D, completion: @escaping (OpenChargeLoader.Result) -> Void) {
        self.openchargeloader.load(with: coordinate) { result in
            switch result {
            case let .success(items):
                DispatchQueue.main.async {
                    self.item = items
                }
                print(items)
            case let .failure(error):
                print(error)
            }
            completion(result)
        }
    }
}

//final class LoadResourcePresentationAdapter<Resource, View: ResourceView> {
//    private let loader: () -> AnyPublisher<Resource, Error>
//    private var cancellable: Cancellable?
//    var presenter: LoadResourcePresenter<Resource, View>?
//    
//    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
//        self.loader = loader
//    }
//    
//    func loadResource() {
//        presenter?.didStartLoading()
//        
//        cancellable = loader()
//            .dispatchOnMainQueue()
//            .sink(
//                receiveCompletion: { [weak self] completion in
//                    switch completion {
//                    case .finished: break
//                        
//                    case let .failure(error):
//                        self?.presenter?.didFinishLoading(with: error)
//                    }
//                }, receiveValue: { [weak self] resource in
//                    self?.presenter?.didFinishLoading(with: resource)
//                })
//    }
//}


extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler.shared
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        static let shared = Self()
        
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        private func isMainQueue() -> Bool {
            DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            
            action()
        }
        
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, options: options, action)
        }
    }
}
