//
//  MyTicketBookDTO.swift
//  ReCulture
//
//  Created by Suyeon Hwang on 6/13/24.
//

struct MyTicketBookDTO: Codable {
    let id: Int
    let title: String
    let emoji: String
    let date: String
    let categoryId: Int
    let disclosure: String
    let review: String
    let authorId: Int
    let createdAt: String
    let updatedAt: String
    let frameId: Int
    let photos: [Photo]
}

struct Photo: Codable {
    let id: Int
    let url: String
    let ticketPostId: Int
}

extension MyTicketBookDTO {
    static func convertMyTicketBookDTOToModel(DTO: MyTicketBookDTO) -> MyTicketBookModel {
        return MyTicketBookModel(
            ticketBookId: DTO.id,
            title: DTO.title,
            emoji: DTO.emoji,
            date: DTO.date, 
            categoryType: RecordType(categoryId: DTO.categoryId-1)!,
            review: DTO.review,
            frame: DTO.frameId,
            imageURL: DTO.photos[0].url
        )
    }

    static func convertMyTicketBookDTOsToModels(DTOs: [MyTicketBookDTO]) -> [MyTicketBookModel] {
        return DTOs.map { convertMyTicketBookDTOToModel(DTO: $0) }
    }
}
