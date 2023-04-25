/*
 학생추가
 학생삭제
 성적추가(변경)
 성적삭제
 평점보기
 종료
 */
import Foundation

enum TestError : Error {
    case BadInput
    case AlreadyExist(name: String)
    case NoneExist(name: String)
}

class students_list {
    var list: Array<Student> = []
    
    ///student_list에 해당 name이 존재하는지 확인, 있다면 해당 instance 반환
    func list_search(name:String) throws -> Student? {
        if name == "" { throw TestError.BadInput }
        
        for student in list { //이거 나중에 array.filter + Closer로 바꿔보자.
            if student.name == name {
                return student
            }
        }
        return nil
    }
    
    ///student list에 접근하여 name이 vaild한지 확인, instance를 만들어 student list에저장 후 반환
    func assign_student(name:String) throws -> Student {
        do {
            if let isExist = try list_search(name: name) {
                throw TestError.AlreadyExist(name:isExist.name) //if it so, throw Error AlreadyExist
            } else {
                let new_student = Student(name: name) // name is valid. make a new instance.
                list.append(new_student)    //append instance to student list
                return list.last!   //return prescribed instance + instance의 존재가 확실하기 때문에 !를 써주었는데...확실치 않다.
            }
        } catch TestError.BadInput{
            throw TestError.BadInput
        }
    }
    
    func delete_student(name:String) throws -> String {
        do {
            if let isExist = try list_search(name: name) {
                let target_index = list.indices.filter { list[$0].name == isExist.name }
                list.remove(at: target_index.first!) //remove target student in list - instance의 존재가 확실하기 때문에 !를 써주었는데...확실치 않다.
                return name
            } else {
                throw TestError.NoneExist(name: name)
            }
        } catch TestError.BadInput{
            throw TestError.BadInput
        }
    }
    
}

struct Student {
    var name: String
    var score: Dictionary<String, String>? = [:]
    
    init(name: String) {
        self.name = name
        self.score = [:]
    }
    
    
    mutating func add_score(subject:String, input_score:String) {
        if var score_Dic = self.score {
            score_Dic.updateValue(input_score, forKey: subject)
            self.score = score_Dic
        }
    }
    
    mutating func delete_score(subject:String) {
        if var score_Dic = self.score {
            score_Dic.removeValue(forKey: subject)
            self.score = score_Dic
        }
    }
}



var flag:Bool = true
var Student_list: students_list = students_list()


while flag == true {
    flag = menu()
}

func menu() -> Bool{
    var return_val:Bool = true
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    let input = readLine()
    if let input_menu = input {
        switch input_menu {
        case "1":
            add_student()
        case "2":
            delete_student()
        case "3":
            add_score()
        case "4":
            delete_score()
        case "5":
            show_GPA()
        case "X":
            print("프로그램을 종료합니다...")
            return_val = false
        default:
            print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            }
    } else {
        print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
    }
    return return_val
}

func add_student() {
    print("추가할 학생의 이름을 입력해주세요")
    if let student_name = readLine(){
        do {
            let student = try Student_list.assign_student(name: student_name)
            print("\(student.name) 학생을 추가했습니다.")
        } catch TestError.BadInput{
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.AlreadyExist(let exist_name){
            print("\(exist_name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            return
        } catch let error {
            print("\(error) 발생")
            return
        }
    }
}

func delete_student() {
    print("삭제할 학생의 이름을 입력해주세요")
    if let student_name = readLine() {
        do{
            let _ = try Student_list.delete_student(name: student_name)
        } catch TestError.BadInput {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.NoneExist(name: let No_name) {
            print("\(No_name) 학생을 찾지 못했습니다.")
            return
        } catch let error {
            print("\(error) 발생")
            return
        }
    }
    
}

func inspect_inputLine(input_Line:String, items_num:Int) throws -> Array<String>{
    let input_arr = input_Line.split(separator: " ").map{String($0)}
    if input_arr.count != items_num{
        throw TestError.BadInput
    }
    return input_arr
}

func add_score() {
    print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift A+")
    print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
    if let input_line = readLine() {
        do{
            let score_arr = try inspect_inputLine(input_Line: input_line, items_num: 3)
            let name = score_arr[0]
            let subject = score_arr[1]
            let score = score_arr[2]
            
            guard var student = try Student_list.list_search(name: name) else {
                throw TestError.NoneExist(name: name)
            }
            student.add_score(subject: subject, input_score: score)
            
            let target_in = Student_list.list.indices.filter { Student_list.list[$0].name == student.name }
            Student_list.list[target_in.first!] = student
            
            print("\(name) 학생의 \(subject) 과목이 \(score)로 추가(변경)되었습니다.")
            
            /*존나 곤욕이었던거 정리
             if var || guard var 뭐든 간에 do 블록 안의 내용은 지역변수이기 때문에 선언해준 student변수는 add_score() 끝나면 사라진다.
             따라서 Student_list.list에 직접 관여해서 바꿔줘야해
             이게 깊은복사-얕은복사 차이인 것 같은데 struct와 class의 차이에 대해 유심히 알아봐야겠네..*/
            
        } catch TestError.BadInput {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.NoneExist(let No_name) {
            print("\(No_name) 학생을 찾지 못했습니다.")
            return
        } catch let error {
            print("\(error) 발생")
            return
        }
        
        
    }
}

func delete_score() {
    print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
    print("입력예) Mickey Swift")
    if let input_line = readLine() {
        do{
            let score_Darr = try inspect_inputLine(input_Line: input_line, items_num: 2)
            let name = score_Darr[0]
            let subject = score_Darr[1]
            
            guard var student = try Student_list.list_search(name: name) else {
                throw TestError.NoneExist(name: name)
            }
            student.delete_score(subject: subject)
            
            let target_in = Student_list.list.indices.filter { Student_list.list[$0].name == student.name }
            Student_list.list[target_in.first!] = student
            
            print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
            
        } catch TestError.BadInput {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.NoneExist(let No_name) {
            print("\(No_name) 학생을 찾지 못했습니다.")
            return
        } catch let error {
            print("\(error) 발생")
            return
        }
    }
}

func show_GPA() {
    print("평점을 알고싶은 학생의 이름을 입력해주세요")
    if let student_name = readLine() {
        do{
            if let student = try Student_list.list_search(name: student_name){
                var total:Float = 0.0
                for i in student.score!{
                    print(i.key)
                    switch i.value {
                    case "A+":
                        total += 4.5
                    case "A":
                        total += 4.0
                    case "B+":
                        total += 3.5
                    case "B":
                        total += 3.0
                    case "C+":
                        total += 2.5
                    case "C":
                        total += 2.0
                    case "D+":
                        total += 1.5
                    case "D":
                        total += 1.0
                    case "F":
                        total += 0.0
                    default:
                        print("이상이상")
                    }
                }
                let result = total/Float(student.score!.count)
                print("평점 : \(round(result*100)/100)")
                
            } else {
                throw TestError.NoneExist(name: student_name)
            }
            
        } catch TestError.BadInput {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.NoneExist(let No_name) {
            print("\(No_name) 학생을 찾지 못했습니다.")
            return
        } catch let error {
            print("\(error) 발생")
            return
        }
    }
}
