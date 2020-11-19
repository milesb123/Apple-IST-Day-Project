//
//  ContentView.swift
//  Personality Similarity Calculator
//
//  Created by Miles Broomfield on 18/11/2020.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct ContentView: View {
    
    @State var viewDisplayed = 0
    
    @State var name = ""
    
    var questions:[(String,[String])] = []
    @State var answers:[String] = []
    
    @State var score:Double?  = nil
    
    @State var op:Double = 0
    
    let db = Firestore.firestore().collection("Answers")
    
    var body: some View {
        VStack{
            if(viewDisplayed == 0){
                VStack(spacing:30){
                    Text("Personality Similiarity Calculator")
                        .font(.largeTitle)
                        .bold()
                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .opacity(op)
                        .animation(.easeInOut(duration: 2))
                        
                    TextField("Enter Name", text: $name)
                        .padding()
                        .border(Color.black)
                    Button(action:{
                        if(!name.isEmpty){
                            self.moveToView(view: 1)
                        }
                        

                    }){
                        Capsule()
                            .overlay(Text("Start Quiz").bold().foregroundColor(.white))
                            .frame(width:200,height:80)
                            .foregroundColor(.green)
                    }
                    
                    Text("By Miles B")

                }
                .onAppear{
                    op = 1
                }
            }
            else if(viewDisplayed == 1){
                VStack{
                    Text("Select an answer to move on")
                        .font(.subheadline)
                    
                    Text("\(answers.count + 1)/\(questions.count) \(questions[answers.count].0)")
                        .font(.title)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    List{
                        //assumption each answer is different
                        ForEach(questions[answers.count].1,id: \.self){answer in
                            Button(action:{self.answered(answer: answer)}){
                                Text("\(answer)")
                            }
                        }
                    }
                    Spacer()
                }
            }
            else if(viewDisplayed == 2){
                VStack(spacing:30){
                    if(score != nil){
                        Text("Hi \(name), you scored")
                            .bold()
                            
                        Text("\(Int(score! * 100))%")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)
                        Text("We calculated that your personality is similar to \(Int(score! * 100))% of people")
                            .multilineTextAlignment(.center)
                        
                        Button(action:{self.resetQuiz()}){
                            Capsule()
                                .overlay(Text("Start Again").foregroundColor(.white).bold())
                                .frame(width:200,height:80)
                                .foregroundColor(.green)
                                
                        }
                    }
                    else{
                        Text("Loading Score...")
                    }
                }
                .onAppear{
                    self.calculateSimiliarityScore()
                }
            }
            else{
                Text("We should not be here")
            }
        }
        .padding()
    }
    
    init(){
        let question1 = "Do you use Safari or Chrome?"
        let answers1:[String] = ["Safari", "Chrome"]
        let question2 = "Do you like pineapples on pizza?"
        let answers2:[String] = ["Yes","No"]
        let question3 = "Pick the best footwear brand from those listed below"
        let answers3:[String] = ["Nike","Addidas","Converse","Toms"]
        let question4 = "Do you use iPhone or android"
        let answers4:[String] = ["iPhone","Android"]
        let question5 = "Is water wet?"
        let answers5:[String] = ["Yes","No"]
        let question6 = "\" Hello \" was produced by which artist?"
        let answers6:[String] = ["Beyonce","Eminem","Evanescence","Adele"]
        let question7 = "It is okay to wear socks and sandals when?"
        let answers7:[String] = ["It's hot", "The sandals are nice", "Your a Dad", " It's 2015","It is not okay"]
        let question8 = "How many months have 28 days?"
        let answers8:[String] = ["1(February)", "None","All","What's a month?"]
        let question9 = "Would you love an internship at apple?"
        let answers9:[String] = ["I need it","I cannot imagine an internship at a different company","Yes","Si"]
        let question10 = "Will Elon Musk Colonise Mars by 2050"
        let answers10:[String] = ["He already has","Yes", "No"]
        
        questions.append(contentsOf: [(question1,answers1),(question2,answers2),(question3,answers3),(question4,answers4),(question5,answers5),(question6,answers6),(question7,answers7),(question8,answers8),(question9,answers9),(question10,answers10)])
    }
    
    func moveToView(view:Int){
        viewDisplayed = view
    }
    
    func answered(answer:String){
        self.answers.append(answer)
        if(answers.count == questions.count){
            self.moveToView(view: 2)
        }
    }
    
    func calculateSimiliarityScore(){
        
        var setOfSetOfAnswers:[[String]] = []
        
        // upload answers to answers document
        
        
        
        // get all documents from answers and convert into array of array of answers
        
        
        db.getDocuments(){ (snapshot, err) in
            if let err = err{
                print(err)
            }
            if let snapshot = snapshot{
                for document in snapshot.documents{
                    setOfSetOfAnswers.append(document.data()[entryNames.answers.rawValue] as! NSArray as! [String])
                }
                
                var totalScore:Double = 0
                for setOfAnswers in (0..<setOfSetOfAnswers.count){
                    var individualScore:Double = 0
                    let setA = setOfSetOfAnswers[setOfAnswers]
                    for answer in (0..<setA.count){
                        let a = setA[answer]
                        if(a == answers[answer]){
                            individualScore+=1
                        }
                    }
                    totalScore += individualScore
                }
                
                print(totalScore)
                print(setOfSetOfAnswers.count)
                print(questions.count)
                totalScore = totalScore/Double(setOfSetOfAnswers.count)/Double(questions.count)
                
                self.score = totalScore

            }
        }
        
        db.addDocument(data: [entryNames.name.rawValue:name,entryNames.answers.rawValue:answers])
        
        //print(setOfSetOfAnswers)
        
        //____________
        
        //total match
        
        
        //for each array of answers in set of answers
            //individual match
        //for each answer
            //if answer = my answer
                //add 1 to individual match
        
        //divide total match by the number of array of answers in set of answers
        
        //divide that by 10
        
        
        //average score / numbers of questions
        
    }
    
    func resetQuiz(){
        self.answers = []
        self.score = nil
        self.name = ""
        self.moveToView(view: 0)
    }
}

enum entryNames:String{
    
    case name
    case answers
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
