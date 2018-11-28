all: data_dir report.html README.md report_letter_freq.pdf

clean:
	rm -rf data images output_data report.md report.html README.md report_letter_freq.pdf
	
#Make subdirectories
data_dir:
	mkdir -p data
	mkdir -p images
	mkdir -p output_data

report.html: report.rmd ./output_data/histogram.tsv ./images/histogram.png ./output_data/letters_freq.tsv ./images/letters_freq.png
	Rscript -e 'rmarkdown::render("$<")'
	
README.md: README.Rmd ./images/letters_freq.png
	Rscript -e 'rmarkdown::render("$<")'
	rm README.html

./images/histogram.png: ./output_data/histogram.tsv
	Rscript -e 'library(ggplot2); qplot(Length, Freq, data=read.delim("$<")); ggsave("$@")'
	rm Rplots.pdf

./output_data/histogram.tsv: ./R/histogram.r ./data/words.txt
	Rscript $<
	
report_letter_freq.pdf: report_letter_freq.Rmd ./images/letters_freq.png ./output_data/histogram.tsv ./output_data/letters_freq.tsv
	Rscript -e 'rmarkdown::render("$<")'
	
./images/letters_freq.png: ./output_data/letters_freq.tsv
	Rscript -e 'library(ggplot2); ggplot(data=read.delim("$<"), aes(x=letter, y=frequency)) + labs (title = "Absolute frequency of letters in words") + geom_bar(stat = "identity", fill= "plum") ; ggsave("$@")'
	rm Rplots.pdf
	
./output_data/letters_freq.tsv: ./R/letters_freq.r ./data/words.txt
	Rscript $<

./data/words.txt: /usr/share/dict/words
	cp $< $@

# words.txt:
#	Rscript -e 'download.file("http://svnweb.freebsd.org/base/head/share/dict/web2?view=co", destfile = "words.txt", quiet = TRUE)'
