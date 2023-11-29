import Foundation

struct JsonCodableDataTask{
    
    enum FetchJokeResult {
        case success(JsonModel)
        case failure(Error)
    }
    
    func fetchJoke(completion: @escaping (FetchJokeResult)-> Void){
        let url = URL(string: "https://api.chucknorris.io/jokes/random")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request){ (data, response, error) in
          
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse,
               !(200...299).contains(httpResponse.statusCode) {
                let error = NSError(domain: "HTTPError", code: httpResponse.statusCode, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "NoDataError", code: 0, userInfo: nil)
                completion(.failure(error))
                return
            }
            
            
            do{
                let jsonModel = try JSONDecoder().decode(JsonModel.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonModel))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
            // Запуск задачи
            task.resume()
        }
    }





