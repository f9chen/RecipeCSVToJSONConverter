import CSV
import Foundation

// MARK: - Models

class Recipe: Codable {
  let title: String
  var ingredients: [Ingredient] = []
  var steps: [Step] = []
  
  init(title: String) {
    self.title = title
  }
}

struct Ingredient: Codable {
  let measurement: String
  let preparation: String?
  let title: String
}

struct Step: Codable {
  let title: String
  let description: String
}


print("Hello, recipes!")

// MARK: - Set up

let folderPath = "/Users/f9chen/fchen-workspace/RecipeCSVToJSONConverter/Sources/RecipeCSVToJSONConverter/"
let ingredientsFileName = "ingredients.csv"
let stepsFileName = "steps.csv"

let ingredientsStream = InputStream(fileAtPath: "\(folderPath)\(ingredientsFileName)")!
let stepsStream = InputStream(fileAtPath: "\(folderPath)\(stepsFileName)")!
let ingredientsCsv = try! CSVReader(stream: ingredientsStream, hasHeaderRow: true, trimFields: true, delimiter: ",")
let stepsCsv = try! CSVReader(stream: stepsStream, hasHeaderRow: true, trimFields: true, delimiter: ",")

var recipes = [Recipe]()
var indexedRecipes = [String: Recipe]()

// MARK: - Process ingredients

var currentKey: String = "dummy"

while ingredientsCsv.next() != nil {
  let key = ingredientsCsv["key"]!
  
  // a new recipe
  if key != currentKey {
    currentKey = key
    
    let newRecipe = Recipe(title: ingredientsCsv["recipe_name"]!)
    
    recipes.append(newRecipe)
    indexedRecipes[key] = newRecipe
  }
  
  if let recipe = indexedRecipes[key] {
    let newIngredient = Ingredient(
      measurement: ingredientsCsv["measurement"]!,
      preparation: ingredientsCsv["preparation"]!.isEmpty ? nil : ingredientsCsv["preparation"]!,
      title: ingredientsCsv["title"]!)
    
    recipe.ingredients.append(newIngredient)
  }
}

// MARK: - Process steps

while stepsCsv.next() != nil {
  let key = ingredientsCsv["key"]!
  
  if let recipe = indexedRecipes[key] {
    let newStep = Step(
      title: stepsCsv["title"]!,
      description: stepsCsv["description"]!)
    
    recipe.steps.append(newStep)
  }
}

// MARK: - Generate JSON
let json = try? JSONEncoder().encode(["recipes" : recipes])
let jsonString = String(data: json!, encoding: String.Encoding.utf8) as String!
print("\(jsonString!)")



