"""
    вариант 1 лаба 3
    реализация машинного обучения для игры Шесть пешек (Гарднер)
    по принципу MANAVE (Matchbox Educable Naughts And Crosses Engine) by Donald Michie
    по теории (https://ru.wikipedia.org/wiki/Hexapawn) из статьи на поле 3x3 всегда будут побеждать черные при оптимальной игре
"""


import copy
import random

variations = {1:{},2:{}}
size = 3
ai = 0

def generate_variations(variation, bot: bool):
    
    if not variation:
        return None
           
    # global variables
    
    # if bot is True:
    for i in range(size):
        for j in range(size):
            if bot is True:
                if variation[i][j] == 2:
                    # print(i,j)
                    generate_variations(validate_variation((i,j),(i+1,j), copy.deepcopy(variation) ), not bot)
                    generate_variations(validate_variation((i,j),(i+1,j+1), copy.deepcopy(variation) ), not bot)
                    generate_variations(validate_variation((i,j),(i+1,j-1), copy.deepcopy(variation) ), not bot)
            else:
                if variation[i][j] == 1:
                    # print(i,j)
                    generate_variations(validate_variation((i,j),(i-1,j), copy.deepcopy(variation) ), not bot)
                    generate_variations(validate_variation((i,j),(i-1,j-1), copy.deepcopy(variation) ), not bot)
                    generate_variations(validate_variation((i,j),(i-1,j+1), copy.deepcopy(variation) ), not bot)

    
    
    
def validate_variation(pon_pos, next_pon_pos, variation):
    
    if is_end_pos(variation):
        return []
    
    if variation[pon_pos[0]][pon_pos[1]] == 0:
        return []
    
    # global variations
    # print(variations)
    
    deltax = abs(pon_pos[0] - next_pon_pos[0])
    deltay = abs(pon_pos[1] - next_pon_pos[1])
    
    if (0 <= pon_pos[0] < size and 0 <= pon_pos[1] < size 
        and 0 <= next_pon_pos[0] < size and 0 <= next_pon_pos[1] < size):
        
        if deltay == 1:
            if (variation[next_pon_pos[0]][next_pon_pos[1]] not in [variation[pon_pos[0]][pon_pos[1]], 0]):
                # if variation not in variations: 
                #     variations[](copy.deepcopy(variation))
                
                var = from_list_to_string(copy.deepcopy(variation))
                # var2 = from_list_to_string((pon_pos,next_pon_pos))
                
                next_var = from_list_to_string(get_next_variation(pon_pos, next_pon_pos, copy.deepcopy(variation)))
                
                if var not in variations[variation[pon_pos[0]][pon_pos[1]]]: 
                    variations[variation[pon_pos[0]][pon_pos[1]]][var] = {}
                variations[variation[pon_pos[0]][pon_pos[1]]][var][next_var] = 1
                
                return get_next_variation(pon_pos, next_pon_pos, copy.deepcopy(variation))
            else:
                return []
        
        elif deltax == 1:
            if (variation[next_pon_pos[0]][next_pon_pos[1]] == 0):
    
                var = from_list_to_string(copy.deepcopy(variation))
                
                next_var = from_list_to_string(get_next_variation(pon_pos, next_pon_pos, copy.deepcopy(variation)))
                
                if var not in variations[variation[pon_pos[0]][pon_pos[1]]]: 
                    variations[variation[pon_pos[0]][pon_pos[1]]][var] = {}
                variations[variation[pon_pos[0]][pon_pos[1]]][var][next_var] = 1
                return get_next_variation(pon_pos, next_pon_pos, copy.deepcopy(variation))
            else:
                return []
                


def get_next_variation(pon_pos, next_pon_pos, variation):
    # print(variation[pon_pos[0]][pon_pos[1]])
    
     
    variation[next_pon_pos[0]][next_pon_pos[1]] = variation[pon_pos[0]][pon_pos[1]]
    variation[pon_pos[0]][pon_pos[1]] = 0
    
    
    return variation

# def is_end_pos(variation):
#     if 

def from_list_to_string(variation):
    string = ""
    
    for i in variation:
        for j in i:
            string += str(j)
    
    return string

def is_end_pos(variation):
    if 1 in variation[0]:
        return True
    elif 2 in variation[-1]:
        return True
    
    if (not '1'  in from_list_to_string(variation) or
        not '2' in from_list_to_string(variation)):
         return True
     
    return False

def machine_lerning(variation):
    global ai
    global variations
    poss_of_pons = "222000111"
    
    for i in range(1500):
        move_for_wight = []
        move_for_black = []
        
        while True:
            print_matrix_str(poss_of_pons)
            # ways = variation[ai+1][poss_of_pons]
            try:
                ways = variation[ai+1][poss_of_pons]
            except Exception as e:
                if ai:
                    for i in move_for_wight:
                        variations[1][i[0]][i[1]] += 1
                    for i in move_for_black:
                        if variations[2][i[0]][i[1]] > 1:
                            variations[2][i[0]][i[1]] -= 1
                    print('wight won')
                else:
                    for i in move_for_wight:
                        if variations[1][i[0]][i[1]] > 1: 
                            variations[1][i[0]][i[1]] -= 1
                    for i in move_for_black:
                        variations[2][i[0]][i[1]] += 1
                    print('black won')
                print('--------------')

                break
            ways2 = []
            
            for key, val in ways.items():
                for _ in range(val):
                    ways2.append(key)
            random.shuffle(ways2)
            poss_of_pons2 = random.choice(ways2)

            if ai:
                move_for_black.append((poss_of_pons, poss_of_pons2))
            else:
                move_for_wight.append((poss_of_pons, poss_of_pons2))
                
            poss_of_pons = poss_of_pons2   
            ai = (ai+1)%2
        ai = 0
        poss_of_pons = "222000111"
            
def print_matrix_str(matrix: str):
    global size
    for i in range(0,len(matrix),size):
        print(matrix[i:i+size])
    print('🔻')
        
        

var = [
    [2,2,2],
    [0,0,0],
    [1,1,1],
]

generate_variations(copy.deepcopy(var), False)
print(variations)
print("generating of variations's done")

machine_lerning(variations)

