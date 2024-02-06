* arguments are directory and aname (for a model name)
* space in directory or aname are not supported
args directory aname
local modname = "`directory'/`aname'"

set graphics off //so plots don't keep popping up

run sqreg9_savedataresults `modname'

run sqreg9_manyplots `modname'

