//
//  FeedImageMapper.swift
//  FeedAPIChallenge
//
//  Created by admin on 22/08/21.
//  Copyright © 2021 Essential Developer Ltd. All rights reserved.
//

import Foundation

internal final class FeedImageMapper {
	private struct Root: Decodable {
		let items: [Item]

		var feedImages: [FeedImage] {
			return items.map { $0.feedImage }
		}
	}

	private struct Item: Decodable {
		let id: UUID
		let description: String?
		let location: String?
		let url: URL

		private enum CodingKeys: String, CodingKey {
			case id = "image_id"
			case description = "image_desc"
			case location = "image_loc"
			case url = "image_url"
		}

		var feedImage: FeedImage {
			return FeedImage(id: id, description: description, location: location, url: url)
		}
	}

	private static var statusCode_OK: Int {
		return 200
	}

	static func map(_ data: Data, _ response: HTTPURLResponse) -> FeedLoader.Result {
		guard response.statusCode == statusCode_OK, let root = try? JSONDecoder().decode(Root.self, from: data) else {
			return .failure(RemoteFeedLoader.Error.invalidData)
		}
		return .success(root.feedImages)
	}
}
