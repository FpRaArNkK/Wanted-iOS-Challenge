struct Student {
    var name: String
    var score: Dictionary<String, String>? = [:]
    
    init(name: String) {
        self.name = name
        self.score = ["이씨빨":"왜안되는거야"]
    }
    
    mutating func add_score(subject:String, input_score:String) {
        //score!.updateValue(input_score, forKey: subject)      //이부분 좀더 공부해보기

        if var score_Dic = self.score {
            score_Dic.updateValue(input_score, forKey: subject)
            //print(score_Dic) //여기까진 되거든
            self.score = score_Dic
        }
    }
    
    mutating func delect_score(subject:String) {
        self.score?.removeValue(forKey: subject)
    }
}

var student = Student(name: "park")
student.add_score(subject: "swift", input_score: "a+")
print(student)
