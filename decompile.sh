
find . -name "*.class" | while read file
do
    class=`basename $file .class`
    out_file=$(dirname $file)/${class}.java
    echo "Decompiling $class"
    jad -p $file > $out_file
done
