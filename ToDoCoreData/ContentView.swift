//
//  ContentView.swift
//  ToDoCoreData
//
//  Created by BaronZhang.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var managedObjectContext    
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems: FetchedResults<ToDoItem>
    @State private var newToDoItem = ""
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("新待办")) {
                    HStack {
                        TextField("请输入", text: self.$newToDoItem)
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            toDoItem.title = self.newToDoItem
                            toDoItem.createdAt = Date()
                            // Save the Data
                            do {
                                try self.managedObjectContext.save()
                            }catch {
                                print(error)
                            }
                            //Clean the ToDoItem Data
                            self.newToDoItem = ""
                            
                            
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
                .font(.headline)
                Section(header: Text("待办列表")) {
                    ForEach(self.toDoItems) { todoItem in
                        TodoItemView(title: todoItem.title!, createdAt: "\(todoItem.createdAt!)")
                        
                    }
                    //Delete Data
                    .onDelete { indexSet in
                        let deleteItem = self.toDoItems[indexSet.first!]
                        self.managedObjectContext.delete(deleteItem)
                        do {
                            try self.managedObjectContext.save()
                        }catch {
                            print(error)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("To Do List"))
            .navigationBarItems(trailing: EditButton())
            .listStyle(PlainListStyle())
        }

        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
