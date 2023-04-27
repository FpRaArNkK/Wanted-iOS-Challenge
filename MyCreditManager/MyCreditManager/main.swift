import Foundation

///runtime 중 발생가능한 Error 종류들
///
/// 1. BadInput - 입력 값이 잘못되었을 때 발생
/// 2. AlreadyExist - 해당 값이 이미 리스트에 존재하여 생성할 수 없을 때 발생
/// 3. NoneExist - 해당 값이 리스트에 존재하지 않아 참조할 수 없을 때 발생
enum TestError : Error {
    
    case BadInput
    case AlreadyExist(name: String)
    case NoneExist(name: String)
}


/// Student 인스턴스 목록
///
///   property & methods
/// - var list >  Student Instance Array
/// - func list_search(name:String) throws -> Student?
/// - func assign_student(name:String) throws -> Student
/// - func delete_student(name:String) throws -> String
class students_list {
    ///Student 인스턴스들을 저장하는 Array
    var list: Array<Student> = []
    
    ///목록에 이름이 있는지 확인하는 함수
    ///
    ///student list에 해당 name이 존재하는지 확인, 있다면 해당 instance 반환
    func list_search(name:String) throws -> Student? {
        if name == "" { throw TestError.BadInput }
        
        for student in list { //이거 나중에 array.filter + Closer로 바꿔보자.
            if student.name == name {
                return student
            }
        }
        return nil
    }
    
    ///목록에 해당 name의 Student를 추가하는 함수
    ///
    ///student list에 접근하여 name이 vaild한지 확인, instance를 만들어 student list에 저장 후  instance 반환
    func assign_student(name:String) throws -> Student {
        do {
            if let isExist = try list_search(name: name) {
                throw TestError.AlreadyExist(name:isExist.name)
            } else {
                let new_student = Student(name: name)
                list.append(new_student)
                return list.last!
            }
        } catch TestError.BadInput{
            throw TestError.BadInput
        }
    }
    ///목록에 해당 name의 Student를 삭제하는 함수
    ///
    ///student list에 접근하여 해당 name이 list에 존재하는지 확인, 해당 name을 가진 instance를 list에서 제거 후 name:String을 반환
    func delete_student(name:String) throws -> String {
        do {
            if let isExist = try list_search(name: name) {
                let target_index = list.indices.filter { list[$0].name == isExist.name }
                list.remove(at: target_index.first!)
                return name
            } else {
                throw TestError.NoneExist(name: name)
            }
        } catch TestError.BadInput{
            throw TestError.BadInput
        }
    }
    
}

/// Student 구조체
///
///   property & methods
/// - var name >  Student Instance Array
/// - var score > Student's Subject : Score Dictionary
/// - mutating func add_score(subject:String, input_score:String)
/// - mutating func delete_score(subject:String)
class Student {
    var name: String
    var score: Dictionary<String, String>? = [:]
    
    init(name: String) {
        self.name = name
        self.score = [:]
    }
    /// 입력받은 과목과 점수를 딕셔너리에 추가하는 함수
    ///
    /// Student.score를 참조하여 해당 subject와 input_score를 score Dictionary에 저장
    func add_score(subject:String, input_score:String) {
        if var score_Dic = self.score {
            score_Dic.updateValue(input_score, forKey: subject)
            self.score = score_Dic
        }
    }
    /// 입력받은 과목을 딕셔너리에서 제거하는 함수
    ///
    /// Student.score를 참조하여 해당 subject를 score Dictionary에서 제거
    func delete_score(subject:String) {
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


///메인 메뉴
///
///input에 따른 case의 함수 실행
///1. add_student() > 학생 추가
///2. delete_student() > 학생 삭제
///3. add_score() > 성적 추가(변경)
///4. delete_score() > 성적 삭제
///5. show_GPA()  > 평점 보기
///
///> menu()는 while문 안에서 돌면서 매번 Bool 값을 return > 이때 false 반환하는 경우 종료
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

///학생을 추가하는 함수
///
///입력받은 student_name을 student_list.assign_student() 함수로 try-catch
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

///학생을 삭제하는 함수
///
///입력받은 student_name을 student_list.delete_student()함수로 try-catch
func delete_student() {
    print("삭제할 학생의 이름을 입력해주세요")
    if let student_name = readLine() {
        do{
            let student = try Student_list.delete_student(name: student_name)
            print("\(student) 학생을 삭제했습니다.")
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

///입력받은 문자열을 체크하는 함수
///
///입력받은 문자열과 item 개수로 split된 item들의 개수가 맞는지 확인, Array로 반환
func inspect_inputLine(input_Line:String, items_num:Int) throws -> Array<String>{
    let input_arr = input_Line.split(separator: " ").map{String($0)}
    if input_arr.count != items_num{
        throw TestError.BadInput
    }
    return input_arr
}

///성적을 추가하는 함수
///
///입력받은 문자열을 inspect_inputLine()함수로 try-catch, 반환받은 값으로 student instance를 만들고
///guard-var로 student_list.list_search()함수를 try-catch.
///모두 통과하면 해당 instance의 .add_score()호출, student_list.list에 접근하여 해당 instance를 저장
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
            
            print("\(name) 학생의 \(subject) 과목이 \(score)로 추가(변경)되었습니다.")
            
            
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

///성적을 삭제하는 함수
///
///입력받은 문자열을 inspect_inputLine()함수로 try-catch, 반환받은 값으로 student instance를 만들고
///guard-var로 student_list.list_search()함수를 try-catch.
///모두 통과하면 해당 instance의 .delet_score()호출, student_list.list에 접근하여 해당 instance를 삭제
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

///성적 평균을 보여주는 함수
///
///입력받은 이름으로 student_list.list_search()를 try-catch,  해당 인스턴스의 score를 모두 참조하여 해당 결과를 산출
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
