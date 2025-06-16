import Foundation
import SwiftUI

@Observable
class HomePageViewModel {
    var ifscCode : String = ""
    var bankDetails : [String: Any] = [:]
    var isloading : Bool = false
    var errorMessage : String = ""
    var startAnimation : Bool = false
    var showBankDetails  : Bool = false
    var showAlert : Bool = false
    var appearedRows: Set<String> = []

    
    func fetchBankDetails() {
            guard !ifscCode.isEmpty else { return }

            let urlStr = "https://ifsc.razorpay.com/\(ifscCode)"
            guard let url = URL(string: urlStr) else { return }

            isloading = true
            showBankDetails = false

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    self.isloading = false
                }

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    
                    return
                }

                guard let data = data else { return }

                do {
                    let BankInfo = try JSONDecoder().decode(BankDetails.self, from: data)
                    DispatchQueue.main.async {
                        self.bankDetails = self.convertToDictionary(bank: BankInfo)
                        withAnimation {
                            self.showBankDetails = true
                        }
                    }
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.showAlert = true
                    
                    print("Decoding Error:", error)
                }
            }.resume()
        }

    private func convertToDictionary(bank: BankDetails) -> [String: Any] {
        let mirror = Mirror(reflecting: bank)
        var result: [String: Any] = [:]

        for child in mirror.children {
            if let key = child.label {
                let value = child.value

                if let unwrapped = unwrap(value) {
                    result[key.uppercased()] = unwrapped
                }
            }
        }
        return result
    }

    private func unwrap(_ any: Any) -> Any? {
        let mirror = Mirror(reflecting: any)
        if mirror.displayStyle != .optional {
            return any
        }

        if let child = mirror.children.first {
            return child.value
        }

        return nil
    }

}
