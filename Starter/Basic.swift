import Foundation

var fruits: [String] = ["Apple", "Orange","Mango"]
var colors: Set = ["Blue", "Red", "Pink","Blue"]
var cityList: [String :[String]] = ["Yangon" :["Sanchaung","Kyimyindine","Ahlone"]]
var doOnNext:((String) -> String)? = {_ -> String in ""}


func main(){
    var name = "Khin Cho"
    name = "Cho Tint"
    
    let nickName = "Kcct"
    debugPrint(name)
    debugPrint(nickName)
    
    doOnNext = { name -> String in
        debugPrint("Hello \(name)")
        return "Hello \(name)"
    }
    
    
    fruits.append("Banana")
    debugPrint(fruits)
    for fruit in fruits{
        debugPrint(fruit)
    }
    
    
    debugPrint(colors)
    colors.insert("Purple")
    colors.insert("Red")
    debugPrint(colors)
    for color in colors{
        debugPrint(color)
    }
    
    
    let township = cityList["Yangon"] ?? []
    debugPrint(township)
     
    
    //debugPrint(myFunction(4))
    
    debugPrint(minMax(array: [3,4,1,7,3,0,4,6,9,11,8]))
    
    var indexForWhile = 0
    while indexForWhile < 3{
        debugPrint(fruits[indexForWhile])
        indexForWhile += 1
        
    }
    
    var indexRepeatWhile = 0
    repeat{
        debugPrint(indexRepeatWhile)
        indexRepeatWhile += 1
    }while indexRepeatWhile < 3
    
}

var myFunction:((Int) -> Bool)={ num in
    if num > 3{
        return true
    }
    return false
}

func minMax(array:[Int]) -> (min:Int, max:Int){
    var currentMin = array[0]
    var currentMax  = array[0]
    
    for value in array[1..<array.count]{
        if value < currentMin{
            currentMin = value
        }
        else if value > currentMax{
            currentMax = value
        }
    }
    return (currentMin, currentMax)
}

func increment(amount:Int)->()->Int{
    func doProcess()->Int{
        return amount
    }
    return doProcess
}


