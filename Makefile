all: report.html

clean:
	rm -f words.txt histogram.tsv histogram.png report.md report.html letters_freq.tsv letters_freq.png

report.html: report.rmd histogram.tsv histogram.png letters_freq.tsv letters_freq.png
	Rscript -e 'rmarkdown::render("$<")'

histogram.png: histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

histogram.tsv: ./R/histogram.r ./Data/words.txt
	Rscript $<
	
letters_freq.png: letters_freq.tsv
	Rscript -e 'library(ggplot2); ggplot(data=read.delim("$<"), aes(x=letter, y=frequency)) + geom_bar(stat = "identity", fill= "plum"); ggsave("$@")'
	rm Rplots.pdf
	
letters_freq.tsv: ./R/letters_freq.r ./Data/words.txt
	Rscript $<

words.txt: /usr/share/dict/words
	cp $< $@

# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
