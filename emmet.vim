


fun! GetTokens(input)

    let local_input = a:input
    let tokens = []

    while len(local_input) > 0 

        let token = GetToken(local_input)
        
        let type_value = {"type": token.type  , "value" : token.value }

        call add(tokens, type_value )
        
        let local_input =  local_input[token.end:]

    endwhile

    return tokens
endfun

fun! GetToken(input)
   let regex_tag = '\v[a-zA-Z_]+'
   let regex_lt = '\v\>'
   let regex_plus = '\v\+'
   let regex_up = '\v\^'
   let regex_mul = '\v\*'
   let regex_num = '\v\d+'
   let regex_lparen = '\v\('
   let regex_rparen = '\v\)'
   let regex_sharp = '\v\#'
   let regex_dot = '\v\.'
   
 
  


   let regex = '\v[a-zA-Z_]+|\>|\+|\^|\*|\d+|\(|\)|\#|\.' 
   let result =  matchstrpos(a:input, regex) 
   if matchstrpos(result[0], regex_tag)[1] != -1 
       return {"type" :"tag","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_lt)[1] != -1 
       return {"type" :"child","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_plus)[1] != -1 
       return {"type" :"plus","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_up)[1] != -1 
       return {"type" :"up","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_mul)[1] != -1 
       return {"type" :"mul","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_num)[1] != -1 
       return {"type" :"num","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_lparen)[1] != -1 
       return {"type" :"lparen","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_rparen)[1] != -1 
       return {"type" :"rparen","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_sharp)[1] != -1 
       return {"type" :"sharp","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_dot)[1] != -1 
       return {"type" :"dot","value" :result[0],"start": result[1], "end": result[2]}

   endif  
    
endfun
 
 

fun! Parser(tokens)
        
    let tokens = a:tokens

    let tree = [[]] 

    let stack = [] 
    
    let depth = 0

    let cur_node = tree 
   
    let root = {"children": []} 

    call add(stack, root)

    while len(tokens) > 0
       if tokens[0].type == "tag"
            call ParseTag(tokens, stack)
"            let cur_token = tokens[0] 
            "let cur_token.id = []
            "let cur_token.class = []
            "let cur_token.children = []

            "if len(tokens) > 1
                "if tokens[1].type == "mul"
                    "if tokens[2].type == "num"
                        "let tokens[0].count = tokens[2].value
                        "let tokens = tokens[2:]
                    "endif
                "elseif tokens[1].type == "sharp"
                    "call add(tokens[0].class,tokens[2].value)
                    "let tokens = tokens[2:]
                
                "elseif tokens[1].type == "dot"
                    "call add(tokens[0].id,tokens[2].value)
                    "let tokens = tokens[2:]
                "endif
 

            "endif
            
            "call add(stack[-1].children, cur_token) 

            "call add(stack, cur_token )

            "let tokens = tokens[1:]


        elseif tokens[0].type == "child"
                      
            let tokens = tokens[1:]
            call ParseTag(tokens, stack)
"

        elseif tokens[0].type == "plus"

            let stack = stack[:-2] 
            let tokens = tokens[1:]
            call ParseTag(tokens, stack)
"
        
        elseif tokens[0].type == "up"
            let depth = depth - 1 
            let tokens = tokens[1:]

        elseif tokens[0].type == "lparen"
            let tree_and_tokens = Parser(tokens[1:])
            let node = { "type" : "tree", "value": tree_and_tokens.tree } 
            call add(tree[depth], node)
            let tokens = tree_and_tokens.tokens

        elseif tokens[0].type == "rparen"
            let tokens = tokens[1:]
            break

        endif
    endwhile
    

    return { "tree": root, "tokens": tokens } 


endfun

fun! ParseTag(tokens, stack)
    call assert_equal(a:tokens[0].type, "tag")
    let cur_token = a:tokens[0] 
    let cur_token.id = []
    let cur_token.class = []
    let cur_token.children = []

    if len(a:tokens) > 1
        if a:tokens[1].type == "mul"
            if a:tokens[2].type == "num"
                let a:tokens[0].count = tokens[2].value
                "let a:tokens = a:tokens[2:]
                call remove(a:tokens, 0)
                call remove(a:tokens, 0)

            endif
        elseif a:tokens[1].type == "sharp"
            call add(a:tokens[0].class,a:tokens[2].value)
            "let tokens = a:tokens[2:]
            call remove(a:tokens, 0)
            call remove(a:tokens, 0)

       
        elseif a:tokens[1].type == "dot"
            call add(a:tokens[0].id,a:tokens[2].value)
            "let tokens = tokens[2:]
            call remove(a:tokens, 0)
            call remove(a:tokens, 0)


        endif


    endif
    
    call add(a:stack[-1].children, cur_token) 

    call add(a:stack, cur_token )
    call remove(a:tokens, 0)
    "let tokens = tokens[1:]

    "return {"token": tokens, "stack":stack}


endfun

fun! GenHTML(tree)
    
    

endfun




