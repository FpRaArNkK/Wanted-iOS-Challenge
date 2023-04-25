/*
 학생추가
 학생삭제
 성적추가(변경)
 성적삭제
 평점보기
 종료
 */
enum TestError : Error {
    case BadInput
    case AlreadyExist(name: String)
    case NoneExist(name: String)
    case NoSpaceORUncorrectOrder
}

class students_list {
    var list: Array<Student> = []
    
    ///student list에 접근하여 name이 vaild한지 확인, instance를 만들어 student list에저장 후 반환
    func assign(name:String?) throws -> Student {
        if let name = name{    //name optional binding
            for student in list { // check if it already have that name
                if student.name == name {
                    throw TestError.AlreadyExist(name:student.name) //if it so, throw Error AlreadyExist
                }
            }
            var new_student = Student(name: name) // name is valid. make a new instance.
            list.append(new_student)    //append instance to student list
            return list.last!   //return prescribed instance + instance의 존재가 확실하기 때문에 !를 써주었는데...확실치 않다.
        } else {    // if name is nil
            throw TestError.BadInput    //throw Error BadInput
        }
    }
    
    func search(name:String) -> Student? {
        for student in list {
            if student.name == name {
                return student
            }
        }
        return nil
    }
}

class menu_list {
    let menu_arr:[String] = ["1","2","3","4","5","X"]
    
    func doesContain(item:String?) throws -> Bool {
        if let item_name = item {
            if menu_arr.contains(item_name){
                return true
            }else {
                print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
            }
        } else {
            throw TestError.BadInput
        }
    }
}
struct  Student {
    var name: String
    var score: Dictionary<String, String>? = [:]
    
    init(name: String) {
        self.name = name
    }
    
    mutating func add_score(subject:String, score:String) {
        self.score?.updateValue(score, forKey: subject)
    }
    
    mutating func delect_score(subject:String) {
        self.score?.removeValue(forKey: subject)
    }
}




var Student_list: students_list = students_list()
var menu_arr: menu_list = menu_list()

while true {
    print("")
    let input_menu = readLine()!
    
}
func menu() {
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")
    let input = readLine()
    if menu_arr.contains(input){
        
        do {
            //let input_menu = try menu_arr.assign(name: student_name)
            //print("\(student.name) 학생을 추가했습니다.")
        } catch let error {
            print("\(error) 발생")
        }
        
    }
}

func add_student() {
    print("추가할 학생의 이름을 입력해주세요")
    let student_name = readLine()
        do {
            let student = try Student_list.assign(name: student_name)
            print("\(student.name) 학생을 추가했습니다.")
        } catch TestError.BadInput{
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            return
        } catch TestError.AlreadyExist(let exist_name){
            print("\(exist_name)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
            return
        } catch let error {
            print("\(error) 발생")
        }
   
}
/*
 예외 처리는 do-catch문이 있다잉 optional도 사용가능 + guard
 */
