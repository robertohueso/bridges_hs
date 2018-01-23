.PHONY: typeset

typeset:
	pandoc                          \
	  --from         markdown       \
	  --to           latex          \
	  --template     template.tex   \
	  --out          bridges.pdf \
	  --pdf-engine xelatex        \
	  bridges.md

clean:
	rm *.aux *.bbl *.blg *.brf *.idx *.ilg *.ind *.lof *.log *.lol *.lot *.out *.toc *.ysynctex.gz
