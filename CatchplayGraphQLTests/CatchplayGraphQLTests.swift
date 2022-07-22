//
//  CatchplayGraphQLTests.swift
//  CatchplayGraphQLTests
//
//  Created by Ray Hsu on 2022/7/20.
//

import XCTest
@testable import CatchplayGraphQL

class CatchplayGraphQLTests: XCTestCase {
    
    fileprivate var mockLoader = MockRequestLoader()
    
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
        mockLoader.data = nil
        mockLoader.error = nil
    }
    
    func test_decodeError() {
        // 少了"data"
        mockLoader.data = Data(decodeErrorStr.utf8)
        let req = GetUsersRequest(queryKeys: [.id], todoQueries: nil)
        mockLoader.load(req) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error as! GraphQLError, GraphQLError.decodeFail)
            }
        }
    }

    func testUsersData_isCorrect() {
        mockLoader.data = Data(usersDataMock.utf8)
        let req = GetUsersRequest(queryKeys: [.id, .email, .name], todoQueries: [.id, .description, .done])
        mockLoader.load(req) { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value.users.count == 2)
                XCTAssertEqual(value.users.first?.todos?.first?.done, false)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testUserData_isCorrect() {
        mockLoader.data = Data(usersDataMock.utf8)
        let req = GetUserInfoRequest(queryKeys: [.id, .email, .name], userId: "123", todosKeys: [.id, .description, .done])
        mockLoader.load(req) { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value.user.todos?.count == 2)
                XCTAssertEqual(value.user.todos?.first?.done, false)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func testTodoData_isCorrect() {
        mockLoader.data = Data(todoDataMock.utf8)
        let req = GetTodosRequest(queryKeys: [.id, .description, .done])
        mockLoader.load(req) { result in
            switch result {
            case .success(let value):
                XCTAssertTrue(value.todos.count == 2)
                XCTAssertEqual(value.todos.first?.done, true)
            case .failure(_):
                XCTFail()
            }
        }
    }
    
    func test_updateTo_success() {
        mockLoader.data = Data(mutateTodoDataMock.utf8)
        let req = MutationTodoRequest(queryKeys: [.done], id: nil, description: nil, done: true)
        mockLoader.load(req) { result in
            switch result {
            case .success(let value):
                XCTAssertNotNil(value.updateTodo.done)
            case .failure(_):
                XCTFail()
            }
        }

    }
    
//    func test_query() {
//        let query = GraphQLQuery.query() {
//            From("users")
//            Fields("id", "email", "name")
//        }
//        let expectation = """
//                            {
//                                users  {
//                                    id
//                                    email
//                                    name
//                                }
//                            }
//                            """
//
//        XCTAssertEqual(expectation.removeSpace(), query)
//
//    }

}

fileprivate struct MockRequestLoader: RequestLoader {
    
    var data: Data?
    
    var error: Error?
    
    func load<req: GraphQLRequest>(_ request: req, completion: @escaping (Result<req.Value, Error>) ->()) {
        
        if let error = error {
            completion(.failure(error))
            return
        }
        
        completion(request.decode(data))
    }
    
}

fileprivate let decodeErrorStr = """
                    {  {
                        "users": [
                                { "id": "Hello World", },
                                { "id": "Hello World", }
                            ]
                        }
                    }
                    """


fileprivate let usersDataMock = """
                    {
                      "data": {
                        "users": [
                          {
                            "id": "Hello World",
                            "email": "Hello World",
                            "name": "Hello World",
                            "todos": [
                              {
                                "id": "Hello World",
                                "description": "Hello World",
                                "done": false
                              },
                              {
                                "id": "Hello World",
                                "description": "Hello World",
                                "done": true
                              }
                            ]
                          },
                          {
                            "id": "Hello World",
                            "email": "Hello World",
                            "name": "Hello World",
                            "todos": [
                              {
                                "id": "Hello World",
                                "description": "Hello World",
                                "done": false
                              },
                              {
                                "id": "Hello World",
                                "description": "Hello World",
                                "done": true
                              }
                            ]
                          }
                        ]
                      }
                    }
                    """

fileprivate let userDataMock = """
                {
                    "data": {
                        "user": {
                            "id": "Hello World",
                            "email": "Hello World",
                            "name": "Hello World",
                            "todos": [
                                {
                                    "id": "Hello World",
                                    "description": "Hello World",
                                    "done": false
                                },
                                {
                                    "id": "Hello World",
                                    "description": "Hello World",
                                    "done": true
                                }
                            ]
                        }
                    }
                }
                """

fileprivate let todoDataMock = """
                {
                  "data": {
                    "todos": [
                      {
                        "id": "Hello World",
                        "description": "Hello World",
                        "done": true
                      },
                      {
                        "id": "Hello World",
                        "description": "Hello World",
                        "done": true
                      }
                    ]
                  }
                }
                """

fileprivate let mutateTodoDataMock = """
                {
                  "data": {
                    "updateTodo": {
                      "done": false
                    }
                  }
                }
                """
