```swift

디자인 패턴이란 
더 나은 방식으로 코드를 체계화시키는 데 도움이 되는 개념이다.

우리의 코드는 더 복잡한 앱을 만들 때 일수록 
점점 더 코드의 그 양이 많아지게 되고 복잡해진다.

우리 개발자는 그런 복잡성을 관리해야 한다.
그런 것들을 가능하게 해주는 것이 디자인 패턴이다.

디자인 패턴!
개발자가 선택할수 있는 아주 다양한 디자인 패턴이 있다.

많은 디자인 패턴중에서 최고의 모든걸 다가진 그런 디자인 패턴은 없다.

디자인 패턴은 일종의 건축 도면이라고 생각하면 편하다.

요구 사항에 따라 도면이 달라지기 때문에

내가 북극에서 이글루를 짓고 싶다면 도면이 달라질것이고.

내가 한국에서 한옥을 짓고싶다면 역시 도면이 달라질것이다.

당신은 한옥을 선호 하는가? 아파트를 선호하는가? 그건 사람의 성향에 따라 다를수 있을것이다.

디자인패턴 역시 개발자마다 선호하는 패턴은 다르다.

일부 개발자의 경우 가능한 한 적은 수의 코드 행을 원하지만 다른 프로그래머는 코드를 원할 것이다.

이번에 공부하는것은 가장 기본적인 디자인 패턴

모바일 앱을 만드는 방법을 배우는 모든 사람이 알아야하는 패턴

애플이 사용하기로 선택한 패턴

Model View Controller 줄여서 MVC디자인 패턴이라고 한다.

우리는 Model 과 View Controller 이 3가지 구성 요소를 함꼐 작동시켜 MVC디자인 패턴을 완성할수 있다.

모델은 모든 데이터와 해당 데이터들을 처리하는 논리를 처리하고

뷰는 사용자인터페이스로 이동하고 사용자와 상호작용하는 코드이다

컨트롤러는 모든것을 지휘하는 지휘자 같은것이다.

사용자가 사용자 인터페이스를 터치하면 
이러한 터치 이벤트를 통해 전송하는 컨트롤러에 대한 보기 구성 요소. 그런 다음 컨트롤러가 해석한다.
그것은 아마도 우리 모델에 일부 데이터에 대한 요청을 할 것이고 모델은 일부 비즈니스를 구현할 것이다.
어떤 식으로든 데이터를 논리 처리하고 처리한 다음 일부 형식화된 데이터를 출력하고 전송한다.
컨트롤러로 돌아갑니다.
이제 마지막으로 컨트롤러는 해당 데이터를 가져와 해석하고 관련 부분을 뷰로 보낸다.
사용자 인터페이스를 수정한다.
따라서 뷰와 모델은 서로 직접 통신하지 않으며 컨트롤러를 통해서만
그들은 상호 작용할 수 있다.

이런것들이 왜 필요한가?

내가 만약 어떤 어플을 만들었는데 세계적으로 인기가 많아져서 
외국어 버전을 만들어야할떄 내가 만약 MVC디자인 패턴으로 앱을 만들었다면
컨트롤러 또는 뷰를 목적을 위해 수정하면 된다.
MVC패턴이 그렇기 때문에 코드 재사용성이 좋다고 하는것이다.
그리고 MVC패턴은 오류를 줄이고 다른 MVC패턴을 아는 개발자들이 훨씬 더 쉽게 이해 할수 있다.


실제 앱을 만들때에 예시를 보면

ViewController는 컨트롤러
Main.storybord 는 뷰
내가 구조체 같은 데이터 묶음을 만들었다면 그것은 Model

우리의 코드를 MVC 디자인 패턴에 넣을것이다. 그러기 위해서는,
ViewController.swift를 분할해야 한다.

 컨트롤러는 실제로 이런 코드만 담겨야한다.
다른 구성 요소에 무엇을 하고 다른 구성 요소의 변경 사항에 응답하도록 지시하는 코드.
이것은 ViewController.swift가 사용자 상호작용으로 무엇을 처리해야 하는지를 의미한다.
보기 및 보기에 표시할 내용을 알려준다.
또한 모델에서 관련 데이터를 가져와 화면으로 보내고 모델에 업데이트하도록 지시해야 한다.

모든 데이터와 그 데이터를 논리 처리하는 코드는 모두 모델에 넣어야 한다.

MVC패턴의 실제 사용 예시


Model 코드 ============================================================
import Foundation

struct Question {
    let text: String
    let anwser: String
}


struct QuizBrain {
    
    var score = 0
    var questionNumber = 0
    
    let quiz = [
        Question(text: "4더하기 2는 6이다.", anwser: "맞다"),
        Question(text: "5 빼기 3은 1이다.", anwser: "아니다"),
        Question(text: "3더하기 8은 10이다.", anwser: "아니다"),
        Question(text: "2곱하기 2는 4다", anwser: "맞다"),
        Question(text: "10 곱하기 10은 100이다", anwser: "맞다")
    ]
    
    
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool {
        if userAnswer == quiz[questionNumber].anwser {
            score += 1
            return true
        } else {
            return false
        }
    }
    
    func getScore() -> Int {
        return score
    }
    
    func getQuestionText() -> String {
        return quiz[questionNumber].text
    }
    
    func getProgress() -> Float {
        let progress = Float(questionNumber) / Float(quiz.count)
        return progress
    }
    
    mutating func newQuestion() {
        if questionNumber + 1 < quiz.count {
            questionNumber += 1
        } else {
            questionNumber = 0
            score = 0
        }
        
    
    }
}

view ========================================================
메인 스토리보드










controller 코드 ================================================

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var trueButten: UIButton!
    @IBOutlet weak var falseButten: UIButton!
    @IBOutlet weak var ScoreLabel: UILabel!
    
    var quizBrain = QuizBrain()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = quizBrain.getQuestionText()
    }

    @IBAction func anserButtenPressed(_ sender: UIButton) {
    
        
        
        let userAnswer = sender.currentTitle!
        //문자열 true 아니면 문자열 false가 될것이다.
       let userGotItRight = quizBrain.checkAnswer(userAnswer)
        
        if userGotItRight == true {
            sender.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        } else {
            sender.backgroundColor = #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1)
        }
        
        quizBrain.newQuestion()
        
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    
    
    
   @objc func updateUI() {
    questionLabel.text = quizBrain.getQuestionText()
        trueButten.backgroundColor = UIColor.clear
        falseButten.backgroundColor = UIColor.clear
    progressBar.progress = quizBrain.getProgress()
    ScoreLabel.text = "점수: \(quizBrain.getScore())"
    }
}


```