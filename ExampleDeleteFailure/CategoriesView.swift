//
//  ContentView.swift
//  CoreDataState
//
//  Created by Jay Levy on 7/21/22.
//

import SwiftUI

struct CategoriesView: View {
    
    @EnvironmentObject var dataController: DataController
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name)])
    var categories: FetchedResults<Category>
    
    @State private var showingDeleteConfirm = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(categories) { category in
                        NavigationLink {
                            EmptyView()
                        } label : {
                            Text(category.categoryName)
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                print("****>> contextMenu category:    \(category.categoryName)")
                                print("****>> contextMenu object:      \(category)")
                                showingDeleteConfirm.toggle()
                            } label: {
                                Label("Delete Category", systemImage: "trash")
                            }
                        }
                        .swipeActions(allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                print("****>> swipeAction category:    \(category.categoryName)")
                                print("****>> swipeAction object:      \(category)")
                                showingDeleteConfirm.toggle()
                            } label: {
                                Label("Delete Category", systemImage: "trash")
                            }
                        }
                        .alert(isPresented: $showingDeleteConfirm) {
                            Alert(title: Text("Delete Category?"),
                                  message: Text("Are you sure you want to delete this category? All of its items and events will also be deleted."),
                                  primaryButton: .default(Text("Delete"), action: { deleteCategory(category) }),
                                  secondaryButton: .cancel())
                        }
                    }
                }
            }
            .navigationTitle("My Categories")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button {
                        dataController.deleteAll()
                        try? dataController.createSampleData()
                    } label: {
                        Text("Load Sample Data")
                    }
                }
            }
        }
    }
    
    func deleteCategory(_ category: Category) {
        print("****>> deleteCategory category: \(category.categoryName)")
        print("****>> deleteCategory object:   \(category)")
        dataController.delete(category)
        dataController.save()
    }
}

extension Category {
    var categoryName: String {
        name ?? "New Category"
    }
}
