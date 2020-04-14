ALL_TEX = $(wildcard *.tex)

paper.pdf: $(ALL_TEX) tex_inputs/bibliography.bib tex_inputs/glossary.tex
	pdflatex paper.tex
	makeglossaries paper
	bibtex paper
	pdflatex paper.tex
	pdflatex paper.tex
