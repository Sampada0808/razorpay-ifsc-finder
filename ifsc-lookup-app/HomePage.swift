import SwiftUI

struct HomePage: View {
    @State var viewModel = HomePageViewModel()
    var body: some View {
        ZStack {
            if viewModel.isloading{
                ProgressView(value: 0.55)
                               .progressViewStyle(.circular)
            }
            VStack {
                VStack{
                    HStack {
                        Image("logoIcon")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50,height: 50)
                            .clipShape(Circle())
                        Text("Razorpay IFSC Finder ")
                            .font(.system(size: 28, weight: .bold))
                    }
                    .padding(.top,30)
                    RoundedRectangle(cornerRadius: 20)
                        .fill(.white)
                        .stroke(Color(uiColor: UIColor.lightGray))
                        .frame(width: UIScreen.main.bounds.width - 40, height: 80)
                        .overlay {
                            HStack(spacing: 20) {
                                VStack(alignment: .leading, spacing: 4) {
                                    TextField("Enter IFSC Code", text: $viewModel.ifscCode)
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                }
                                Button {
                                    viewModel.fetchBankDetails()
                                } label: {
                                    Image(systemName: "magnifyingglass")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 30, height: 30)
                                        .padding(.leading, 20)
                                }
                                
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                }
                .offset(y: viewModel.startAnimation ? 1 : 0)
                .animation(.easeOut(duration: 0.8), value: viewModel.startAnimation)
               
                if viewModel.showBankDetails{
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading,spacing: 12) {
                            ForEach(viewModel.bankDetails.sorted(by: { $0.key < $1.key }), id: \.key) { data in
                                HStack {
                                    Text("\(data.key.capitalized):")
                                        .font(.title2)
                                        .foregroundColor(.white.opacity(0.9))
                                        .fontWeight(.semibold)
                                        .frame(width: 110, alignment: .leading)
                                    
                                    if let stringValue = data.value as? String, !stringValue.isEmpty {
                                        Text(stringValue.count > 20 ? stringValue.lowercased().capitalized : stringValue)
                                            .foregroundColor(.white)
                                            .font(.body)
                                    } else if let boolValue = data.value as? Bool {
                                        Text(boolValue ? "Yes" : "No")
                                            .foregroundColor(.white)
                                            .font(.body)
                                    } else {
                                        Text("No Information")
                                            .foregroundColor(.white.opacity(0.7))
                                            .font(.body.italic())
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(.blue)
                                    
                                )
                                .padding(.horizontal, 10)
                                .opacity(viewModel.appearedRows.contains(data.key) ? 1 : 0)
                                .onAppear {
                                    if !viewModel.appearedRows.contains(data.key) {
                                        withAnimation(.easeIn(duration: 0.6)) {
                                            viewModel.appearedRows.insert(data.key)
                                        }
                                    }
                                }



                            }
                        }
                        
                       
                    }
                    Spacer()
                }
                
                
                
                
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
                    } message: {
                        Text(viewModel.errorMessage)
            }
        }
    }
}

#Preview {
    HomePage()
}
