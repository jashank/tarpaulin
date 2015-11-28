#!/bin/zsh

# assuming your Rust source tree is checked out in ../rust
cp -rp ../rust/src/doc src

mkdir -p tex/book
mkdir -p tex/nomicon
mkdir -p tex/langref

vers=$((cd ../rust && grep "CFG_RELEASE_NUM\=" mk/main.mk | sed -e 's/^.*=//'))
hash=$((cd ../rust && cat .git/refs/heads/master | cut -c-10))

echo "${vers} at \\texttt{${hash}}." > tex/version.tex

echo '\\input{book/README}' > tex/book/book.tex
(cat src/doc/book/SUMMARY.md \
     | grep '\*' \
     | sed -Ee 's/^\* \[(.*)\]\((.*).md\)/\\chapter{\1}\\input{book\/\2}/' \
     | sed -Ee 's/^    \* \[(.*)\]\((.*).md\)/\\section{\1}\\input{book\/\2}/') \
    >> tex/book/book.tex
echo '\\input{nomicon/README}' > tex/nomicon/nomicon.tex
(cat src/doc/nomicon/SUMMARY.md \
     | grep '\*' \
     | sed -Ee 's/^\* \[(.*)\]\((.*).md\)/\\chapter{\1}\\input{nomicon\/\2}/' \
     | sed -Ee 's/^	\* \[(.*)\]\((.*).md\)/\\section{\1}\\input{nomicon\/\2}/') \
    >> tex/nomicon/nomicon.tex

echo '\\chapter{Grammar}\\input{langref/grammar}' > tex/langref/langref.tex
echo '\\chapter{Reference}\\input{langref/reference}' >> tex/langref/langref.tex

for i in $(echo 1:book/README; \
    cat src/doc/book/SUMMARY.md \
    | grep '\*' \
    | sed -Ee 's/^\* \[(.*)\]\((.*).md\)/1:book\/\2/' \
    | sed -Ee 's/^    \* \[(.*)\]\((.*).md\)/2:book\/\2/') \
	 $(echo 1:nomicon/README; \
    cat src/doc/nomicon/SUMMARY.md \
    | grep '\*' \
    | sed -Ee 's/^\* \[(.*)\]\((.*).md\)/1:nomicon\/\2/' \
    | sed -Ee 's/^	\* \[(.*)\]\((.*).md\)/2:nomicon\/\2/') \
	 1:reference:langref/reference \
	 1:grammar:langref/grammar
do
    echo ${i} | sed -e 's/:/ /g' | read bhl file ofile

    if [ "X${ofile}" = "X" ]
    then
	ofile=${file}
    fi

    echo ${file}'{.md => .tex}'
    pandoc --from=markdown --to=latex --no-highlight --variable links-as-notes=true \
	   --toc --number-sections --base-header-level=${bhl} \
           --smart --normalize \
	   src/doc/${file}.md -o tex/${ofile}.tex
done
