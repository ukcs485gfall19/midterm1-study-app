//
//  ComposeViewController.swift
//  messagingApp
//
//  Created by Joshua Steinbach on 9/25/19.
//  Copyright © 2019 Joshua Steinbach. All rights reserved.
// fix commit

import UIKit
import FirebaseDatabase

class ComposeViewController: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate{
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var classTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextView!
    @IBOutlet weak var locTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var endTimeTextField: UITextField!
    //hard coded dummy data, need to
    var majorData = ["","MA", "CS", "EE", "MGT"]
    var classData = [[""],["111", "112", "213", "336"], ["115","215","315","375","485","499"], ["101","102","380"], ["69","420","42069","69420"]]
    
    var majorPicker = UIPickerView()
    var classPicker = UIPickerView()
    var datePicker = UIDatePicker()
    var endTimePicker = UIDatePicker()
    var datePicked: Date?
    var ref:DatabaseReference?
    let dateFormatter = DateFormatter()
    var datePickerArr:[UIDatePicker] = []
    var model = postModel()
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()

        // Do any additional setup after loading the view.
        datePicker.minimumDate = Date()
        endTimePicker.minimumDate = Date()
        majorPicker.delegate = self
        majorPicker.dataSource = self
        majorPicker.tag = 0
        classPicker.delegate = self
        classPicker.dataSource = self
        classPicker.tag = 1
        
        //setup the dateFormatter
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        
        //setup the date
        dateTextField.text = dateFormatter.string(from: Date())
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        //datePicker.minuteInterval = 15;
        endTimePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        //endTimePicker.minuteInterval = 15;
        endTimePicker.datePickerMode = UIDatePicker.Mode.time
        datePickerArr = [datePicker, endTimePicker]
        
        majorTextField.inputView = majorPicker
        classTextField.inputView = classPicker
        dateTextField.inputView = datePicker
        endTimeTextField.inputView = endTimePicker
        
        bodyTextField.text = "Body"
        bodyTextField.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        bodyTextField.layer.cornerRadius = 5
        bodyTextField.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        bodyTextField.layer.borderWidth = 0.5
        bodyTextField.clipsToBounds = true
        
        bodyTextField.delegate = self
    }
    
    @objc func dateChanged(datePicker:UIDatePicker){
        let index:Int = datePickerArr.firstIndex(of:datePicker)!
        if(index == 0){
            dateTextField.text = dateFormatter.string(from:datePicker.date)
            endTimePicker.minimumDate = datePicker.date
            endTimeTextField.text = dateFormatter.string(from:endTimePicker.date)
        }
        if(index == 1){
            endTimeTextField.text = dateFormatter.string(from:endTimePicker.date)
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0{
            return majorData.count
        }
        if pickerView.tag == 1 {
            let index = majorData.firstIndex(of: majorTextField.text ?? "")// if majorTextField is null then index won't be able to find anything and thus will be null as well
            if (index != nil){
                return classData[index ?? 0].count //I think this is fine, not sure tho
            }
            return 0
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return majorData[row]
        }
        if pickerView.tag == 1 {
            let index = majorData.firstIndex(of: majorTextField.text ?? "")
            if (index != nil){
                return classData[index ?? 0][row]
            }
            return ""
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 0{
            majorTextField.text = majorData[row]
            classTextField.text = classData[row][0]
            classPicker.selectRow(0, inComponent:0, animated: false);
        }
        if pickerView.tag == 1 {
            let index = majorData.firstIndex(of: majorTextField.text ?? "")
            if (index != nil){
                classTextField.text = classData[index ?? 0][row]
            }
        }
        self.view.endEditing(false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bodyTextField.text == "Body"{
            bodyTextField.text = ""
            bodyTextField.textColor = UIColor.darkText
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n"{
            textView.resignFirstResponder()
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bodyTextField.text == ""{
            bodyTextField.text = "Body"
            bodyTextField.textColor = UIColor(red: 0, green: 0, blue: 0.0980392, alpha: 0.22)
        }
    }
    
    @IBAction func addPost(_ sender: Any) {
        //add to database
        if titleTextField.text != "" && majorTextField.text != "" && classTextField.text != "" && dateTextField.text != "" && locTextField.text != ""{
            //create a new child with an auto-generated id
            let id:String? = ref?.child("Posts").childByAutoId().key
            //adding the indexes for the picker selected prefix and number
            let prefSelect:Int = majorPicker.selectedRow(inComponent:0)
            let numSelect:Int = classPicker.selectedRow(inComponent:0)
            let newpost:Post = Post()
            //making a new post to get rid of a weird error i was getting
            newpost.id = id!
            newpost.date = dateFormatter.string(from: datePicker.date)
            newpost.desc = bodyTextField.text
            newpost.title = titleTextField.text!
            newpost.prefix = majorData[prefSelect]
            newpost.number = classData[prefSelect][numSelect]
            newpost.location = locTextField.text!
            model.postIDS.append(id!)
            model.posts.append(newpost)
            
            //here is where the title tag is set
            ref?.child("Posts").child(id!).child("Title").setValue(titleTextField.text)
            //here is where the body tag is set
            ref?.child("Posts").child(id!).child("Body").setValue(bodyTextField.text)
            //here is where the prefix tag is set
            ref?.child("Posts").child(id!).child("Prefix").setValue(majorData[prefSelect])
            //here is where the number tag is set
            ref?.child("Posts").child(id!).child("Number").setValue(classData[prefSelect][numSelect])
            //here is where the location tag is set
            ref?.child("Posts").child(id!).child("Location").setValue(locTextField.text)
            //here is where the date tag is set
            ref?.child("Posts").child(id!).child("Date").setValue(dateFormatter.string(from: datePicker.date))
            ref?.child("Posts").child(id!).child("endTime").setValue(dateFormatter.string(from: endTimePicker.date))
            //this will be hidden to the user but will be helpful to us
            if(user.userName != ""){
                ref?.child("Posts").child(id!).child("User").setValue(user.userName)
            }
            //close popup
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
        else{
            let alertController = UIAlertController(title: "Alert", message: "Please fill out all requred fields", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelPost(_ sender: Any) {
        //close popup
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
