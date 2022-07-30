//
//  EventsListViewModel.swift
//  EventsApp
//
//  Created by Rodrigo Ryo Aoki on 29/07/22.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

final class EventsListViewModel: EventsListViewModelProtocol {
	var events = PublishSubject<[Event]>()
	
	func fetchEventsList(finish: @escaping (Error?) -> Void) {
		AF.request(Endpoints.eventsList.rawValue).response { [weak self] response in
			switch response.result {
			case .success(let data):
				do {
					guard let data = data else {
						finish(CustomError(errorDescription: EAStrings.noDataFound.rawValue))
						return
					}

					let newEventsArray = try JSONDecoder().decode([Event].self, from: data)

					self?.events.onNext(newEventsArray)
					self?.events.onCompleted()
				} catch {
					finish(error)
				}

			case .failure(let error):
				finish(error)
			}
		}
	}
}