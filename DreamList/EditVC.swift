//
//  EditVC.swift
//  DreamList
//
//  Created by Robert Block on 12/4/16.
//  Copyright © 2016 globile. All rights reserved.
//

import UIKit
import CoreData

class EditVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var detailTextfield: UITextField!
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storePicker: UIPickerView!
    
    let imagePicker = UIImagePickerController()

    var stores = [Store]()
    var itemToEdit : Item?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        storePicker.dataSource = self
        storePicker.delegate = self
        
        imagePicker.delegate = self
        
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        getStores()
        if stores.count < 1 {
            let store = Store(context: context)
            store.store = "Amazon"
            let store1 = Store(context: context)
            store1.store = "eBay"
            let store2 = Store(context: context)
            store2.store = "Walmart"
            let store3 = Store(context: context)
            store3.store = "Etsy"
            let store4 = Store(context: context)
            store4.store = "NewEgg"
            ad.saveContext()
            getStores()
        }
        if itemToEdit != nil {
            loadItemData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadItemData() {
        if let item = itemToEdit {
            titleTextfield.text = item.title
            price.text = "\(item.price)"
            detailTextfield.text = item.detail
            
            image.image = item.toImage?.image as? UIImage
            
            if let store = item.toStore {
                
                var index = 0
                
                repeat {
                    var s = stores[index]
                    if s.store == store.store {
                        storePicker.selectRow(index, inComponent: 0, animated: true)
                        break
                    }
                    index += 1
                } while (index < stores.count)
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return stores[row].store
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        storeNameLabel.text = stores[row].store
    }

    func getStores() {
        let fetchRequest:NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents()
        } catch {
            // handle the error
        }
    }

    @IBAction func saveButtonAction(_ sender: UIButton) {
        
        let item : Item!
        let picture = Image(context: context)
        picture.image = image.image

        
        if itemToEdit == nil {
            print("itemToEdit == nil")
            item = Item(context: context)
        } else {
            print("itemToEdit != nil")
            item = itemToEdit
            item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        }
        
        item.toImage = picture
        
        if let title = titleTextfield.text {
            item.title = title
        }
        

        item.created = NSDate()
        
        if let detail = detailTextfield.text {
            item.detail = detail
        }
        
        if let price = price.text {
            item.price = (price as NSString).doubleValue
        }
        ad.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteItem(_ sender: UIBarButtonItem) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func imageButton(_ sender: UIButton) {
//        imagePicker.allowsEditing = false
//        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: UIImagePickerControllerSourceType.savedPhotosAlbum)!
//        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image.image = pickedImage
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
