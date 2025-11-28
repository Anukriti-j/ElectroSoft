import SwiftUI

struct AddEmployeeView: View {
    @StateObject private var viewModel: AddEmployeeViewModel = AddEmployeeViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Form {
                Section {
                    TextField("Name", text: $viewModel.name)
                        
                    TextField("Email", text: $viewModel.email)
                    TextField("PhoneNumber", text: $viewModel.phoneNumber)
                } header: {
                    Text("Personal Info")
                }
                
                Section {
                    
                } header: {
                    Text("Role")
                }
                
                Section {
                    
                } header: {
                    Text("Work Location")
                }

            }
            
        }
    }
}

#Preview {
    AddEmployeeView()
}
