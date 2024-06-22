import strutils
import sugar

proc get_recipes(path: string): seq[seq[string]] =
    # Returns list of tuples [recipe, ingredients]
    # Ingredients separated by ", "
    let 
        f = open(path)
    var 
        all_lines: seq[seq[string]] = @[]
        t = 0
    for line in lines path:
        if t > 0:
            all_lines.add(@[line.split('\t')])
        t += 1
    f.close()
    return all_lines

proc select(recipes: seq[seq[string]], fridge: seq[string], num_meals: int, max_ingreds: int): seq[string] = 
    # Returns num_meals meals, 
    # where the total number of ingredients in all meals
    # is as close as possible to max_ingreds
    # max ingreds is the max ingredients you are willing to buy, so if an ingredient is in the fridge it doesn't count.

    let ningreds = collect:
        for recipe in recipes:
            (recipe[0], len((recipe[1].split(","))))

    var 
        total_ingreds: int = 0
        total_meals: int = 0
        ingred_list: seq[string] = @[]
    for i, recipe in ningreds:
        let 
            new_ingreds = collect:
                for ing in recipes[i][1].split(", "):
                    if not fridge.contains(ing):
                        ing
            num_new = len(new_ingreds)
            max_meals_r: bool = total_meals + 1 <= num_meals
            max_ingreds_r: bool = total_ingreds + num_new <= max_ingreds
        # echo new_ingreds
        if max_meals_r and max_ingreds_r:
            ingred_list.add(recipes[i][0] & ": " & recipes[i][1])
            total_meals += 1
            total_ingreds += num_new
    return ingred_list

echo select(get_recipes("Recipes.txt"), @["can_tomato", "cream", "chicken"], 2, 6)