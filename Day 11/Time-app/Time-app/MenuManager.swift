import AppKit

class MenuManager: NSObject, NSMenuDelegate {
    let statusMenu: NSMenu
    var menuIsOpen = false
    
    var tasks = Task.sampleTasksWithStatus
    
    init(statusMenu: NSMenu) {
        self.statusMenu = statusMenu
        super.init()
    }
    
    let itemsBeforeTasks = 2
    let itemsAfterTasks = 6
    
    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        showTasksInMenu()
    }
    
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
        clearTasksFromMenu()
    }
    
    func clearTasksFromMenu() {
        let stopAtIndex = statusMenu.items.count - itemsAfterTasks
        
        for _ in itemsBeforeTasks ..< stopAtIndex {
            statusMenu.removeItem(at: itemsBeforeTasks)
        }
    }
    
    func showTasksInMenu() {
        let itemFrame = NSRect(x: 0, y: 0, width: 270, height: 40)
        var index = itemsBeforeTasks
        var taskCounter = 0
        
        for task in tasks {
            let item = NSMenuItem()
            let view = TaskView(frame: itemFrame)
            view.task = task
            item.view = view
            
            statusMenu.insertItem(item, at: index)
            index += 1
            taskCounter += 1
            
            if taskCounter.isMultiple(of: 4) {
                statusMenu.insertItem(NSMenuItem.separator(), at: index)
                index += 1
            }
        }
    }
}
