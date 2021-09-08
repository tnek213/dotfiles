#
# function to filter out lines with a length exceeding $1, or
# the terminal columns if no argument is given
#

linemax() {
    cat | awk "{ if (length(\$0) <= ${1-${COLUMNS:-10000}}) { print } }"
}
