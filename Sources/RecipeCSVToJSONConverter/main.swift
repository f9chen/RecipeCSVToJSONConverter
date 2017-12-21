import CSV
import Foundation

print("Hello, recipes!")

let folderPath = "/Users/f9chen/fchen-workspace/RecipeCSVToJSONConverter/Sources/RecipeCSVToJSONConverter/"
let ingredientsFileName = "ingredients.csv"
let stepsFileName = "steps.csv"

let ingredientsStream = InputStream(fileAtPath: "\(folderPath)\(ingredientsFileName)")!
let stepsStream = InputStream(fileAtPath: "\(folderPath)\(stepsFileName)")!
let csv = try! CSVReader(stream: ingredientsStream)

while let row = csv.next() {
  print("\(row)")
}
