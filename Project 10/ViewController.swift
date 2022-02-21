//
//  ViewController.swift
//  Project 10
//
//  Created by Daffolapmac-155 on 21/02/22.
//

import UIKit

class ViewController: UICollectionViewController {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
    }
    @objc func addNewPerson(){
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate  = self
        present(picker, animated: true )
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
        
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else{
            // not able to convert collection cell to PersonCell
            fatalError("Unable to dequeue a cell")
        }
        let person = people[indexPath.item]// collections view don't think in terms of row , it think in terms of item
        cell.name.text = person.name
        // used for creating the url
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        //converting data to image format (uiimage)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor//used for applying grayscale colors to the pic
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        // successful typecasting so return cell
       return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        let ac  = UIAlertController(title: "Rename person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text// for setting the name to person name property
            else {return}
            person.name = newName
            self?.collectionView.reloadData()
        })
        present(ac, animated: true)
    }
    
}
extension ViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else{return}// getting uiimage else return
        let imageName = UUID().uuidString//universally unique identifier
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)// getting url with the selected image 
        if let jpegData = image.jpegData(compressionQuality: 0.8){
            try? jpegData.write(to: imagePath)
        }
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        collectionView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    func getDocumentsDirectory()-> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask )// userDomainMask is used for getting relative url to user home screen directory
        return paths[0]
    }
}
extension ViewController: UINavigationControllerDelegate{
    
}
