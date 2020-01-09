

fun! Grep_parse(keyword)
   let command = "grep -n ". a:keyword . " *"
   let output = system(command) 
   let output_lines = split(output, "\n")
   for line in output_lines
      let splitted_line = split(line, ":")
      
      echo "filename: " . splitted_line[0] . " linenumber: " . splitted_line[1] . " line:" . splitted_line[2] 
   endfor
endfun


fun! Stackoverflow_search(keyword)
    
    let stackoverflow_url="https://stackoverflow.com/search?q=". a:keyword
    let command = "open ". stackoverflow_url
    let output = system(command)
endfun


fun! OpenAndInsert(content)
    call setqflist([], ' ', {'title' : "title", 'context' :  {"cmd": "grep"} })
    let newItems = [{'filename' : 'a.txt', 'lnum' : 10, 'text' : "Apple"}, {}]
    call setqflist([], 'a', { 'items' : newItems})  
    copen

endfun


fun! Go_format()
    
    if (&ft=="go")
      w
      silent !go fmt  
      redraw!
      e!
    endif


endfun


fun! Go_run()
     
    if (&ft=="go")
      w
      let command = "go run ".  expand('%:t')
      let output = system(command)  
      
    endif




endfun
