


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
   let regex_tag = '\v[a-zA-Z_ 0-9]+'
   let regex_lt = '\v\>'
   let regex_plus = '\v\+'
   let regex_up = '\v\^'
   let regex_mul = '\v\*'
   let regex_num = '\v\d+'
   let regex_lparen = '\v\('
   let regex_rparen = '\v\)'
   let regex_sharp = '\v\#'
   let regex_dot = '\v\.'
   let regex_lbra = '\v\{'
   let regex_rbra = '\v\}'



   let regex = '\v[a-zA-Z_ 0-9]+|\>|\+|\^|\*|\d+|\(|\)|\#|\.|\{|\}' 
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
   elseif  matchstrpos(result[0], regex_lbra)[1] != -1 
       return {"type" :"lbra","value" :result[0],"start": result[1], "end": result[2]}
   elseif  matchstrpos(result[0], regex_rbra)[1] != -1 
       return {"type" :"rbra","value" :result[0],"start": result[1], "end": result[2]}



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
        elseif tokens[0].type == "child"
                      
            let tokens = tokens[1:]
            if tokens[0].type == "tag"
                call ParseTag(tokens, stack)
            endif


        elseif tokens[0].type == "plus"

            let stack = stack[:-2] 
            let tokens = tokens[1:]
            if tokens[0].type == "tag"
                call ParseTag(tokens, stack)
            endif
"
        
        elseif tokens[0].type == "up"
            
            let tokens = tokens[1:]
            let counter = 1
            
            while tokens[0].type == "up"
                 
                let tokens = tokens[1:]
                let counter = counter + 1 
    
            endwhile 
            
            let index = -counter - 2 
            if len(stack) < abs(inde) 
                let stack = stack[:index]
            elseif
                let stack = stack[:0]
            endif 
            
            call ParseTag(tokens, stack)
            


        elseif tokens[0].type == "lparen"
            let tree_and_tokens = Parser(tokens[1:])
            let node = { "type" : "tree", "value": tree_and_tokens.tree, "children":[] } 
            call add(tree[depth], node)
            let tokens = tree_and_tokens.tokens
            
            call add(stack[-1].children, node) 

            call add(stack, node)

        elseif tokens[0].type == "rparen"
            let tokens = tokens[1:]
            break

        elseif tokens[0].type == "lbra"
            let text_node = { "type": "text", "value": tokens[1].value}            
            call add(stack[-1].children, text_node) 
            call assert_equal(tokens[2].type ,"rbra")

            let tokens = tokens[3:]

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
                let a:tokens[0].count = a:tokens[2].value
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


        elseif a:tokens[1].type == "lbra"
            let text_node = { "type": "text", "value": a:tokens[2].value}            

            call add(cur_token.children, text_node) 
            
            call assert_equal(a:tokens[3].type ,"rbra")
            call remove(a:tokens, 0)
            call remove(a:tokens, 0)
            call remove(a:tokens, 0)

        endif


    endif
    
    call add(a:stack[-1].children, cur_token) 

    call add(a:stack, cur_token )
    call remove(a:tokens, 0)

endfun

fun! GenHTML(tree)
   let html = ""
   for subtree in a:tree
       let html = html . GenTag(subtree, 0)
   endfor 
   
   return html
    

endfun

fun! Compile(input)
   let tokens = GetTokens(a:input) 
   let tree = Parser(tokens)
   return GenHTML(tree.tree.children) 
endfun
    
fun! GenTag(tree, depth)
    let html = "" 
    let tag_type = a:tree.value



    if a:tree.type == "text" 
        let depth_index = 0
        
        let indent = "" 
        while a:depth > depth_index 
            let indent = indent . " " 
            let depth_index += 1
        endwhile
         
        let html = indent . a:tree.value . "\n"
    elseif a:tree.type == "tree"
        for child  in a:tree.value.children
             let html =  html . GenTag(child, a:depth) 
        endfor
    else

    let open_tag = "<" . tag_type      

    if has_key(a:tree, "id") && len(a:tree.id) > 0
        let id_attr = "id=\""
        
        for id in  a:tree.id 
            let id_attr = id_attr . id 
        endfor
         
        let id_attr = id_attr .  "\""
        let open_tag = open_tag . " " .id_attr 
        
    endif
     

    if has_key(a:tree, "class")  && len(a:tree.class) > 0
        let class_attr = "class=\""
        
        for class in  a:tree.class 
            let class_attr = class_attr . class . " "
        endfor
         
        let class_attr = class_attr .  "\""
        let open_tag = open_tag . " " . class_attr 
    endif
    
    let open_tag = open_tag . ">"


    let child_html = ""
    for child in a:tree.children 
       if child.type == "tree"
           for grand_child  in child.value.children
                let child_html =  child_html . GenTag(grand_child, a:depth + 4) 
           endfor
       else
           let child_html =  child_html . GenTag(child, a:depth + 4) 
       endif
    endfor
 
    let close_tag = "</" . tag_type . ">"
   
    let indent = ""
    
    let depth_index = 0
    while a:depth > depth_index 
        let indent = indent . " " 
        let depth_index += 1
    endwhile
     
    let html = indent . open_tag . "\n" .  child_html . indent .  close_tag . "\n" 

    if has_key(a:tree, "count")
            
        let index = 1 
        while a:tree.count > index
            let html = html . html
            let index = index + 1
        endwhile

    endif
    
    endif


    return html 

endfun



