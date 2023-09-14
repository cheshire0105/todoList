//
//  ProfileDesignViewModel.swift
//  AdvancedTask
//
//  Created by cheshire on 2023/09/12.
//

import Foundation
import UIKit
import CoreData

class ProfileViewModel {

    var selectedImages: [UIImage] = []

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveImage(image: UIImage) {
        let context = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Image", in: context)!
        let newImage = NSManagedObject(entity: entity, insertInto: context)
        
        newImage.setValue(image.pngData(), forKey: "image")
        
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
    }
    
    func loadImages() -> [UIImage]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")
        
        do {
            let imageObjects = try context.fetch(fetchRequest)
            return imageObjects.compactMap { obj in
                if let imageData = obj.value(forKey: "image") as? Data {
                    return UIImage(data: imageData)
                }
                return nil
            }
        } catch {
            print("Failed loading")
            return nil
        }
    }
    
    func deleteImage(at index: Int) {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Image")

        do {
            let imageObjects = try context.fetch(fetchRequest)
            if index < imageObjects.count {
                let imageToDelete = imageObjects[index]
                context.delete(imageToDelete)
                
                try context.save()
                
                // 햅틱 피드백 발생
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)
                feedbackGenerator.prepare()
                feedbackGenerator.impactOccurred()
            }
        } catch {
            print("Failed deleting")
        }
    }

}
